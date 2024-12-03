--use project
--go
--first insert entities auch as customers
--emails
--phone numbers
--pickers
--products
--orders

--delete from s24240370.customers_ProfG_FP

--insert fake data into customers table
INSERT INTO s24240370.customers_ProfG_FP(first_name, last_name, password, address, registration_date)
VALUES
('John', 'Doe', '5f4dcc3b5aa765d61d8327deb882cf99', '123 Main St, Anytown, USA', '2024-07-15'),
('Jane', 'Smith', 'e99a18c428cb38d5f260853678922e03', '456 Elm St, Othertown, USA', '2024-08-02'),
('Alice', 'Johnson', 'd8578edf8458ce06fbc5bb76a58c5ca4', '789 Oak St, Sometown, USA', '2024-07-21'),
('Bob', 'Brown', '5f4dcc3b5aa765d61d8327deb882cf99', '101 Pine St, Anycity, USA', '2024-07-15'),
('Carol', 'Davis', 'e99a18c428cb38d5f260853678922e03', '202 Maple St, Othercity, USA', '2024-05-01'),
('Patricia', 'Clark', 'e2b3a1d5f6c4b7a8e9d0c3a2f9d4b5c6', '132 Walnut Way, Fawcett City', '2024-07-10'),
('Michael', 'Lewis', 'f3b1a2e4c5d6f7a8e9d0a3c2f9d4b5c6', '876 Willow Dr, National City', '2024-06-20'),
('Elizabeth', 'Harris', 'c4a3b2e1d9f5a7c6e8d0b1a3f4d5b2c1', '543 Aspen St, Hub City', '2024-07-12'),
('Chris', 'Hall', 'a1e3c4b5d6f7a8e9d0b2c3a4f9d5b1c6', '897 Cypress Ct, Smallville', '2024-08-05'),
('Linda', 'Young', 'd3a1b4e2f6c5a7e9b0d1c8a2f9b4c3d1', '111 Cherry St, Freeland', '2024-09-15'),
('Andrew', 'Allen', 'c2e4a3b1f7d6c5a8e9d0b1a2f9b3c6d5', '222 Peach Blvd, Dakota City', '2024-08-22'),
('Emily', 'King', 'e4a3b2d5f6c1a7e9d0b3c8a2f9b5c4d1', '333 Palm Way, Midway City', '2024-08-18'),
('Joshua', 'Wright', 'a3d4c5b1e2f7a8e9d0b2c3a4f9d5b6c1', '444 Orange Ln, Blüdhaven', '2024-07-11'),
('Susan', 'Green', 'b5e2c4a1d6f7a8e9d0b3c2a9f4d5b1c6', '555 Mango Rd, Happy Harbor', '2024-06-25'),
('Karen', 'Baker', 'd6a1e3c4b5f7a8e9d0c2b3a4f9d5b6c1', '666 Pear Ave, Gateway City', '2024-07-22'),
('Matthew', 'Bell', 'a4b3e2d1f6c5a7e9d0b1c8a2f9b4c5d6', '777 Olive St, Ivy Town', '2024-09-13'),
('Cynthia', 'Parker', 'b1e3c4a2d5f6c7a8e9d0b3a9f4d5b2c1', '888 Banana Blvd, El Paso', '2024-09-27'),
('Joseph', 'White', 'c5a3b1e2d4f7a8e9d0b2c3a4f9d5b6c1', '999 Lime Ln, Starling City', '2024-09-09'),
('Sarah', 'Moore', 'e1d3c4a5f6b2a7e9d0c8a4f9d5b1c3d2', '101 Kiwi Way, Harmony', '2024-11-01'),
('Charles', 'Stewart', 'a2b3c4d5e6f7a8e9d0b1c9a4f5d6b3c1', '202 Grape Rd, Opal City', '2024-10-15'),
('Angela', 'Adams', 'f1e3c4a5d6b7a8e9d0c2b1a9f4d5b2c3', '303 Plum Blvd, Zenith City', '2024-11-07'),
('Thomas', 'Hughes', 'e2d4c5a3f6b1a7e9d0c3b2a4f9d5b1c6', '404 Nectar St, Atlantis', '2024-11-12'),
('Rebecca', 'Carter', 'c4a3b2e1d5f6c7a8e9d0b1a4f9d5b6c1', '505 Berry Ln, Argo City', '2024-11-21'),
('Daniel', 'Mitchell', 'a3e4c2b1d6f7a8e9d0c3b2a9f4d5b1c6', '606 Papaya Ave, River City', '2024-10-03'),
('Jessica', 'Perez', 'f4e3c2a1b5d6a7e8e9d0b3a4f9d5b1c6', '707 Lemon Way, Twin Peaks', '2024-10-12'),
('Mark', 'Roberts', 'b1c2e4a3d5f6c7a8e9d0b3a9f4d5b6c1', '808 Melon Dr, Centralia', '2024-10-18'),
('Nicole', 'Edwards', 'a4d3c2b1e5f6a7e9d0c3b2a9f4d5b1c6', '909 Pomegranate Blvd, Seaside', '2024-10-28'),
('Steven', 'Murphy', 'c5a3e2b1d6f4a7e8e9d0b3a4f9d5b1c6', '123 Fig Ln, Sunnydale', '2024-11-30'),
('Bob', 'P', 'c5a3e2b1d6f4a7e8e9d0b3a4f9d5b1c7', '150 Ocean Ave, Brooklyn', '2024-11-30'),
('Laura', 'Collins', 'd3a2c5b1e4f6a7e9d0b1c8a4f9d5b6c1', '345 Apricot Ave, Metropolis', '2024-10-25');
go


