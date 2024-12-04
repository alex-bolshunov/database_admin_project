create user test_user without login;

grant select on schema::s24240370 to test_user;

execute as user = 'test_user'

--show all masked info to test_user
select c.customer_id, c.last_name, c.password, c.address, p.phone_number, e.email_address, cc.card_number, cc.cvv
from s24240370.customers_ProfG_FP c
left join s24240370.phone_numbers_ProfG_FP p
on c.customer_id = p.customer_id
left join s24240370.emails_ProfG_FP e
on c.customer_id = e.customer_id
left join s24240370.credit_cards_ProfG_FP cc
on c.customer_id = cc.customer_id

revert

go 