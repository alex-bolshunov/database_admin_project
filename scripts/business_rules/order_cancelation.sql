create or alter procedure s24240370.cancel_order_ProfG_FP @order_id int, @payment_id int
as
	begin
		declare @is_refund_started bit
		declare @status varchar(20)
		declare @new_status varchar(20) = 'canceled'
		

		begin try
			begin transaction
				
				--check order stauts
				select @status = order_status 
				from s24240370.orders_ProfG_FP
				where order_id = @order_id

				--check if refund is possible
				exec s24240370.issue_refund_ProfG_FP @order_id = @order_id, @payment_id = @payment_id, @is_started = @is_refund_started output

				--update status if true
				if @status in ('processing', 'received', 'on hold') and @is_refund_started = 1
					begin		
						update s24240370.orders_ProfG_FP
						set order_status = @new_status
						where order_id = @order_id

						select 'Order has been cancled' as message
					end
				else
					begin
						select 'Check status of the order' as message
					end
			commit transaction
		end try
		begin catch
			rollback transaction
			select 'Erorr occured' as message
		end catch
	end

exec s24240370.cancel_order_ProfG_FP @order_id = 24, @payment_id  = 24


select o.order_id, p.payment_id, o.order_status
from s24240370.orders_ProfG_FP o
join s24240370.payments_ProfG_FP p
on o.order_id = p.order_id
where o.order_status in ('on hold', 'received', 'processing')
order by o.order_id desc

select * from s24240370.payments_ProfG_FP 
where order_id = 46


select * from s24240370.orders_ProfG_FP
where order_id = 46

select * from s24240370.order_product_details_ProfG_FP
where order_id = 46

select * from s24240370.products_ProfG_FP