create or alter procedure s24240370.send_email_confirmation_ProfG_FP @cust_id int = 0, @message varchar(300)
as
begin
	declare @full_name varchar(200) = s24240370.get_full_name_ProfG_FP(@cust_id)

	if @cust_id != 0
		begin
			--CODE TO SEND AN EMAIL

			select 'The email confirmation was sent to ' + @full_name + ', id: ' + cast(@cust_id as varchar) + '.' as message
		end
	else if @cust_id = 0
		begin
			--CODE TO SEND AN EMAIL
			select @message as message
		end

end

go
