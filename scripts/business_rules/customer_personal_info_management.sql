--update customer email
--accepts cust id, new email and email type 
create or alter procedure s24240370.customer_email_update_ProfG_FP @cust_id int, @new_email VARCHAR(100), @type VARCHAR(9) = 'primary'
as
	begin

		begin try
			begin transaction
			--check if valid emial -> update the email 
			if s24240370.is_valid_email_ProfG_FP(@new_email) = 1 and @type in ('primary', 'secondary')
				begin
					update s24240370.emails_ProfG_FP
					set email_address = @new_email
					where customer_id = @cust_id
					and type = @type

					commit transaction
					select 'Email updated' as message
				end
			--rollback started transaction, show relevant message
			else
				begin
					rollback transaction
					select 'Invalid values provided' as message
				end

		end try

		--notify about an error 
		begin catch
			rollback transaction
			select 'Error occured' as message
		end catch

	end
go

--update customer phone number
--accepts cust id, new email and email type 
create or alter procedure s24240370.customer_phone_number_update_ProfG_FP @cust_id int, @new_number VARCHAR(10), @type VARCHAR(6) = 'mobile'
as
	begin

		begin try
			begin transaction
			--check if valid emial -> update the email 
			if s24240370.is_valid_phone_number_ProfG_FP(@new_number) = 1 and @type in('home','mobile', 'work')
				begin
					update s24240370.phone_numbers_ProfG_FP
					set phone_number = @new_number
					where customer_id = @cust_id
					and type = @type

					commit transaction
					select 'Phone number updated' as message
				end
			--rollback started transaction, show relevant message
			else
				begin
					rollback transaction
					select 'Invalid values provided' as message
				end

		end try

		--notify about an error 
		begin catch
			rollback transaction
			select 'Error occured' as message
		end catch

	end
go
