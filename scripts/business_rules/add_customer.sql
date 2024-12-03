--accept 5 parameters, insert into customers table, then add new email for new customer 
create or alter procedure s24240370.add_customer_ProfG_FP 
	@f_name varchar(50), @l_name varchar(50), @email varchar(100), @phone_number varchar(10), @password varchar(100)
as
begin
	declare @is_valid_email bit = s24240370.is_valid_email_ProfG_FP(@email) --check if the email is valid
	declare @is_valid_phone_number bit = s24240370.is_valid_phone_number_ProfG_FP(@phone_number) --check if the phone number is valid
		
	begin try
		begin transaction; --start the transction		
			
		if(@f_name is not null and @l_name is not null and @password is not null and @is_valid_email = 1 and @is_valid_phone_number = 1)
		begin
			declare @cust_id int
					
				--insert new customer
				insert into s24240370.customers_ProfG_FP (first_name, last_name, password)
				values (@f_name, @l_name, @password)

				--get customer id
				select top 1 @cust_id = customer_id from s24240370.customers_ProfG_FP
				order by customer_id desc

				--insert new customer email 
				insert into s24240370.emails_ProfG_FP (customer_id, email_address)
				values (@cust_id, @email)

				--insert new customer phone number
				insert into s24240370.phone_numbers_ProfG_FP(customer_id, phone_number)
				values (@cust_id, @phone_number)
				
				select 'customer added' as message
				commit transaction --commit 
		end
		else
		begin
			rollback transaction --rollback 
			select 'Incorrect values are provided' as message
		end
		end try
		begin catch
			rollback transaction --rollback 
			select 'Error occured' as message
		end catch
end
go

exec s24240370.add_customer_ProfG_FP 'Tina', 'Green', 'tina.green@example.com', '1001001000', '5f4dcc3b5aa765d61d8327deb882cf99'
go

select c.customer_id, c.first_name + ' ' + c.last_name as full_name, e.email_address, p.phone_number
from s24240370.customers_ProfG_FP c
join s24240370.emails_ProfG_FP e
on c.customer_id = e.customer_id
join s24240370.phone_numbers_ProfG_FP p
on c.customer_id = p.customer_id
where c.customer_id = 31


