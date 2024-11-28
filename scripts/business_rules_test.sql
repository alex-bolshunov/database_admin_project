
--loyalty 1
create procedure s24240370.check_customer_loyalty_ProfG_FP @cust_id int
--rule
--Customer Loyalty: Which customers are the most loyal based on their number of orders and total spend?
--returne the number of orders placed, the last time order placed total amount spent
as
	begin
		--define variables
		declare @is_present int = 0
		declare @num_orders_placed int = 0
		declare @last_time_placed date = null
		declare @total_amount_spent decimal(8,2) = 0
		declare @full_name varchar(100) = ''
		
		--check if the customer exists
		select @is_present = count(customer_id) from s24240370.customers_ProfG_FP
		where customer_id =  @cust_id

		if @is_present = 0
			select 'no customer found' as result
		else
			begin
				--get relevant values if the customer exists
				select @full_name = first_name + ' ' + last_name from s24240370.customers_ProfG_FP
				where customer_id = @cust_id

				select @num_orders_placed = count(o.customer_id), @total_amount_spent = sum(p.amount) from s24240370.orders_ProfG_FP o
				join s24240370.payments_ProfG_FP p
				on o.order_id = p.order_id
				where o.customer_id = @cust_id and p.status = 'completed' and p.type = 'order'
				group by o.customer_id

				select @last_time_placed =  p.payment_date from s24240370.orders_ProfG_FP o
				join s24240370.payments_ProfG_FP p
				on o.order_id = p.order_id
				where o.customer_id = @cust_id
				order by p.payment_date
				
				select @cust_id as customer_id,  @full_name as full_name, @num_orders_placed as number_of_collected_orders,
						@total_amount_spent as total_spent, @last_time_placed as last_placed  

			end
	end
go


create procedure s24240370.orders_per_month_by_customer_ProfG_FP @cust_id int
--rule
--Order Frequency: How often does a specific customer place orders?
as
	begin
		declare @is_present int = 0

		--check if the customer exists
		select @is_present = count(customer_id) from s24240370.customers_ProfG_FP
		where customer_id =  @cust_id

		if @is_present > 0
			begin
				--get relevant values if the cusotmer exists
				select c.customer_id, c.first_name + ' ' + c.last_name as full_name,  DATEPART(MONTH, order_date) as month, COUNT(o.order_id) as num_orders
				from s24240370.orders_ProfG_FP o
				right join s24240370.customers_ProfG_FP c
				on o.customer_id = c.customer_id
				where c.customer_id = @cust_id
				group by DATEPART(MONTH, order_date), c.customer_id, c.first_name + ' ' + c.last_name
			end
		else
			select 'customer id not found' as result
	end

				
create user test_user without login;

grant select on s24240370.emails_ProfG_FP to test_user;

execute as user = 'test_user'
select * from s24240370.phone_numbers_ProfG_FP
revert