--=====================================================
--Inserting data into the table bronze.revenue_gl
--Historical data loaded using individual copy commands
--=====================================================
Truncate Table bronze.revenue_gl;
copy bronze.revenue_gl from 'C:/SQL_Project/customer-history-project/revenue-history/1a. HIPL 2023.csv' with (format csv, header true);
copy bronze.revenue_gl from 'C:/SQL_Project/customer-history-project/revenue-history/1b. HIPL 2024.csv' with (format csv, header true);
copy bronze.revenue_gl from 'C:/SQL_Project/customer-history-project/revenue-history/1c. HIPL 2025.csv' with (format csv, header true);
copy bronze.revenue_gl from 'C:/SQL_Project/customer-history-project/revenue-history/2. NSBP - 2023 to 2025.csv' with (format csv, header true);
copy bronze.revenue_gl from 'C:/SQL_Project/customer-history-project/revenue-history/3. Hyd PFT - 2023 to 2025.csv' with (format csv, header true);
copy bronze.revenue_gl from 'C:/SQL_Project/customer-history-project/revenue-history/4. Cold Chain - 2023 to 2025.csv' with (format csv, header true);
copy bronze.revenue_gl from 'C:/SQL_Project/customer-history-project/revenue-history/5. ICBP - 2023 to 2025.csv' with (format csv, header true);
copy bronze.revenue_gl from 'C:/SQL_Project/customer-history-project/revenue-history/6. Rail Logistics - 2023 to 2025.csv' with (format csv, header true);
copy bronze.revenue_gl from 'C:/SQL_Project/customer-history-project/revenue-history/7. CRRS - 2023 to 2025.csv' with (format csv, header true);
copy bronze.revenue_gl from 'C:/SQL_Project/customer-history-project/revenue-history/8a. Multimodal - 2023 to 2025.csv' with (format csv, header true);
copy bronze.revenue_gl from 'C:/SQL_Project/customer-history-project/revenue-history/8b. Multimodal - 2023 to 2025.csv' with (format csv, header true);
copy bronze.revenue_gl from 'C:/SQL_Project/customer-history-project/revenue-history/8c. Multimodal - 2023 to 2025.csv' with (format csv, header true);
copy bronze.revenue_gl from 'C:/SQL_Project/customer-history-project/revenue-history/9a. Express - 2023.csv' with (format csv, header true);
copy bronze.revenue_gl from 'C:/SQL_Project/customer-history-project/revenue-history/9b. Express - 2024.csv' with (format csv, header true);
copy bronze.revenue_gl from 'C:/SQL_Project/customer-history-project/revenue-history/9c. Express - 2025.csv' with (format csv, header true);
copy bronze.revenue_gl from 'C:/SQL_Project/customer-history-project/revenue-history/9d. Express - 2025.csv' with (format csv, header true);
copy bronze.revenue_gl from 'C:/SQL_Project/customer-history-project/revenue-history/2026/1.Revenue register_Jan-26.csv' with (format csv, header true);
copy bronze.revenue_gl from 'C:/SQL_Project/customer-history-project/revenue-history/2026/2.Revenue register_Feb-26.csv' with (format csv, header true);

--====================================================================================
--Stored procedure to load incremental data evey month to the table bronze.revenue_gl.
--Every month, over-write the data in the file named 'Latest_Revenue_GL_report.csv'
--with the latest month raw report saved in customer files folder in shared drive
--====================================================================================
qCreate or Replace Procedure bronze.load_revenue()
Language plpgsql
As $$
Declare
	begintime timestamp;
	endtime timestamp;
Begin
	begintime := now();
	Raise Notice 'Insert from latest_revenue_gl_report.csv file has begun';
	Begin
		Copy bronze.revenue_gl from 'C:/SQL_Project/customer-history-project/revenue-history/0/Latest_Revenue_GL_report.csv' with (Format csv, Header true);
		Exception
		When Others Then
		Raise Notice 'Error in loading revenue';
		Raise Notice 'Error message %', SQLERRM;
	End;
	endtime := now();
	Raise Notice 'Insert from latest_revenue_gl_report.csv file has ended';
	Raise Notice 'Time taken to complete the process is %', endtime - begintime;
End;
$$;
--====================================================================================
--Calling the stored procedure
--After updating the 'Latest_Revenue_GL_report.csv' file with latest month data
--call the stored procedure: bronze.load_revenue()
--=====================================================================================
call bronze.load_revenue()