--delete from s24240370.emails_ProfG_FP
--insert fake data into 
INSERT INTO s24240370.emails_ProfG_FP(customer_id, email_address, type)
VALUES
(1, 'john.doe123@email.com', 'primary'), (1, 'johndoe456@ex.net', 'secondary'),
(2, 'jane.smith456@email.net', 'primary'),(2, 'jane.smith123@ex.com', 'secondary'),
(3, 'alice.johnson789@ex.com', 'primary'),(3, 'alice.johnson101@ex.org', 'secondary'),
(4, 'bob.brown567@ex.net', 'primary'),
(5, 'carol.davis123@ex.org', 'primary'),
(6,'user123@example.com', 'primary'), 
(7, 'shopper456@example.com', 'primary'), 
(8, 'buyer789@example.com', 'primary'), 
(9, 'customer101@example.com', 'primary'), 
(10, 'client202@example.com', 'primary'), 
(11, 'member303@example.com', 'primary'), 
(12,'subscriber404@example.com', 'primary'), 
(13,'visitor505@example.com', 'primary'), 
(14,'guest606@example.com', 'primary'), 
(15, 'participant707@example.com', 'primary'), 
(16,'user808@example.com', 'primary'), 
(17, 'shopper909@example.com', 'primary'), 
(18, 'buyer010@example.com', 'primary'), 
(19, 'customer111@example.com', 'primary'), 
(20, 'client212@example.com', 'primary'), 
(21,'member313@example.com', 'primary'), 
(22, 'subscriber414@example.com', 'primary'), 
(23, 'visitor515@example.com', 'primary'), 
(24, 'guest616@example.com', 'primary'), 
(25, 'participant717@example.com', 'primary'), 
(26, 'user818@example.com', 'primary'), 
(27, 'shopper919@example.com', 'primary'), 
(28, 'buyer020@example.com', 'primary'), 
(29, 'customer121@example.com', 'primary'), 
(30, 'client222@example.com', 'primary'),
(30, 'my_email34@email.com', 'secondary')
go

