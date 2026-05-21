select distinct
ci.cst_gndr,
ca.gen,
case when ci.cst_gndr!='n/a' then ci.cst_gndr
else coalesce(ca.gen,'n/a') end as new_gen
 from silver.crm_cust_info as ci
 left join silver.erp_cust_az12 as ca
 on ci.cst_key=ca.cid
 left join silver.erp_loc_a101 la
 on ci.cst_key=la.cid order by 1,2


select * from gold.fact_sales f 
left join gold.dim_customers c
on c.customer_key = f.customer_key
left join gold.dim_products p
on p.product_key=f.product_key
where p.product_key is null
