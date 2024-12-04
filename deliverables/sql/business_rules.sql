--1 CUSTOMER REGISTRATION
--A customer must register before placing an order. A customer will need to provide a unique email address and phone number. 
--The welcome email will be sent once a customer is registered. 

--accepts first name, last name, unique email, phone number, hash password
-- s24240370.trg_customer_logs_ProfG_FP - trigger (update insert delete) will be executed, will add action to the log
--error handling + transaction control + comments
exec s24240370.add_customer_ProfG_FP 'Tom', 'Kapelski', 'tomkapelski@example.com', '2301001023', '5f4dcc3b5aa765d61d8327deb882df99'
go

--code to check that the cusotmer was added
select top 1 c.customer_id, s24240370.get_full_name_ProfG_FP(c.customer_id) as full_name, e.email_address, p.phone_number
from s24240370.customers_ProfG_FP c
join s24240370.emails_ProfG_FP e
on c.customer_id = e.customer_id
join s24240370.phone_numbers_ProfG_FP p
on c.customer_id = p.customer_id
order by c.customer_id desc
go

--check trigger 
select log_id, entry_type, table_name, customer_id, full_name, entry_time from s24240370.logs_ProfG_FP
order by log_id desc
go

--to fail enter the same values
exec s24240370.add_customer_ProfG_FP 'Tom', 'Kapelski', 'tomkapelski@example.com', '2301001023', '5f4dcc3b5aa765d61d8327deb882df99'
go

-------------------------------------------------------------------------------------------------------------------------------------------

--2 ORDER PLACEMENT 
--A customer must be logged in and have a valid credit card on file to place an order. 
--The application will check the customer table and credit card table for valid information. 
--The confirmation email will be sent once the order is accepted. Every 10th orders the 5% off coupon must be sent. 

--check available quantity of the products before 
select top 3 p.product_id, p.product_name, c.name as category, p.stock as stock_quantity, p.reorder_level
from s24240370.categories_ProfG_FP c
right join s24240370.products_ProfG_FP p
on c.category_id = p.category_id
order by p.product_id
go

--declare required variables, 
declare @order_details s24240370.order_details_type_ProfG_FP
declare @cust_id int = 10
declare @credit_card_id int = 15
declare @order_date date = '2024-12-17'

--insert values into table variable
insert into @order_details
(product_id, quantity,total_price)
values
(1, 10, 5),
(2, 10, 3),
(3, 10, 2)

--create order, accepts customer id, credit card id, order date and order details (custom datatype: s24240370.order_details_type_ProfG_FP)
--can also accept comment, default is null
--will fire (insert) trigger s24240370.trg_insert_order_products_ProfG_FP - removes quantity from the products table 
--error handling + transaction control + comments
exec s24240370.add_order_ProfG_FP 
	@cust_id = @cust_id,
	@credit_card_id = @credit_card_id,
	@order_date = @order_date,
	@order_details = @order_details
go

--check if the order was placed
select top 1 order_id, customer_id, order_date, order_status, comment 
from s24240370.orders_ProfG_FP
order by order_id desc

--check available quanity after the product was placed 
select top 3 p.product_id, p.product_name, c.name as category, p.stock as stock_quantity, p.reorder_level
from s24240370.categories_ProfG_FP c
right join s24240370.products_ProfG_FP p
on c.category_id = p.category_id
order by p.product_id
go

---------------------------------------------------------------------------------------------------------------------------------------------

--3 CUSTOMER PASSWORD RESET
--A customer can reset their password. The application will update the customer table with a new password. 
--This rule will make personal information more secure and enhance customer experience by providing convenient ways to update credentials. 
--The confirmation email will be sent once the password is updated. 

--accepts user id and password (10 digits long)
--s24240370.trg_customer_logs_ProfG_FP - trigger (update insert delete) will be executed, will add action to the log

declare @cust_id int = 1

--check current password
select customer_id, s24240370.get_full_name_ProfG_FP(customer_id) as full_name, password
from s24240370.customers_ProfG_FP
where customer_id = @cust_id

--update password
--error handling + transaction control + comments
exec s24240370.user_password_reset_ProfG_FP @cust_id, 'asdertgndntsfdcsdfg'

--check current password
select customer_id, s24240370.get_full_name_ProfG_FP(customer_id) as full_name, password
from s24240370.customers_ProfG_FP
where customer_id = @cust_id
go

--check trigger 
select log_id, entry_type, table_name, customer_id, full_name, entry_time from s24240370.logs_ProfG_FP
order by log_id desc
go

--error
declare @cust_id int = 1

--check current password
select customer_id, s24240370.get_full_name_ProfG_FP(customer_id) as full_name, password
from s24240370.customers_ProfG_FP
where customer_id = @cust_id

--error
exec s24240370.user_password_reset_ProfG_FP @cust_id, 'asd'