--add phone number
INSERT INTO s24240370.phone_numbers_ProfG_FP(customer_id, phone_number, type)
VALUES
(1,'9991112299', 'mobile'),
(2, '1111111111', 'mobile'),
(3,'1234567890', 'mobile'),
(4,'4567890123', 'mobile'),
(5,'5678901234', 'mobile'),
(5, '2345678901', 'home'),
(5,'3456789012', 'work'),
(6, '5551234567', 'mobile'), 
(6, '5552345678', 'home'), 
(7,'5553456789', 'mobile'), 
(8, '5554567890', 'mobile'),
(8, '1003456791', 'work'),
(9, '5555678901', 'mobile'), 
(10, '5556789012', 'mobile'), 
(10, '5557890123', 'work'), 
(11, '5558901234', 'mobile'), 
(12, '5559012345', 'mobile'), 
(12, '5550123456', 'home'),
(14, '5551234568', 'mobile'),
(14, '5550005680', 'work'), 
(15, '5552345679', 'mobile'), 
(16, '5553456780', 'mobile'), 
(17, '5554567891', 'mobile'), 
(18, '5555678902', 'mobile'), 
(19, '5556789013', 'mobile'), 
(20, '5557890124', 'mobile'), 
(21, '5558901235', 'mobile'), 
(22, '5559012346', 'mobile'), 
(23, '5550123457', 'mobile'),
(23, '5551231000', 'home'),
(24, '9123456789', 'mobile'),
(24, '9234567890', 'work'),
(25, '9456789012', 'mobile'),
(26, '9567890123', 'mobile'),
(26, '9678901234', 'work'),
(26, '9789012345', 'home'),
(27, '9890123456', 'mobile'),
(27, '9901234567', 'work'),
(28, '9012345678', 'mobile');
go

--add categories
INSERT INTO s24240370.categories_ProfG_FP (name) VALUES 
('Fruit'), 
('Vegetable'), 
('Meat'), 
('Seafood'), 
('Dairy'), 
('Bakery'), 
('Beverages'), 
('Pantry'), 
('Snacks'),
('Desserts')
go

--add products
INSERT INTO s24240370.products_ProfG_FP (product_name, producer, category_id, price, stock, reorder_level, description)
VALUES
('Apple', 'Fresh Farms', 1, 0.50, 100, 80, 'Fresh and juicy apples.'),
('Banana', 'Tropical Delight', 1, 0.30, 150, 100, 'Sweet and ripe bananas.'),
('Carrot', 'Healthy Harvest', 2, 0.20, 200, 100, 'Crunchy and nutritious carrots.'),
('Broccoli', 'Green Valley', 2, 0.80, 80, 100, 'Fresh and organic broccoli.'),
('Chicken Breast', 'Farm Fresh', 3, 5.00, 50, 30, 'Boneless and skinless chicken breast.'),
('Salmon Fillet', 'Ocean Catch', 4, 10.00, 30, 25, 'Fresh and tender salmon fillet.'),
('Milk', 'Dairy Delight', 5, 1.50, 100, 60, 'Fresh and creamy milk.'),
('Cheddar Cheese', 'Cheese World', 5, 3.00, 60, 75, 'Rich and flavorful cheddar cheese.'),
('Bread', 'Baker"s Best', 6, 2.00, 120, 80, null),
('Butter', 'Dairy Delight', 5, 2.50, 70, 60, null),
('Orange Juice', 'Citrus Grove', 7, 3.00, 90, 60,  'Freshly squeezed orange juice.'),
('Coffee', 'Morning Brew', 7, 5.00, 40, 50, 'Rich and aromatic coffee beans.'),
('Eggs', 'Farm Fresh', 5, 2.00, 100, 80, 'Organic and free-range eggs.'),
('Yogurt', 'Dairy Delight', 5, 1.00, 80, 75, 'Smooth and creamy yogurt.'),
('Tomato', 'Healthy Harvest', 2, 0.50, 150, 100, 'Fresh and juicy tomatoes.'),
('Potato', 'Green Valley', 2, 0.40, 200, 150, 'Versatile and nutritious potatoes.'),
('Beef Steak', 'Farm Fresh', 3, 8.00, 40, 30, 'Tender and juicy beef steak.'),
('Shrimp', 'Ocean Catch', 4, 12.00, 25, 30, 'Fresh and succulent shrimp.'),
('Pasta', 'Italiano', 8, 1.50, 100, 75, 'Authentic Italian pasta.'),
('Rice', 'Grain Goodness', 8, 1.00, 150, 100, 'Long-grain white rice.'),
('Olive Oil', 'Mediterranean', 8, 6.00, 50, 40, 'Extra virgin olive oil.'),
('Cereal', 'Breakfast Bliss', 8, 3.00, 80, 50, 'Healthy and delicious cereal.'),
('Chicken Thighs', 'Farm Fresh', 3, 4.00, 60, 40, 'Juicy and flavorful chicken thighs.'),
('Tuna', 'Ocean Catch', 4, 8.00, 35, 25, null),
('Butter Croissant', 'Baker"s Best', 6, 2.50, 70, 100, 'Flaky and buttery croissant.'),
('Spinach', 'Green Valley', 2, 0.70, 100, 80, 'Fresh and nutritious spinach.'),
('Blueberries', 'Berry Best', 1, 4.00, 80, 50, 'Sweet and juicy blueberries.'),
('Almonds', 'Nutty Delight', 9, 5.00, 60, 50, 'Crunchy and healthy almonds.'),
('Chocolate Bar', 'Sweet Treats', 9, 2.00, 90, 50, 'Rich and creamy chocolate bar.'),
('Ice Cream', 'Frozen Delights', 10, 3.50, 70, 50, 'Smooth and creamy ice cream.')
go


