-- check for nulls and duplicates in primary key
SELECT cst_id,count(*) from bronze.crm_cust_info
group by cst_id having count(*)>1 or cst_id is null

select distinct cntry from bronze.erp_loc_a101

select distinct maintenance from bronze.erp_px_cat_g1v2

select prd_id,prd_key,prd_nm,prd_start_dt,prd_end_dt,
LEAD(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1 as test_dt
from bronze.crm_prd_info where prd_key in ('AC-HE-HL-U509-R','AC-HE-HL-U509')

select nullif(sls_order_dt,0) sls_order_Ddt from 
silver.crm_sales_details 
where sls_order_dt<=0 
or len(sls_order_dt)!=8



select * from silver.crm_sales_details 
where sls_order_dt>sls_ship_dt 
or sls_order_dt>sls_due_dt

select sls_sales,sls_quantity,sls_price from silver.crm_sales_details
where sls_sales!=sls_quantity*sls_price or
sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales<=0 or sls_quantity<=0 or sls_price<=0

select * from silver.crm_sales_details

use DataWarehouse
select cst_firstname from bronze.crm_cust_info
where cst_firstname != trim(cst_firstname)

--data standarization 
select distinct cst_gndr from bronze.crm_cust_info

select cst_id,count(*) from bronze.crm_cust_info 
group by cst_id having count(*)>1 or cst_id is null

use DataWarehouse;
select cst_firstname from silver.crm_cust_info
where cst_firstname != trim(cst_firstname)

--data standarization 
select distinct cst_gndr from silver.crm_cust_info

select cst_id,count(*) from silver.crm_cust_info 
group by cst_id having count(*)>1 or cst_id is null

select * from silver.crm_cust_info

use DataWarehouse
select prd_id,count(*) from
silver.crm_prd_info group by
prd_id having count(*)>1 or prd_id is null

select prd_nm from silver.crm_prd_info where prd_nm!=trim(prd_nm)

select prd_cost from silver.crm_prd_info where prd_cost<0 or prd_cost is null

select distinct prd_line from silver.crm_prd_info

select * from silver.crm_prd_info where prd_end_dt<prd_start_dt


select * from silver.crm_prd_info



