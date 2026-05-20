create or alter procedure silver.load_silver as
begin
	print 'truncating in silver crm cust table'
	truncate table silver.crm_cust_info
	print 'Inserting in silver crm cust table'
	insert into silver.crm_cust_info(
	cst_id,cst_key,cst_firstname,cst_lastname,
	cst_material_status,cst_gndr,cst_create_date
	)

	select cst_id,
	cst_key,
	 TRIM(cst_firstname) as cst_firstname,
	TRIM(cst_lastname) as cst_lastname,
	case when TRIM(Upper(cst_material_status))='S' then 'Single'
	when trim(upper(cst_material_status))='M' then'Married'
	else 'n/a' end
	cst_material_status,
	case when TRIM(Upper(cst_gndr))='F' then 'Female'
	when trim(upper(cst_gndr))='M' then'Male'
	else 'n/a' end
	cst_gndr,
	cst_create_date
	from (
	select *,rank() over (partition by cst_id order by cst_create_date desc) as flag_last 
	from bronze.crm_cust_info where cst_id is not null
	)as t where t.flag_last=1
	
	print 'truncating into crm prd table'
	truncate table silver.crm_prd_info
	print 'inserting into crm prd table'
	insert into silver.crm_prd_info(
prd_id,cat_id,prd_key,prd_nm,prd_cost,prd_line
,prd_start_dt,prd_end_dt
)
select prd_id
,replace(substring(prd_key,1,5),'-','_') as cat_id
,substring(prd_key,7,len(prd_key)) as prd_key,
prd_nm,isnull(prd_cost,0) as prd_cost,
case upper(trim(prd_line)) when
'M' then 'Mountain'
when
'R' then 'Road'
when
'S' then 'Other Sales'
when
'T' then 'Touring'
else 'n/a'
end prd_line,cast(prd_start_dt as date),
cast(LEAD(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1  as date) as prd_end_dt
from bronze.crm_prd_info

print 'truncating into crm sales table'
truncate table silver.crm_sales_details
print 'inserting into crm sales table'
	insert into silver.crm_sales_details (
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price)

select sls_ord_num,sls_prd_key,sls_cust_id,
case when sls_order_dt=0 or len(sls_order_dt)!=8 then null
else Cast(CAST(sls_order_dt as varchar) as date)
end as sls_order_dt,
case when sls_ship_dt=0 or len(sls_ship_dt)!=8 then null
else Cast(CAST(sls_ship_dt as varchar) as date)
end as sls_ship_dt,
case when sls_due_dt=0 or len(sls_due_dt)!=8 then null
else Cast(CAST(sls_due_dt as varchar) as date)
end as sls_due_dt,
case when sls_sales<=0 or sls_sales is null or
sls_sales != sls_quantity*ABS(sls_price)
then sls_quantity*ABS(sls_price)
else sls_sales
end as sls_sales
,sls_quantity,
case when sls_price<=0 or sls_price is null 
then sls_sales/NULLIF(sls_quantity,0)
else sls_price
end as sls_price
from bronze.crm_sales_details  


print 'truncating into erp customer table'
truncate table silver.erp_cust_az12;
print 'inserting into erp customer table'
	insert into silver.erp_cust_az12(
cid,bdate,gen)
select 
CASE WHEN cid like 'NAS%' then substring(cid,4,len(cid))
else cid
end 
as cid,
case when bdate>getdate() then null
else bdate
end as bdate,
case when trim(UPPER(gen))
in ('F','Female') then 'Female'
WHEN trim(UPPER(gen)) IN ('M','Male') then 'Male'
else 'n/a'
end as gen from 
bronze.erp_cust_az12

print 'truncating into erp location table'
truncate table silver.erp_loc_a101;
print 'inserting into erp location table'
insert into silver.erp_loc_a101(
cid,cntry)
select replace(cid,'-','') as cid
,case when trim(cntry) = 'DE' then 'Germany'
when trim(cntry) in ('US','USA') then 'United States'
when trim(cntry) = '' or cntry is null then 'n/a'
else trim (cntry) end as
cntry from bronze.erp_loc_a101

print 'truncating into erp product table'
truncate table silver.erp_px_cat_g1v2;
print 'inserting into erp product table'
insert into silver.erp_px_cat_g1v2(
id,cat,subcat,maintenance)
select id,cat,subcat,maintenance
from bronze.erp_px_cat_g1v2
end
