--create database project
--go
--drop database project
--drop database snapshot_project
--use project
--go

create schema s24240370
go

--drop schema s24240370

--customers table
create table s24240370.customers_ProfG_FP(
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL, 
    password VARCHAR(100) MASKED WITH (FUNCTION = 'default()') NOT NULL ,
    address VARCHAR(200) MASKED WITH (FUNCTION = 'default()'),
    registration_date DATE DEFAULT GETDATE()
)
go


--credit cards table
create table s24240370.credit_cards_ProfG_FP(
    credit_card_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    card_number VARCHAR(16) MASKED WITH (FUNCTION = 'partial(0,"XXXXXXXXXXXX",4)') UNIQUE NOT NULL,
    cardholder_name VARCHAR(50) NOT NULL,
    exp_date DATE MASKED WITH (FUNCTION = 'default()') NOT NULL ,
    CVV VARCHAR(4) MASKED WITH (FUNCTION = 'default()') NOT NULL
)

go

--create phone number table
create table  s24240370.phone_numbers_ProfG_FP(
    phone_number_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    phone_number VARCHAR(10) MASKED WITH (FUNCTION = 'partial(0,"XXXXXX",4)') UNIQUE NOT NULL,
    type VARCHAR(6) check(type in('home','mobile', 'work')),
	constraint uc_customer_phone_number_type unique (customer_id, type)
)
go

--create emaisl table
create table s24240370.emails_ProfG_FP (
    email_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    email_address VARCHAR(100) MASKED WITH (FUNCTION = 'email()') UNIQUE NOT NULL,
    type VARCHAR(9) check(type in('primary','secondary')) default 'primary',
	constraint uc_customer_email_type unique (customer_id, type)
)
go

--create orders table
create table s24240370.orders_ProfG_FP (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    order_date DATE DEFAULT GETDATE(),
    order_status VARCHAR(20) NOT NULL CHECK (order_status in ('collected', 'processing', 'received', 'canceled', 'on hold')),
	comment VARCHAR(50)
)
go


--create pickers table
create table s24240370.pickers_ProfG_FP (
	picker_id INT PRIMARY KEY IDENTITY(1,1),
	first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
	hire_date DATE DEFAULT GETDATE()
)
go

--create pickers_orders
create table s24240370.pickers_orders_ProfG_FP (
	order_id INT,
	picker_id INT,
	PRIMARY KEY (order_id, picker_id)
)
go

--create paymnets
create table s24240370.payments_ProfG_FP (
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

--products
create table s24240370.products_ProfG_FP (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    product_name VARCHAR(100) NOT NULL,
	producer VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(8, 2) CHECK(price > 0) NOT NULL,
    stock INT NOT NULL CHECK (stock >= 0) default 0,
	reorder_level INT NOT NULL,
    description TEXT
)
go

--categories
create table s24240370.categories_ProfG_FP (
	category_id INT PRIMARY KEY IDENTITY(1,1),
	name VARCHAR(50) NOT NULL UNIQUE
)
go

--order_product_details, normalization
create table s24240370.order_product_details_ProfG_FP (
	order_id INT NOT NULL,
	product_id INT NOT NULL,
	quantity INT DEFAULT 0,
	total_price DECIMAL(8,2) NOT NULL
	primary key(order_id, product_id)
)
go

--keep logs on customers
create table s24240370.logs_ProfG_FP (
	log_id int primary key identity(1,1),
	entry_type varchar(100),
	table_name varchar(100),
	customer_id int,
	full_name varchar(100),
	change_time datetime default getdate()
)
go

--ADDING FOREIGH KEYS

--credit cards customers
alter table s24240370.credit_cards_ProfG_FP
add constraint fk_credit_cards_customers
FOREIGN KEY (customer_id) REFERENCES s24240370.customers_ProfG_FP(customer_id) on delete cascade 
go


--phone number customers
alter table s24240370.phone_numbers_ProfG_FP
add constraint fk_phone_numbers_customers
FOREIGN KEY (customer_id) REFERENCES s24240370.customers_ProfG_FP(customer_id) on delete cascade
go 


--email customers
alter table s24240370.emails_ProfG_FP 
add constraint fk_emails_customers
FOREIGN KEY (customer_id) REFERENCES s24240370.customers_ProfG_FP(customer_id) on delete cascade 
go

--orders customers
alter table s24240370.orders_ProfG_FP 
add constraint fk_orders_customers
FOREIGN KEY (customer_id) REFERENCES s24240370.customers_ProfG_FP(customer_id) on delete set null
go


--pickers orders 
alter table s24240370.pickers_orders_ProfG_FP
add constraint fk_pickers
FOREIGN KEY (picker_id) REFERENCES s24240370.pickers_ProfG_FP(picker_id);

alter table s24240370.pickers_orders_ProfG_FP
add constraint fk_orders
FOREIGN KEY (order_id) REFERENCES s24240370.orders_ProfG_FP(order_id);
go

--payments
alter table s24240370.payments_ProfG_FP
add constraint fk_payments_customers
FOREIGN KEY (customer_id) REFERENCES s24240370.customers_ProfG_FP(customer_id) 

alter table s24240370.payments_ProfG_FP
add constraint fk_payments_credits_cards
FOREIGN KEY (credit_card_id) REFERENCES s24240370.credit_cards_ProfG_FP(credit_card_id) 

alter table s24240370.payments_ProfG_FP
add constraint fk_payments_orders
FOREIGN KEY (order_id) REFERENCES s24240370.orders_ProfG_FP(order_id) 
go

--order details
alter table s24240370.order_product_details_ProfG_FP
add constraint fk_order_details_product
FOREIGN KEY(product_id) REFERENCES s24240370.products_ProfG_FP(product_id);

alter table s24240370.order_product_details_ProfG_FP
add constraint fk_order_details_orders
FOREIGN KEY(order_id) REFERENCES s24240370.orders_ProfG_FP(order_id);

go

--products
alter table s24240370.products_ProfG_FP
add constraint fk_category_id
FOREIGN KEY(category_id) REFERENCES s24240370.categories_ProfG_FP(category_id)
go