--add credit cards
INSERT INTO s24240370.credit_cards_ProfG_FP(customer_id, card_number, cardholder_name, exp_date, cvv)
VALUES
(1, '1234567812345678', 'John Doe', '2025-01-01', '123'),
(1, '1234567849045678', 'John Doe', '2028-04-01', '578'),
(1, '1234567849011111', 'John Doe', '2028-04-17', '300'), 
(2, '2345678923456789', 'Jane Smith', '2026-02-01', '234'), 
(3, '3456789034567890', 'Alice Johnson', '2027-03-01', '345'), 
(4, '4567890145678901', 'Bob Brown', '2028-04-01', '456'), 
(4, '4567890118978902', 'Bob Brown', '2020-01-01', '100'), 
(5, '5678901256789012', 'Carol Davis', '2029-05-01', '567'),
(6, '1234567812300000', 'Patricia Clark', '2025-01-01', '123'), 
(7, '2300678923456789', 'Michael Lewis', '2025-02-01', '234'), 
(8, '3456789034563210', 'Elizabeth Harris', '2025-03-01', '345'), 
(9, '4567890145678905', 'Chris Hall', '2025-04-01', '456'), 
(9, '5678901256789000', 'Chris Hall', '2025-05-01', '567'), 
(9, '6789010000090123', 'Chris Hall', '2025-06-01', '678'), 
(10, '7890123471111111', 'Linda Young', '2025-07-01', '789'), 
(11, '8901234589012344', 'Andrew Allen', '2025-08-01', '890'), 
(12, '9012345690123411', 'Emily King', '2025-09-01', '901'), 
(13, '0123456701234567', 'Joshua Wright', '2025-10-01', '012'), 
(14, '1234577812345678', 'Susan Green', '2025-11-01', '123'), 
(15, '2345678023456789', 'Karen Baker', '2025-12-01', '234'), 
(16, '3456782234567890', 'Matthew Bell', '2026-01-01', '345'), 
(17, '4567890145678902', 'Cynthia Parker', '2026-02-01', '456'), 
(17, '5678901256789010', 'Cynthia Parker', '2026-03-01', '567'), 
(18, '6789012367890123', 'Joseph White', '2026-04-01', '678'), 
(18, '7890113478901234', 'Joseph White', '2026-05-01', '789'), 
(19, '8901234589012345', 'Sarah Moore', '2026-06-01', '890'), 
(19, '9012345690123456', 'Sarah Moore', '2026-07-01', '901'), 
(19, '0123456701234560', 'Sarah Moore', '2026-08-01', '012'), 
(19, '1234567812345687', 'Sarah Moore', '2026-09-01', '123'), 
(19, '2345678923456720', 'Sarah Moore', '2026-10-01', '234');
go


