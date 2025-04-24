
--1
--1 sales summary
--accepts one parameter - num of days, uses custom function get_date_specified_period 
create or alter procedure s24240370.get_sales_summary_ProfG_FP @num_of_days int = 100
as
begin
	--use subquery to group by customer id
	--use aggrigation functions to calculate num of orders, average and total revenue
	select count(t.num_orders) as number_of_orders, round(avg(total), 2) as average_order_value, sum(total) as revenue, @num_of_days as number_of_days
	from (
		select count(1) as num_orders, sum(op.total_price) as total  
		from s24240370.orders_ProfG_FP o
		join s24240370.order_product_details_ProfG_FP op
		on o.order_id = op.order_id
		where o.order_date >= s24240370.get_date_specified_period_ProfG_FP(@num_of_days)
		group by o.order_id) as t
end
go

--2
--3 Order Frequency
-- accepts customer id
create or alter procedure s24240370.get_order_frequency_ProfG_FP @cust_id int
as
begin 
	--group by the month, count number of orders in each month
	select datepart(month, order_date) as month, count(o.order_id) as num_orders
	from s24240370.orders_ProfG_FP o
	right join s24240370.customers_ProfG_FP c
	on o.customer_id = c.customer_id
	where c.customer_id = @cust_id
	group by datepart(month, order_date)
end 
go


--3 (json)
--4 Customer Preferences
--accepts customer id 
create or alter procedure s24240370.get_customer_preferences_json_ProfG_FP @cust_id int
as
begin
	-- join orders and products, filter by cust id, group by product id and name, json 
	select top 5 p.product_id, p.product_name, sum(op.quantity) as quantity 
	from s24240370.orders_ProfG_FP o
	join s24240370.order_product_details_ProfG_FP op
	on o.order_id = op.order_id
	join s24240370.products_ProfG_FP p
	on op.product_id = p.product_id
	where o.customer_id = @cust_id
	group by p.product_id, p.product_name
	order by quantity desc
	for json path
end
go


--4
--7 Frequent Cancelers, uses - full name function
--accepts number of days and threshold 
create or alter procedure s24240370.get_frequent_cancelers_ProfG_FP @num_of_days int = 100, @threshold int = 1
as
begin
	--join customers and orders, filter on type of the order, group by customer id and full name
	--filter groups by the number of canceled orders
	select c.customer_id, s24240370.get_full_name_ProfG_FP(c.customer_id) as full_name, count(o.order_id)  as num_canceled_orders, @num_of_days as last_num_days
	from s24240370.customers_ProfG_FP c
	join s24240370.orders_ProfG_FP o
	on c.customer_id = o.customer_id
	where o.order_status = 'canceled' and
	o.order_date >= s24240370.get_date_specified_period_ProfG_FP(@num_of_days)
	group by c.customer_id, s24240370.get_full_name_ProfG_FP(c.customer_id)
	having count(o.order_id) > @threshold
	order by num_canceled_orders desc
end
go


--5
--8 Customer Credit Card Count Report
--accepts customer id 
create or alter procedure s24240370.get_customer_credit_card_count_ProfG_FP @cust_id int
as
begin
	--join customers and credit cards, show card id and card number 
	select cc.credit_card_id, cc.card_number
	from s24240370.customers_ProfG_FP c
	left join s24240370.credit_cards_ProfG_FP cc
	on c.customer_id = cc.customer_id
	where c.customer_id = @cust_id
end
go


--6 (json)
--12 Order Status
--accepts order id 
create or alter procedure s24240370.get_order_details_ProfG_FP @order_id int
as
begin
	--join customers, orders and order details, filter on order id, group by repeated fields
	--show order id, status, full name, total price, number of units in the order, date, and comment
	select o.order_id, o.order_status, s24240370.get_full_name_ProfG_FP(c.customer_id) as full_name, 
			sum(op.total_price) as total_price, sum(op.quantity) as num_of_units, o.order_date, o.comment
	from s24240370.orders_ProfG_FP o
	join s24240370.customers_ProfG_FP c
	on o.customer_id = c.customer_id
	join s24240370.order_product_details_ProfG_FP op
	on o.order_id = op.order_id
	where o.order_id = @order_id 
	group by o.order_id, s24240370.get_full_name_ProfG_FP(c.customer_id), o.order_status, o.comment, o.order_date
	for json path
end
go


--7 (json)
--14 Payment Status
--accepts order id
create or alter procedure s24240370.get_payment_status_ProfG_FP @order_id int
as
begin
	--join, orders, payments, and credit cards, filter on order id, json
	select o.order_id, p.amount, c.card_number, p.status, p.payment_date 
	from s24240370.orders_ProfG_FP o 
	join s24240370.payments_ProfG_FP p
	on o.order_id = p.order_id
	join s24240370.credit_cards_ProfG_FP c
	on p.credit_card_id = c.credit_card_id
	where o.order_id = @order_id
	for json path 
end
go