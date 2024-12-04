--1 insert trigger
--increase the number of units in products table 
--check s24240370.trg_insert_order_products_ProfG_FP on s24240370.order_product_details_ProfG_FP

--check available quantity of the products before 
select top 6 p.product_id, p.product_name, c.name as category, p.stock as stock_quantity, p.reorder_level
from s24240370.categories_ProfG_FP c
right join s24240370.products_ProfG_FP p
on c.category_id = p.category_id
order by p.product_id desc


--declare required variables, 
declare @order_details s24240370.order_details_type_ProfG_FP
declare @cust_id int = 7
declare @credit_card_id int = 10
declare @order_date date = '2024-12-09'

--insert values into table variable
insert into @order_details
(product_id, quantity,total_price)
values
(30, 5, 17.5),
(29, 5, 10),
(28, 5, 25),
(27, 5, 20)

--create order, accepts customer id, credit card id, order date and order details (custom datatype: s24240370.order_details_type_ProfG_FP)
--can also accept comment, default is null
--will fire (insert) trigger s24240370.trg_insert_order_products_ProfG_FP - removes quantity from the products table 
--error handling + transaction control + comments
exec s24240370.add_order_ProfG_FP 
	@cust_id = @cust_id,
	@credit_card_id = @credit_card_id,
	@order_date = @order_date,
	@order_details = @order_details

--check available quanity after the product was placed 
select top 6 p.product_id, p.product_name, c.name as category, p.stock as stock_quantity, p.reorder_level
from s24240370.categories_ProfG_FP c
right join s24240370.products_ProfG_FP p
on c.category_id = p.category_id
order by p.product_id desc
go

--------------------------------------------------------------------------------------------------------------------------------------------

--2 update trigger
--if the order was canceled during the collection process, restock 
--s24240370.trg_canceled_orders_ProfG_FP on s24240370.orders_ProfG_FP

--check orders adn payment status 
select o.order_id, p.payment_id, o.order_status
from s24240370.orders_ProfG_FP o
join s24240370.payments_ProfG_FP p
on o.order_id = p.order_id
where o.order_status in ('on hold', 'received', 'processing')
order by o.order_id desc

declare @order_id int = 8 
declare @payment_id int = 8 

--show available quantity of the products the customer ordered before cancelation
select product_id, product_name, stock from s24240370.products_ProfG_FP
where product_id in
(select p.product_id from s24240370.orders_ProfG_FP o
join  s24240370.order_product_details_ProfG_FP op
on o.order_id = op.order_id
join s24240370.products_ProfG_FP p
on p.product_id = op.product_id
where o.order_id = @order_id )

--show names and quantity  of the products that were in the order 
select p.product_id, p.product_name, op.quantity from s24240370.orders_ProfG_FP o
join  s24240370.order_product_details_ProfG_FP op
on o.order_id = op.order_id
join s24240370.products_ProfG_FP p
on p.product_id = op.product_id
where o.order_id = @order_id

--will fire s24240370.trg_canceled_orders_ProfG_FP to restock products if the order is still in the store
--error handling + transaction control + comments
exec s24240370.cancel_order_ProfG_FP @order_id, @payment_id

--show available quantity of the products the customer ordered after cancelation
select product_id, product_name, stock from s24240370.products_ProfG_FP
where product_id in
(select p.product_id from s24240370.orders_ProfG_FP o
join  s24240370.order_product_details_ProfG_FP op
on o.order_id = op.order_id
join s24240370.products_ProfG_FP p
on p.product_id = op.product_id
where o.order_id = @order_id )
go

---------------------------------------------------------------------------------------------------------------------------------------------

--3 update trigger
--send an email confirmation when the email is updated 
--s24240370.trg_update_email_ProfG_FP on s24240370.emails_ProfG_FP

declare @cust_id int = 2
declare @new_email varchar(100) = 'second_new_email@email.com'
declare @phone varchar(10) = '1212121219'

--check before
select c.customer_id, e.email_address
from s24240370.customers_ProfG_FP c
left join s24240370.emails_ProfG_FP e
on c.customer_id = e.customer_id
left join s24240370.phone_numbers_ProfG_FP p
on c.customer_id = p.customer_id
where c.customer_id = @cust_id

--change email 
exec s24240370.customer_email_update_ProfG_FP @cust_id, @new_email 

--check after
select c.customer_id, e.email_address
from s24240370.customers_ProfG_FP c
left join s24240370.emails_ProfG_FP e
on c.customer_id = e.customer_id
left join s24240370.phone_numbers_ProfG_FP p
on c.customer_id = p.customer_id
where c.customer_id = @cust_id
go

