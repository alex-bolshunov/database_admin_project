create or alter procedure s24240370.issue_refund_ProfG_FP @order_id int, @payment_id int, @is_started bit output
as
	begin
		declare @order_status varchar(20)
		declare @payment_type varchar(10) = 'refund'
		declare @payment_status varchar(10) = 'pending'
		declare @payment_date date = getdate()
		
		
		set @is_started = 0
		
		begin try
			begin transaction
			
			select @order_status = order_status
			from s24240370.orders_ProfG_FP
			where order_id = @order_id
			
			--check if the order is still open if yes, change the status of the payment
			if @order_status in ('processing', 'received', 'on hold')
				begin

					update s24240370.payments_ProfG_FP
					set type = @payment_type
					where payment_id = @payment_id

					set @is_started = 1
				end
			--if the order is closed, place new transaction for the customer 
			else if @order_status in ('collected')
				begin
					
					declare @cust_id int
					declare @cc_id varchar(20)
					declare @amount decimal(8, 2)

					--get required values
					select @cust_id = customer_id, @cc_id = credit_card_id, @amount = amount 
					from s24240370.payments_ProfG_FP
					where payment_id = @payment_id
					
					--insert into s24240370.payments_ProfG_FP
					insert into s24240370.payments_ProfG_FP
					(customer_id, credit_card_id, order_id, amount, status, payment_date, type)
					values
					(@cust_id, @cc_id, @order_id, @amount, @payment_status, @payment_date, @payment_type)
					
					set @is_started = 1
				end

			commit transaction
		end try
		begin catch
			rollback transaction
			select 'Error occured'
		end catch
	end


--declare @is bit 

--exec s24240370.issue_refund_ProfG_FP @order_id = 1, @payment_id = 1,  @is_started= @is output

--select @is 



 