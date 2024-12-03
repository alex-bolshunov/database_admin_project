--create roles 
create role data_analyst --select
create role data_entry --insert, update
go

--grant permissions to data_analyst
grant select on schema::s24240370 to data_analyst 
grant execute on schema::s24240370 to data_analyst
go

--grant permissions to data_entry (tables level)
grant insert, update on s24240370.pickers_ProfG_FP to data_entry
grant insert, update on s24240370.categories_ProfG_FP to data_entry
grant insert, update on s24240370.products_ProfG_FP to data_entry
go


--create logins
create login oleksii_data_analytics with password = 'password'
create login oleksii_data_entry with password = 'password'
go

--choose database
use student
go

--create users
create user oleksii_data_analytics for login oleksii_data_analytics
create user oleksii_data_entry for login oleksii_data_entry
go

--assign a role to a user
exec sp_addrolemember 'data_analyst', 'oleksii_data_analytics'
exec sp_addrolemember 'data_entry', 'oleksii_data_entry'
go