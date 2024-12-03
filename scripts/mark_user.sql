--mark the customer as suspicious 
create or alter procedure s24240370.mark_customer_as_suspicious_ProfG_FP @cust_id int
as
begin
		declare @is_sus bit

		--check currect suspicious status
		select @is_sus = suspicious from s24240370.customers_ProfG_FP
		where customer_id = @cust_id

		--if not marked yet, update suspicious status
		if @is_sus  = 0
			begin
				begin try
					begin transaction

						update s24240370.customers_ProfG_FP
						set suspicious = 1
						where customer_id = @cust_id

					commit transaction
					select 'Customer id ' + cast(@cust_id as varchar) + ' was marked as suspicious' as message 
				end try

				begin catch
					rollback transaction
					select 'Message occured' as message
				end catch
			end
end