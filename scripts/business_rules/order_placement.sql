--create type to pass as a parameter to procedure 
create type s24240370.order_details_type_ProfG_FP as table
	(product_id int, quantity int, total_price decimal(8,2))
go

--create store procedure 
create or alter procedure s24240370.add_order_ProfG_FP
	@cust_id int, @credit_card_id int, @order_date date,
	@order_details s24240370.order_details_type_ProfG_FP readonly, @comment varchar(50) = null

as
	begin
		declare @order_id int
		declare @amount decimal(8, 2)
		declare @payment_date date = getdate()
		declare @order_status varchar(15) = 'received'
		declare @payment_status varchar(7) = 'pending'
		declare @type varchar(5) = 'order'


		begin try
			begin transaction
			--insert into orders
			insert into s24240370.orders_ProfG_FP 
			(customer_id, order_date, order_status, comment)
			values
			(@cust_id, @order_date, @order_status, @comment)
			
			set @order_id = scope_identity()

			--insert into order_product_details
			insert into s24240370.order_product_details_ProfG_FP
			select @order_id, product_id, quantity, total_price from @order_details

			--calculate total for the order 
			select @amount = sum(total_price)
			from @order_details
			
			--insert into payments
			insert into s24240370.payments_ProfG_FP
			(customer_id, credit_card_id, order_id, amount, status, payment_date, type)
			values
			(@cust_id, @credit_card_id, @order_id, @amount, @payment_status, @payment_date, @type)

			commit transaction
			select 'Order created. Order id: ' + cast(@order_id as varchar(10))  as message
		end try
		begin catch
			rollback transaction
			select 'Error occured' as message
		end catch
	end
go

--declare required variables
--declare @order_details s24240370.order_details_type_ProfG_FP
--declare @cust_id int = 10
--declare @credit_card_id int = 15
--declare @order_date date = '2024-12-12'

--insert values into table variable
--insert into @order_details
--(product_id, quantity,total_price)
--values
--(1, 10, 5),
--(2, 10, 3),
--(3, 10, 2)


--create order 
--exec s24240370.add_order_ProfG_FP 
	--@cust_id = @cust_id,
	--@credit_card_id = @credit_card_id,
	--@order_date = @order_date,
	--@order_details = @order_details
--go


--select * from s24240370.orders_ProfG_FP
--order by order_id desc


--select c.customer_id, cc.credit_card_id from s24240370.customers_ProfG_FP c
--join s24240370.credit_cards_ProfG_FP cc
--on c.customer_id= cc.customer_id
--where c.customer_id = 10