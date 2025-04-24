--1
--Top Selling Products
--What are the top number of selling products? 
--create view with schemabidning
create or alter view s24240370.sales_report_view_ProfG_FP
with schemabinding
as
	select 
		p.product_id, p.product_name, 
		sum(isnull (op.quantity, 0)) as quantity_sold, 
		sum(isnull(op.total_price, 0)) as total_sales_value, 
		count_big(*) as num_orders 
	from s24240370.order_product_details_ProfG_FP op
	join s24240370.products_ProfG_FP p
	on op.product_id = p.product_id
	group by p.product_id, p.product_name
go

--create clustered index
create unique clustered index inx_sales_report_view_ProfG_FP on s24240370.sales_report_view_ProfG_FP(product_id, product_name);
go

select product_name, quantity_sold, total_sales_value from s24240370.sales_report_view_ProfG_FP
order by total_sales_value desc;
