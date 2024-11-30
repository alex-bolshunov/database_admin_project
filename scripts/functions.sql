--function to validate email
--used in procedures: s24240370.add_customer_ProfG_FP 
create or alter function s24240370.is_valid_email_ProfG_FP(@email varchar(100))
returns bit
as
begin
	declare @return_value int = 1
	
	if @email not like '%@%.%'
		set @return_value = 0

	return @return_value
end

go

--funciton to validate phone number
--used in procedures: s24240370.add_customer_ProfG_FP 
create or alter function s24240370.is_valid_phone_number_ProfG_FP(@phone_number varchar(10))
returns bit
as
begin
	declare @return_value bit = 0
		--check that the phone number contains numbers only and is 10 digits long
		if @phone_number like '[1-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' and len(@phone_number) = 10
			set @return_value = 1
	return @return_value
end

go

--function to return full name
--used in procedures: s24240370.get_frequent_cancelers_ProfG_FP
create or alter function s24240370.get_full_name_ProfG_FP(@cust_id int)
returns varchar(100)
as
begin
	declare @full_name varchar(100) = ''
	
	select @full_name = first_name + ' ' + last_name from s24240370.customers_ProfG_FP c
	where customer_id = @cust_id

	return @full_name
end

go

--returns a date for a specified number of days ago from today's date
--used in procedures: s24240370.get_frequent_cancelers_ProfG_FP, s24240370.get_sales_summary_ProfG_FP
create or alter function s24240370.get_date_specified_period_ProfG_FP(@num_days int)
returns date
as
begin
	return dateadd(day, @num_days * -1, getdate())
end
go