--insert into pickers
INSERT INTO s24240370.pickers_ProfG_FP(first_name, last_name, hire_date)
VALUES
('David', 'Wilson', '2023-06-15'), 
('Emma', 'Taylor', '2023-07-20'), 
('Frank', 'Miller', '2023-08-25'), 
('Grace', 'Anderson', '2023-09-30'), 
('Henry', 'Thomas', '2023-10-10'), 
('Ivy', 'Moore', '2023-11-05'), 
('Jack', 'White', '2023-12-15'), 
('Kathy', 'Harris', '2024-01-20'), 
('Leo', 'Clark', '2024-02-25'), 
('Mia', 'Lewis', '2024-03-30')
go

--insert into orders
INSERT INTO s24240370.orders_ProfG_FP(customer_id, order_date, order_status, comment)
VALUES
(1, '2024-11-01', 'collected', 'Thank you!'),
(2, '2024-11-05', 'processing', 'Check expiration dates.'),
(3, '2024-12-15', 'received', 'make sure berries are fresh.'),
(1, '2024-10-04', 'canceled', null),
(5, '2024-12-05', 'on hold', null),
(3, '2024-09-06', 'collected', 'be careful'),
(3, '2024-12-05', 'processing', 'thx'),
(2, '2024-11-08', 'received', 'Order received by customer.'),
(1, '2024-09-09', 'canceled', null),
(1, '2024-10-10', 'canceled', null),
(5, '2024-09-12', 'collected', 'Your help is much appreciated'),
(5, '2024-09-15', 'collected', 'Thank you'),
(3, '2024-09-14', 'collected', null),
(3, '2024-09-13', 'canceled', null),
(2, '2024-09-15', 'collected', null),
(2, '2024-09-21', 'collected', 'add more water'),
(2, '2024-10-17', 'collected', null),
(2, '2024-12-28', 'received', null),
(3, '2024-10-19', 'canceled', null),
(1, '2024-10-20', 'collected', 'no substitutions'),
(1, '2024-10-25', 'collected', null),
(5, '2024-10-22', 'collected', 'Thank you'),
(2, '2024-10-01', 'collected', null)
go

--pickers orders 
insert into s24240370.pickers_orders_ProfG_FP (order_id, picker_id)
values
(1,1), (2,2), (3,3), (4,4), (5,5), (6,6), (7,7), (8,8), (9,9), (10,10), (11,10), 
(12,10), (13,2), (14,1), (15,3), (16,10), (17,8), (18,4), (19,9), (20,1), (21,3), (22,5), (23,1)
go


--order details
insert into s24240370.order_product_details_ProfG_FP
(order_id, product_id, quantity, total_price)
values
(1,22,1,3.00),(1,29,9,18.00),(1,1,3,1.50),
(2,27,2,8.00),(2,18,4,48.00),(2,13,5,10.00),(2,20,4,4.00),(2,28,2,10.00),
(3,7,6,9.00),(3,23,10,40.00),(3,3,4,0.80),(3,11,4,12.00),
(4,2,4,1.20),(4,4,9,7.20),(4,8,2,6.00),
(5,19,6,9.00),(5,12,10,50.00),(5,5,1,5.00),(5,24,9,72.00),(5,29,7,14.00),(5,7,8,12.00),
(6,5,4,20.00),(6,1,2,1.00),(6,10,4,10.00),(6,22,4,12.00),(6,23,1,4.00),(6,29,4,8.00),(6,19,6,9.00),
(7,20,3,3.00), (7,22,3,9.00),
(8,9,2,4.00),(8,6,10,100.00),(8,24,2,16.00),(8,28,9,45.00),(8,27,7,28.00),
(9,18,10,120.00),(9,27,7,28.00),(9,26,7,4.90),
(10,28,3,15.00),(10,25,4,10.00),
(11,22,10,30.00),(11,13,1,2.00),(11,5,6,30.00),
(12,10,9,22.50),(12,16,6,2.40),(12,27,8,32.00),(12,15,6,3.00),(12,8,1,3.00),(12,28,2,10.00),(12,23,2,8.00),(12,14,3,3.00),
(13,26,4,2.80),(13,21,3,18.00),(13,24,7,56.00),(13,7,10,15.00),(13,29,10,20.00),(13,8,3,9.00),(13,15,1,0.50),(13,18,3,36.00),
(14,20,6,6.00),(14,6,1,10.00),(14,21,5,30.00),(14,25,9,22.50),(14,5,6,30.00),(14,22,2,6.00),
(15,9,8,16.00),
(16,11,8,24.00),(16,30,9,31.50),(16,25,3,7.50),(16,6,6,60.00),(16,1,9,4.50),(16,8,10,30.00),(16,27,5,20.00),(16,9,7,14.00),
(17,17,1,8.00),(17,18,9,108.00),(17,12,6,30.00),(17,26,6,4.20),(17,25,3,7.50),(17,8,7,21.00),
(18,27,5,20.00),(18,1,8,4.00),(18,12,5,25.00),(18,25,10,25.00),(18,7,8,12.00),
(19,20,2,2.00),(19,13,6,12.00),(19,12,2,10.00),(19,22,7,21.00),(19,15,5,2.50),(19,24,4,32.00),(19,17,4,32.00),(19,25,5,12.50),(19,8,10,30.00),(19,9,8,16.00),
(20,27,6,24.00),(20,20,1,1.00),(20,29,7,14.00),(20,11,9,27.00),(20,16,8,3.20),(20,12,5,25.00),(20,9,3,6.00),
(21,8,10,30.00),(21,26,9,6.30),(21,2,6,1.80),(21,29,8,16.00),(21,10,9,22.50),(21,25,6,15.00),(21,5,1,5.00),
(22,5,5,25.00),(22,25,3,7.50),(22,21,7,42.00),(22,3,2,0.40),(22,24,5,40.00),(22,2,8,2.40),(22,17,2,16.00),
(23,6,6,60.00),(23,10,3,7.50),(23,22,8,24.00),(23,16,10,4.00),(23,28,7,35.00)

