--insert trigger
--increase the number of units in products table 
create or alter trigger s24240370.trg_insert_order_products_ProfG_FP
on s24240370.order_product_details_ProfG_FP
after insert
as
	begin

		declare @order_id int

		--get the lates order placed
		select top 1 @order_id = o.order_id
		from s24240370.orders_ProfG_FP o
		order by order_id desc

		--filter on the later order placed 
		update p
		set p.stock = p.stock - op.quantity
		from s24240370.products_ProfG_FP p
		join s24240370.order_product_details_ProfG_FP op
		on p.product_id = op.product_id
		where op.order_id = @order_id
	end
go

--update trigger
--if the order was canceled during the collection process, restock 
create or alter trigger s24240370.trg_canceled_orders_ProfG_FP
on s24240370.orders_ProfG_FP
after update
as
	begin

		declare @order_id int 
		
		--get order id that whose status was changed
		select @order_id = i.order_id 
		from (select order_id from inserted) i
		join (select order_id from deleted) d
		on i.order_id = d.order_id

		--add quantity back to stock
		update p
		set p.stock = p.stock + op.quantity
		from s24240370.products_ProfG_FP p
		join s24240370.order_product_details_ProfG_FP op
		on p.product_id = op.product_id
		where op.order_id = @order_id
	end
go

--update trigger
--send an email confirmation when the email is updated 
create or alter trigger s24240370.trg_update_email_ProfG_FP
on s24240370.emails_ProfG_FP
after update
as
	begin
		
		declare @customer_id int 
		declare @message varchar(50) = 'The email has been updated.'
		
		--get order id that whose status was changed
		select @customer_id = i.customer_id 
		from (select customer_id from inserted) i
		join (select customer_id from deleted) d
		on i.customer_id = d.customer_id

		exec s24240370.send_email_confirmation_ProfG_FP @customer_id, @message 
	end
go

--create trigger that would log changes on customer table
create or alter trigger s24240370.trg_customer_logs_ProfG_FP
on s24240370.customers_ProfG_FP
after update, insert, delete
as
	begin
		declare @entry_type varchar(100)
		declare @table_name varchar(100)  = 'customers_ProfG_FP'
		declare @id int 
		declare @full_name varchar(100) 
		
		--if insert
		if exists(select * from inserted) and not exists(select * from deleted)
			begin
				set @entry_type = 'insert'
				select @id = customer_id, @full_name = first_name + ' ' + last_name from inserted
			end

		--if delete
		else if exists(select * from deleted) and not exists(select * from inserted)
			begin
				set @entry_type = 'delete'
				select @id = customer_id, @full_name = first_name + ' ' + last_name from deleted
			end

		--if update
		else if exists(select * from deleted) and exists(select * from inserted)
			begin
				set @entry_type = 'update'

				select @id = i.customer_id, @full_name = i.first_name + ' ' + i.last_name
				from
				(select customer_id, first_name, last_name from inserted) i
				join
				(select customer_id, first_name, last_name from deleted) d
				on i.customer_id = d.customer_id
			end

		insert into s24240370.logs_ProfG_FP
		(entry_type, table_name, customer_id, full_name)
		values
		(@entry_type, @table_name, @id, @full_name)

	end
	go

--cannot delete picker if they currently colelcting order 
create or alter trigger s24240370.trg_instead_of_delete_picker_ProfG_FP
on s24240370.pickers_ProfG_FP
instead of delete
as
begin
	--check if the picker is currently collecting an order
	if exists (
		select 1 from s24240370.pickers_orders_ProfG_FP
		where picker_id in 
		(	select d.picker_id from deleted d
			join s24240370.pickers_orders_ProfG_FP po
			on d.picker_id = po.picker_id
			join s24240370.orders_ProfG_FP o
			on o.order_id = po.order_id
			where order_status in ('processing', 'on hold'))
		)
	begin
		select 'Cannot delete picker, he is currently active.' as message
		return --terminate the execution
	end

	--proceed with deletion
	delete
	from s24240370.pickers_ProfG_FP 
	where picker_id in (select picker_id from deleted)
end
go

--send notification after the category was removed from the database 
create or alter trigger s24240370.trg_category_removal_ProfG_FP
on s24240370.categories_ProfG_FP
after delete
as
begin
	
	declare @category_id int
	declare @category_name varchar(100)
	declare @message varchar(300)

	select @category_id = category_id, @category_name = name
	from deleted

	set @message = @category_name + ' (id: ' + cast(@category_id as varchar) + ') was removed as category.'


	exec s24240370.send_email_confirmation_ProfG_FP @message = @message 
end
go


--mark the cusotmer as suspicious after certain number of credit cards added
create or alter trigger s24240370.trg_num_credit_cards_ProfG_FP
on s24240370.credit_cards_ProfG_FP
after insert
as
begin
	declare @cust_id int
	declare @num_card_id int
	declare @threshold int = 4

	--get customer id
	select @cust_id = customer_id from inserted

	--check number of credit cards 
	select @num_card_id = count(credit_card_id)
	from s24240370.credit_cards_ProfG_FP
	where @cust_id = customer_id
	group by customer_id

	if @num_card_id > @threshold
		begin
			exec s24240370.mark_customer_as_suspicious_ProfG_FP @cust_id = @cust_id
		end

end

go

--trigger before deleting a customer copy everying to archive
create or alter trigger s24240370.trg_customer_archive_ProfG_FP
on s24240370.customers_ProfG_FP
instead of delete
as
begin
	
	declare @cust_id int

	--get customer id
	select @cust_id = customer_id from deleted

	--copy required information to archive table
	insert into s24240370.customers_archive_ProfG_FP 
	(former_cust_id, first_name, last_name, primary_email, address, registration_date)
	select 
	c.customer_id, c.first_name, c.last_name, e.email_address, c.address, c.registration_date
	from deleted c
	left join s24240370.emails_ProfG_FP e
	on c.customer_id = e.customer_id
	where e.type = 'primary' and
	c.customer_id = @cust_id

	--remove value from original table 
	delete from 
	s24240370.customers_ProfG_FP
	where customer_id = @cust_id

end
go