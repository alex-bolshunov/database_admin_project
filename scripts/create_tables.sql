--create database project
--go
--drop database project
--drop database snapshot_project
--use project
--go

create schema prj
go

--drop schema prj

--customers table
create table prj.customers_ProfG_FP(
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL, 
    password VARCHAR(100) MASKED WITH (FUNCTION = 'default()') NOT NULL ,
    address VARCHAR(200) MASKED WITH (FUNCTION = 'default()') NOT NULL,
    registration_date DATE DEFAULT GETDATE()
)

go


--credit cards table
create table prj.credit_cards_ProfG_FP(
    credit_card_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    card_number VARCHAR(16) MASKED WITH (FUNCTION = 'partial(0,"XXXX XXXX XXXX ",4)') NOT NULL,
    cardholder_name VARCHAR(50) NOT NULL,
    exp_date DATE MASKED WITH (FUNCTION = 'default()') NOT NULL ,
    CVV VARCHAR(4) MASKED WITH (FUNCTION = 'default()') NOT NULL
)

go

--create phone number table
create table  prj.phone_numbers_ProfG_FP(
    phone_number_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    phone_number VARCHAR(10) MASKED WITH (FUNCTION = 'partial(0,"XXX-XXX-",4)') NOT NULL,
    type VARCHAR(50) check(type in('home','mobile', 'work'))
)
go

--create emaisl table
create table prj.emails_ProfG_FP (
    email_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    email_address VARCHAR(100) MASKED WITH (FUNCTION = 'email()') NOT NULL,
    type VARCHAR(50) check(type in('primary','secondary')) default 'primary'
)
go

--create orders table
create table prj.orders_ProfG_FP (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    order_date DATE DEFAULT GETDATE(),
    order_status VARCHAR(50) NOT NULL CHECK (order_status in ('collected', 'processing', 'received', 'canceled', 'on hold')),
	comment VARCHAR(50)
)
go


--create pickers table
create table prj.pickers_ProfG_FP (
	picker_id INT PRIMARY KEY IDENTITY(1,1),
	first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
	hire_date DATE DEFAULT GETDATE()
)
go

--create pickers_orders
create table prj.pickers_orders_ProfG_FP (
	order_id INT,
	picker_id INT,
	PRIMARY KEY (order_id, picker_id)
)
go

--create paymnets
create table prj.payments_ProfG_FP (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    credit_card_id INT,
	order_id INT,
	amount DECIMAL(10, 2) NOT NULL,
    payment_date DATE DEFAULT GETDATE(),
    status VARCHAR(50) NOT NULL CHECK (status in ('completed', 'pending', 'declined')),
	type VARCHAR(50) NOT NULL CHECK (type in('order', 'refund'))
)
go


create table prj.products_ProfG_FP (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    product_name VARCHAR(100) NOT NULL,
	producer VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(8, 2) NOT NULL,
    stock INT NOT NULL,
    description TEXT
)
go

create table prj.categories_ProfG_FP (
	category_id INT PRIMARY KEY IDENTITY(1,1),
	name VARCHAR(50) NOT NULL
)
go

create table prj.order_product_details_ProfG_FP (
	order_id INT NOT NULL,
	product_id INT NOT NULL,
	quantity INT DEFAULT 0,
	total_price DECIMAL(8,2) NOT NULL
	primary key(order_id, product_id)
)
go


--ADDING FOREIGH KEYS

--credit cards customers
alter table prj.credit_cards_ProfG_FP
add constraint fk_credit_cards_customers
FOREIGN KEY (customer_id) REFERENCES prj.customers_ProfG_FP(customer_id) 
go


--phone number customers
alter table prj.phone_numbers_ProfG_FP
add constraint fk_phone_numbers_customers
FOREIGN KEY (customer_id) REFERENCES prj.customers_ProfG_FP(customer_id)
go 

--email customers
alter table prj.emails_ProfG_FP 
add constraint fk_emails_customers
FOREIGN KEY (customer_id) REFERENCES prj.customers_ProfG_FP(customer_id) 
go

--orders customers
alter table prj.orders_ProfG_FP 
add constraint fk_orders_customers
FOREIGN KEY (customer_id) REFERENCES prj.customers_ProfG_FP(customer_id) 
go

--pickers orders 
alter table prj.pickers_orders_ProfG_FP
add constraint fk_pickers
FOREIGN KEY (picker_id) REFERENCES prj.pickers_ProfG_FP(picker_id);

alter table prj.pickers_orders_ProfG_FP
add constraint fk_orders
FOREIGN KEY (order_id) REFERENCES prj.orders_ProfG_FP(order_id);
go

--payments
alter table prj.payments_ProfG_FP
add constraint fk_payments_customers
FOREIGN KEY (customer_id) REFERENCES prj.customers_ProfG_FP(customer_id) 

alter table prj.payments_ProfG_FP
add constraint fk_payments_credits_cards
FOREIGN KEY (credit_card_id) REFERENCES prj.credit_cards_ProfG_FP(credit_card_id) 

alter table prj.payments_ProfG_FP
add constraint fk_payments_orders
FOREIGN KEY (order_id) REFERENCES prj.orders_ProfG_FP(order_id) 
go

--order details
alter table prj.order_product_details_ProfG_FP
add constraint fk_order_details_product
FOREIGN KEY(product_id) REFERENCES prj.products_ProfG_FP(product_id);

alter table prj.order_product_details_ProfG_FP
add constraint fk_order_details_orders
FOREIGN KEY(order_id) REFERENCES prj.orders_ProfG_FP(order_id);

go

--products
alter table prj.products_ProfG_FP
add constraint fk_category_id
FOREIGN KEY(category_id) REFERENCES prj.categories_ProfG_FP(category_id)
go