--check current password
select customer_id, s24240370.get_full_name_ProfG_FP(customer_id) as full_name, password
from s24240370.customers_ProfG_FP
where customer_id = @cust_id
go

---------------------------------------------------------------------------------------------------------------------------------------------

--4 CUSTOMER PERSONAL INFORMATION MANAGEMENT 
--A customer must be able to add, remove, and alter their personal information, such as phone numbers, emails, and address. 
--Confirmation of the phone number should be done through a text message sent by the application. 

declare @cust_id int = 1
declare @new_email varchar(100) = 'new_email@email.com'
declare @phone varchar(10) = '1000000000'

--check before
select c.customer_id, e.email_address, p.phone_number  
from s24240370.customers_ProfG_FP c
left join s24240370.emails_ProfG_FP e
on c.customer_id = e.customer_id
left join s24240370.phone_numbers_ProfG_FP p
on c.customer_id = p.customer_id
where c.customer_id = @cust_id

--s24240370.trg_customer_logs_ProfG_FP - trigger (update insert delete) will be executed,

--by default primary email is updated, can use a @type parameter to change secondary email as well
--error handling + transaction control + comments
exec s24240370.customer_email_update_ProfG_FP @cust_id, @new_email 

--by default modile phone number is update, can use a @type parameter to use other phone number as well
--error handling + transaction control + comments
exec s24240370.customer_phone_number_update_ProfG_FP @cust_id, @phone 

select c.customer_id, e.email_address, p.phone_number  
from s24240370.customers_ProfG_FP c
left join s24240370.emails_ProfG_FP e
on c.customer_id = e.customer_id
left join s24240370.phone_numbers_ProfG_FP p
on c.customer_id = p.customer_id
where c.customer_id = @cust_id

go 

--to break enter the same values for a different customer , phone numbers and email are unique 
declare @cust_id int = 2
declare @new_email varchar(100) = 'new_email@email.com'
declare @phone varchar(10) = '1000000000'
exec s24240370.customer_email_update_ProfG_FP @cust_id, @new_email
exec s24240370.customer_phone_number_update_ProfG_FP @cust_id, @phone 
go
-----------------------------------------------------------------------------------------------------------------------------------------------
--5 REFUND PROCESSING
--Refunds must be processed securely. The application processes refunds and updates the payments table with the refund status. 
--the procedure is used by cancel s24240370.cancel_order_ProfG_FP procedure

declare @order_id int = 23
declare @payment_id int = 13
declare @is bit 

--check 
select o.order_id, o.customer_id, order_status, p.payment_id, p.amount, p.payment_date, p.type from s24240370.orders_ProfG_FP o
join s24240370.payments_ProfG_FP p
on o.order_id  = p.order_id
where o.customer_id = 2

--accepts order id and payment id
--if we cancel the payment that is not completed yet, the transaction will be changed
--if we cancel the payment that is completed, new transation will be placed 
--error handling + transaction control + comments
exec s24240370.issue_refund_ProfG_FP @order_id, @payment_id,  @is_started= @is output
select iif(@is = 1, 'success', 'fail') as refund_status

--check
select o.order_id, o.customer_id, order_status, p.payment_id, p.amount, p.payment_date, p.type from s24240370.orders_ProfG_FP o
join s24240370.payments_ProfG_FP p
on o.order_id  = p.order_id
where o.customer_id = 2
go 

------------------------------------------------------------------------------------------------------------------------------------------------

--6 ORDER CANCELATION 
--Orders can be canceled by customers begore they are delivered. T
--he application will check order status and update the order status to “canceled” if the cancelation is approved. 
--The confirmation email will be sent by the application with an optional survey. 

--check orders adn payment status 
select o.order_id, p.payment_id, o.order_status
from s24240370.orders_ProfG_FP o
join s24240370.payments_ProfG_FP p
on o.order_id = p.order_id
where o.order_status in ('on hold', 'received', 'processing')
order by o.order_id desc

declare @order_id int = 5 
declare @payment_id int = 20 --for error choose payment id and order id from different orders 

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

-----------------------------------------------------------------------------------------------------------------------------------------------

--7 ANALYTICS 
--The application must provide real-time reporting and analytics to support business decision-making.
--Reports must be updated in real-time based on the changes in the relevant tables. 
--comments 
declare @cust_id int = 2

--return the number of orders placed, the last time order placed total amount spent, canceled orders are not included
exec s24240370.check_customer_loyalty_ProfG_FP @cust_id
go

----------------------------------------------------------------------------------------------------------------------------------------------

--8 INVENTORY MANAGEMENT
--The product catalog must be up to date with accurate product details and availability. 
--The application will update the products table with the new inventory level whenever an order is placed, or product is restocked. 

--Inventory management is achieved through the use of the triggers: s
--24240370.trg_insert_order_products_ProfG_FP (insert) and s24240370.trg_canceled_orders_ProfG_FP (update)
--their performance was demonstrated above at # 2 and # 6
--comments
