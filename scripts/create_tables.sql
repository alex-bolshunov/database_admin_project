--create database project
--go

--use project
--go

 --create schema prj
--go


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
	payment_id INT, 
    card_numer VARCHAR(16) MASKED WITH (FUNCTION = 'partial(0,"XXXX XXXX XXXX ",4)') NOT NULL,
    cardholder_name VARCHAR(50) NOT NULL,
    exp_date DATE MASKED WITH (FUNCTION = 'default()') NOT NULL ,
    CVV VARCHAR(4) MASKED WITH (FUNCTION = 'default()') NOT NULL
)

go

--create phone number table
create table  prj.phone_numbers_ProfG_FP(
    phone_number_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
	picker_id INT,
    phone_number VARCHAR(10) MASKED WITH (FUNCTION = 'partial(0,"XXX-XXX-",4)') NOT NULL,
    type VARCHAR(50) check(type in('home','modile', 'work'))
)
go

--create emaisl table
create table prj.emails_ProfG_FP (
    email_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    meail_address VARCHAR(100) MASKED WITH (FUNCTION = 'email()') NOT NULL,
    type VARCHAR(50) check(type in('primary','secondary'))
)
go

--create orders table
create table prj.orders_ProfG_FP (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    order_date DATE DEFAULT GETDATE(),
    order_status VARCHAR(50) NOT NULL
)
go

--create pickers table
create table prj.pickers_ProfG_FP (
	picker_id INT PRIMARY KEY IDENTITY(1,1),
	first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
	hire_data DATE DEFAULT GETDATE()
)
go

--create pickers_orders
create table prj.pickers_orders_ProfG_FP (
	id INT PRIMARY KEY IDENTITY(1,1),
	order_id INT,
	picker_id INT
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
    category INT,
    price DECIMAL(8, 2) NOT NULL,
	is_by_weight BINARY NOT NULL,
    stock INT NOT NULL,
    description TEXT
)
go

create table prj.order_details_ProfG_FP (
	id INT PRIMARY KEY IDENTITY(1,1),
	order_id INT,
	product_id INT,
	quantity INT DEFAULT 0,
	weight DECIMAL(8,2) DEFAULT 0,
	total_price DECIMAL(8,2) NOT NULL
)
go


--ADDING FOREIGH KEYS

--credit cards customers
alter table prj.credit_cards_ProfG_FP
add constraint fk_credit_cards_customers
FOREIGN KEY (customer_id) REFERENCES prj.customers_ProfG_FP(customer_id)

alter table prj.credit_cards_ProfG_FP
add constraint fk_credit_cards_payments
FOREIGN KEY (payment_id) REFERENCES prj.payments_ProfG_FP(payment_id)
go

--phone number customers
alter table prj.phone_numbers_ProfG_FP
add constraint fk_phone_numbers_customers
FOREIGN KEY (customer_id) REFERENCES prj.customers_ProfG_FP(customer_id);
go 

--email customers
alter table prj.emails_ProfG_FP 
add constraint fk_emails_customers
FOREIGN KEY (customer_id) REFERENCES prj.customers_ProfG_FP(customer_id);
go

--orders customers
alter table prj.orders_ProfG_FP
add constraint fk_orders_customers
FOREIGN KEY (customer_id) REFERENCES prj.customers_ProfG_FP(customer_id);
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
FOREIGN KEY (customer_id) REFERENCES prj.customers_ProfG_FP(customer_id);

alter table prj.payments_ProfG_FP
add constraint fk_payments_credits_cards
FOREIGN KEY (credit_card_id) REFERENCES prj.credit_cards_ProfG_FP(credit_card_id);

alter table prj.payments_ProfG_FP
add constraint fk_payments_orders
FOREIGN KEY (order_id) REFERENCES prj.orders_ProfG_FP(order_id);
go

--order details
alter table prj.order_details_ProfG_FP
add constraint fk_order_details_product
FOREIGN KEY(product_id) REFERENCES prj.products_ProfG_FP(product_id);

alter table prj.order_details_ProfG_FP
add constraint fk_order_details_orders
FOREIGN KEY(order_id) REFERENCES prj.orders_ProfG_FP(order_id);

go