go


--insert  payments
insert into s24240370.payments_ProfG_FP 
(customer_id, credit_card_id, order_id, amount, status, payment_date, type)
values
--first customer
( 1 , 3 , 1 , 22.50 , 'completed' , '2024-10-29', 'order'), 
( 1 , 2 , 4 , 14.40 , 'completed' , '2024-10-02', 'refund'),
( 1 , 2 , 9 , 152.90 , 'completed' , '2024-09-08', 'refund'),
( 1 , 3 , 10 , 25.00 , 'completed' , '2024-10-9', 'refund'),
( 1 , 2 , 20 , 100.20 , 'completed' , '2024-10-19', 'refund'),
( 1 , 3 , 21 , 96.60 , 'completed' , '2024-10-23', 'refund'),
--second customer
( 2 , 4 , 21 , 80.00 , 'pending' , '2024-11-01', 'order'), 
( 2 , 4 , 8 , 193.00 , 'pending' , '2024-11-04', 'order'),
( 2 , 4 , 15 , 16.00 , 'completed' , '2024-09-12', 'order'),
( 2 , 4 , 16 , 191.50 , 'completed' , '2024-09-19', 'order'),
( 2 , 4 , 17 , 178.70 , 'completed' , '2024-10-15', 'order'),
( 2 , 4 , 18 , 86.00 , 'pending' , '2024-11-20', 'order'),
( 2 , 4 , 23 , 130.50 , 'completed' , '2024-10-01', 'order'),
--third customer 
( 3 , 5 , 3 , 61.80 , 'pending' , '2024-11-04', 'order'),
( 3 , 5 , 6 , 64.00 , 'completed' , '2024-09-05', 'order'), 
( 3 , 5 , 7 , 12.00 , 'pending' , '2024-11-03', 'order'), 
( 3 , 5 , 13 , 157.30 , 'completed' , '2024-09-12', 'order'), 
( 3 , 5 , 14 , 104.50 , 'completed' , '2024-09-11', 'refund'), 
( 3 , 5 , 19 , 170.00 , 'completed' , '2024-10-18', 'refund'), 
--fifth customer 
( 5 , 8 , 5 , 162.00 , 'pending' , '2024-11-04', 'order'),
( 5 , 8 , 11 , 62.00 , 'completed' , '2024-09-11', 'order'),
( 5 , 8 , 12 , 83.90 , 'completed' , '2024-09-12', 'order'),
( 5 , 8 , 22 , 133.30 , 'completed' , '2024-10-21', 'order')
go