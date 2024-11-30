create or alter procedure s24240370.send_email_confirmation_ProfG_FP @cust_id int, @message varchar(300)
as
begin
	declare @full_name varchar(200) = s24240370.get_full_name_ProfG_FP(@cust_id)

	--CODE TO SEND AN EMAIL

	select 'The email confirmation was sent to ' + @full_name + ', id: ' + cast(@cust_id as varchar) + '.'
end

