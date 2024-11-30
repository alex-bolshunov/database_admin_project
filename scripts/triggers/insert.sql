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