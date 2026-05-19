create or alter procedure bronze.load_bronze as
begin
declare @start_time datetime, @end_time datetime
begin try
    print '==========================';
    PRINT 'Loading BRONZE LAYER';
    print '==========================';

    print '==========================';
    PRINT 'Loading CRM Tables';
    print '==========================';
    set @start_time=GETDATE();
    truncate table bronze.crm_cust_info;
    bulk insert  bronze.crm_cust_info
    from 'D:\sql\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
    with (
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    TABLOCK
    );
    set @end_time=GETDATE();
    print '>> load duration: '+ CAST(DATEDIFF(second,@start_time,@end_time) as varchar)+ ' seconds';

     set @start_time=GETDATE();
    truncate table bronze.crm_prd_info;
    BULK INSERT bronze.crm_prd_info
    FROM 'D:\sql\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
    set @end_time=GETDATE();
    print '>> load duration: '+ CAST(DATEDIFF(second,@start_time,@end_time) as varchar)+ ' seconds';
     set @start_time=GETDATE();
    truncate table bronze.crm_sales_details;
    BULK INSERT bronze.crm_sales_details
    FROM 'D:\sql\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
    set @end_time=GETDATE();
    print '>> load duration: '+ CAST(DATEDIFF(second,@start_time,@end_time) as varchar)+ ' seconds';
    print '==========================';
    PRINT 'Loading ERP Tables';
    print '==========================';
     set @start_time=GETDATE();
    truncate table bronze.erp_cust_az12;
    BULK INSERT bronze.erp_cust_az12
    FROM 'D:\sql\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
    set @end_time=GETDATE();
    print '>> load duration: '+ CAST(DATEDIFF(second,@start_time,@end_time) as varchar)+ ' seconds';
     set @start_time=GETDATE();
    truncate table bronze.erp_loc_a101;
    BULK INSERT bronze.erp_loc_a101
    FROM 'D:\sql\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
    set @end_time=GETDATE();
    print '>> load duration: '+ CAST(DATEDIFF(second,@start_time,@end_time) as varchar)+ ' seconds';
     set @start_time=GETDATE();
    truncate table bronze.erp_px_cat_g1v2;
    BULK INSERT bronze.erp_px_cat_g1v2
    FROM 'D:\sql\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
    set @end_time=GETDATE();
    print '>> load duration: '+ CAST(DATEDIFF(second,@start_time,@end_time) as varchar)+ ' seconds';
end try
begin catch
   print '==========================';
   print 'ERROR OCCURED DUSRING LOADING BRONZE LAYER';
   print 'Error message '+ error_message();
   print 'Error  message'+ cast(error_number() AS NVARCHAR);
   print 'Error  message'+ cast(ERROR_STATE() AS NVARCHAR);
   print '==========================';
end catch
end
