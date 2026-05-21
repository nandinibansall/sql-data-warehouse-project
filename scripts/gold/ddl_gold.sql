print 'Creating customer dimension table'
create view gold.dim_customers as 
select
ROW_NUMBER() OVER(order by cst_id) as customer_key, -- surrogate key
ci.cst_id as customer_id,
ci.cst_key as customer_number,
ci.cst_firstname as first_name,
ci.cst_lastname as last_name,
la.cntry as country,
ci.cst_material_status as marital_status,
case when ci.cst_gndr!='n/a' then ci.cst_gndr
else coalesce(ca.gen,'n/a') end as gender,
ca.bdate as birthdate,
ci.cst_create_date as create_date
 from silver.crm_cust_info as ci
 left join silver.erp_cust_az12 as ca
 on ci.cst_key=ca.cid
 left join silver.erp_loc_a101 la
 on ci.cst_key=la.cid

  print 'Creating products dimension table'
create view gold.dim_products as
select 
row_number() over(order by pi.prd_start_dt,pi.prd_key) as product_key, pi.prd_id as product_id,
pi.prd_key as product_number,
pi.prd_nm as product_name,
pi.cat_id as category_id,
pc.cat as category,
pc.subcat as subcategory,
pc.maintenance,
pi.prd_cost as cost,
pi.prd_line as product_line,
pi.prd_start_dt as start_date,
pi.prd_end_dt as end_date
from silver.crm_prd_info as pi 
left join silver.erp_px_cat_g1v2 as pc
on pi.cat_id=pc.id
where pi.prd_end_dt is null -- to select only the current info

print 'Creating sales facts table'
create view gold.fact_sales as

select si.sls_ord_num as order_number,
pd.product_key,
cs.customer_key,
si.sls_order_dt as order_date,
si.sls_ship_dt as shipping_date,
si.sls_due_dt as due_date,
si.sls_sales as sales_amount,
si.sls_quantity as quantity,
si.sls_price as price
from silver.crm_sales_details as si
left join gold.dim_customers as cs
on si.sls_cust_id=cs.customer_id
left join gold.dim_products as pd
on si.sls_prd_key=pd.product_number
