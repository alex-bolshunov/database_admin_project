--accept customer id, output num 0 or 1, 1 if customer exists, 0 if the customer doesn't exist
create or alter procedure s24240370.is_valid_customer_id_ProfG_FP @cust_id int, @is_valid bit output
as
	begin
		--query table, check if the cusotmer exists
		select @is_valid = 
		(	select count(customer_id) 
			from s24240370.customers_ProfG_FP 
			where customer_id = @cust_id	)
	end
go