--------------------------------------------------------------------------------------------------------------------------------------------- 

--4 update/insert/delete
--trigger that would log changes on customer table
--s24240370.trg_customer_logs_ProfG_FP on s24240370.customers_ProfG_FP
-- if 3 was executed, the logs will contain the info 

declare @cust_id int 

--add user
exec s24240370.add_customer_ProfG_FP 'Oleksii', 'Bolshunov', 'oleksiibolshunov@email.my', '9177326498', 'my_password12345'

select top 1 @cust_id = customer_id from s24240370.customers_ProfG_FP
order by customer_id desc;

--remove user
delete
from s24240370.customers_ProfG_FP
where customer_id = @cust_id

select log_id, entry_type, customer_id, entry_time 
from s24240370.logs_ProfG_FP
order by entry_time desc
go 

-----------------------------------------------------------------------------------------------------------------------------------------------

--5 delete trigger, before deleting a customer copy everying to archive
--s24240370.trg_customer_archive_ProfG_FP on s24240370.customers_ProfG_FP
--if 4 was executed will archive will contain info

select former_cust_id, last_name, primary_email, registration_date 
from s24240370.customers_archive_ProfG_FP
go

----------------------------------------------------------------------------------------------------------------------------------------------
--6 delete trigger
--cannot delete picker if they currently colelcting order 
--s24240370.trg_instead_of_delete_picker_ProfG_FP on s24240370.pickers_ProfG_FP

declare @picker_id int 

select p.picker_id, p.last_name, o.order_id, o.order_status 
from s24240370.pickers_ProfG_FP p
join s24240370.pickers_orders_ProfG_FP po
on p.picker_id = po.picker_id
join s24240370.orders_ProfG_FP o
on po.order_id = o.order_id
where o.order_status in ('processing', 'on hold')

select top 1 @picker_id = p.picker_id
from s24240370.pickers_ProfG_FP p
join s24240370.pickers_orders_ProfG_FP po
on p.picker_id = po.picker_id
join s24240370.orders_ProfG_FP o
on po.order_id = o.order_id
where o.order_status in ('processing', 'on hold')
order by p.picker_id

--should show the message that the picker cannot be removed 
delete
from s24240370.pickers_ProfG_FP
where picker_id = @picker_id
go

--------------------------------------------------------------------------------------------------------------------------------------------------

-- 7 delete trigger
--send notification after the category was removed from the database 
--s24240370.trg_category_removal_ProfG_FP on s24240370.categories_ProfG_FP

declare @category_id int = 8

select top 10 category_id, name 
from s24240370.categories_ProfG_FP
order by category_id

--the message should be shown
delete
from s24240370.categories_ProfG_FP
where category_id = @category_id

select top 10 category_id, name 
from s24240370.categories_ProfG_FP
order by category_id
go

-----------------------------------------------------------------------------------------------------------------------------------------------
--8 insert 
--mark the cusotmer as suspicious after certain number of credit cards added
--s24240370.trg_num_credit_cards_ProfG_FP on s24240370.credit_cards_ProfG_FP
--trigger uses a set threshold that can be adjusted according to business needs 

--check number of cards and suspicious status of top 5 users with large num of cards 
select c.customer_id, c.suspicious as suspicious_status, count(cc.credit_card_id) as num_of_cards from s24240370.customers_ProfG_FP c
join s24240370.credit_cards_ProfG_FP cc
on c.customer_id = cc.customer_id
group by c.customer_id, c.suspicious
having count(cc.credit_card_id) > 1
order by count(cc.credit_card_id) desc

declare @cust_id int 

--set variable 
select top 1 @cust_id = c.customer_id
from s24240370.customers_ProfG_FP c
join s24240370.credit_cards_ProfG_FP cc
on c.customer_id = cc.customer_id
group by c.customer_id, c.suspicious
having count(cc.credit_card_id) > 1
order by count(cc.credit_card_id) desc

--insert value
insert into s24240370.credit_cards_ProfG_FP
(customer_id, card_number, cardholder_name, exp_date, cvv)
values
(@cust_id, '1234567890123456', 'Cool Name', '2028-12-01', '367')

--check if the customer is suspisious 
select c.customer_id, c.suspicious as suspicious_status, count(cc.credit_card_id) as num_of_cards from s24240370.customers_ProfG_FP c
join s24240370.credit_cards_ProfG_FP cc
on c.customer_id = cc.customer_id
where c.customer_id = @cust_id
group by c.customer_id, c.suspicious
go

----------------------------------------------------------------------------------------------------------------------------------------------
