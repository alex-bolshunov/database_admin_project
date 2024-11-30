--accept customer id and new password
create or alter procedure s24240370.user_password_reset_ProfG_FP @cust_id int, @new_password VARCHAR(100)
as
	begin
		declare @is_valid_cust_id bit
		begin try

			begin transaction
			--check if the customer id is valid
			exec s24240370.is_valid_customer_id_ProfG_FP @cust_id, @is_valid = @is_valid_cust_id output

			--update password if valid
			if @is_valid_cust_id = 1 
			begin
				
				update s24240370.customers_ProfG_FP 
				set password = @new_password
				where customer_id = @cust_id
				
				select 'Password updated' as message
				commit transaction
			end
			--show message, rollback
			else
				begin
					rollback transaction
					select 'No customer found' as message
				end
		end try

		--show message, rollback 
		begin catch
			rollback transaction
			select 'Error occured' as message
		end catch

	end
go


exec s24240370.user_password_reset_ProfG_FP -1, 'password'
