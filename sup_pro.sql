

	--Viewing the data 
	select * from sales;


	--Checking the row count
	select count(1) from sales;


	--Checking for any duplicates 
	select count(*),Invoice_ID,Branch,City,Customer_type,Gender,Product_line,Unit_price,Quantity,Tax,
				Total,Date_,Time_,Payment,cogs,gross_margin_percentage,gross_income,Rating
	from sales 
	group by Invoice_ID,Branch,City,Customer_type,Gender,Product_line,Unit_price,Quantity,Tax,
				Total,Date_,Time_,Payment,cogs,gross_margin_percentage,gross_income,Rating
	having (count(*)>1)

	-- Check for null values in columns
	SELECT COUNT(*) AS NullCount
	FROM sales
	WHERE Invoice_ID IS NULL OR Branch IS NULL OR City IS NULL OR Customer_type IS NULL OR Gender IS NULL OR Product_line IS NULL OR Unit_price IS NULL OR Quantity IS NULL OR Tax IS NULL OR Total IS NULL OR Date_ IS NULL OR Time_ IS NULL OR Payment IS NULL OR cogs IS NULL OR gross_margin_percentage IS NULL OR gross_income IS NULL OR Rating IS NULL;

	-- Counting null values
	SELECT
		SUM(CASE WHEN Invoice_ID IS NULL THEN 1 ELSE 0 END) Invoice_ID_NullCount,
		SUM(CASE WHEN Branch IS NULL THEN 1 ELSE 0 END) Branch_NullCount,
		SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) city_NullCount,
		SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) gender_NullCount,
		SUM(CASE WHEN Product_line IS NULL THEN 1 ELSE 0 END) product_NullCount,
		SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS units_NullCount,
		SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS quantity_NullCount,
		SUM(CASE WHEN tax IS NULL THEN 1 ELSE 0 END) AS tax_NullCount,
		SUM(CASE WHEN payment IS NULL THEN 1 ELSE 0 END) AS payment_NullCount,
		SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS rating_NullCount
	FROM sales;

	-- Check for outliers in the "Total" column
	SELECT *
	FROM sales
	WHERE Total between 0 and 100000;

	-- Check for outliers in the "Quantity" column
	SELECT *
	FROM sales
	WHERE Quantity > 100;

	-- Check for outliers in the "Unit_price" column
	SELECT *
	FROM sales
	WHERE Unit_price > 10000;

	-- Check for outliers in the "Rating" column
	SELECT *
	FROM sales
	WHERE Rating < 0 OR Rating > 10;

	-- Check for outliers in the "Total" column
	SELECT *
	FROM sales
	WHERE Total > AVG(Total) + 3 * STDDEV(Total);


	--Calculating the weekday using date
	with cte_date_ as (
	SELECT date_, 
		CASE 
			WHEN EXTRACT(DOW FROM date_::DATE) = 0 THEN 7 
			ELSE EXTRACT(DOW FROM date_::DATE)
		END AS WeekdayNumber
	FROM sales
	group by date_,WeekdayNumber
	)
	select Date_, 
		CASE 
			WHEN WeekdayNumber = 1 THEN 'Monday'
			WHEN WeekdayNumber = 2 THEN 'Tuesday'
			WHEN WeekdayNumber = 3 THEN 'Wednesday'
			WHEN WeekdayNumber = 4 THEN 'Thursday'
			WHEN WeekdayNumber = 5 THEN 'Friday'
			WHEN WeekdayNumber = 6 THEN 'Saturday'
			WHEN WeekdayNumber = 7 THEN 'Sunday'
			else 'Unkown'
		END as day_name
	from cte_date_
	group by date_,WeekdayNumber
	order by date_;
			
			
	--Segmentation of day baed on time 		
	Select time_, 
			case	
				When time_ between '05:00:00' and '09:29:59' Then 'Morning'
				When time_ between '09:30:00' and '11:59:59' Then 'Late Morning'
				When time_ between '12:00:00' and '13:29:59' Then 'Afternoon'
				When time_ between '13:30:00' and '15:59:59' Then 'Evening'
				When time_ between '16:00:00' and '18:59:59' Then 'Late Evening'
				When time_ between '19:00:00' and '22:29:59' Then 'Night'
				When time_ between '22:30:00' and '23:59:59' Then 'Mid Night'
				When time_ between '00:00:00' and '04:59:59' Then 'Early Morning'
				Else 'Unkown'
			End Day_Segment
	from sales;
			

	select 		Invoice_ID,Branch,City,Customer_type,Gender,Product_line,
				Unit_price,Quantity,Tax,
				Total,Date_,
				CASE 
					WHEN EXTRACT(DOW FROM date_::DATE) = 0 THEN 'Monday'
					WHEN EXTRACT(DOW FROM date_::DATE) = 1 THEN 'Tuesday'
					WHEN EXTRACT(DOW FROM date_::DATE) = 2 THEN 'Wednesday'
					WHEN EXTRACT(DOW FROM date_::DATE) = 3 THEN 'Thursday'
					WHEN EXTRACT(DOW FROM date_::DATE) = 4 THEN 'Friday'
					WHEN EXTRACT(DOW FROM date_::DATE) = 5 THEN 'Saturday'
					WHEN EXTRACT(DOW FROM date_::DATE) = 6 THEN 'Sunday'
					ELSE 'Unknown'
				END AS Weekday,
				Time_,
			case	
				When time_ between '05:00:00' and '09:29:59' Then 'Morning'
				When time_ between '09:30:00' and '11:59:59' Then 'Late Morning'
				When time_ between '12:00:00' and '13:29:59' Then 'Afternoon'
				When time_ between '13:30:00' and '15:59:59' Then 'Evening'
				When time_ between '16:00:00' and '18:59:59' Then 'Late Evening'
				When time_ between '19:00:00' and '22:29:59' Then 'Night'
				When time_ between '22:30:00' and '23:59:59' Then 'Mid Night'
				When time_ between '00:00:00' and '04:59:59' Then 'Early Morning'
				Else 'Unkown'
			End Day_Segment,
			Payment,cogs,gross_margin_percentage,gross_income,Rating
	from sales
	group by Invoice_ID,Branch,City,Customer_type,Gender,Product_line,Unit_price,Quantity,Tax,
				Total,Date_,Time_,Payment,cogs,gross_margin_percentage,gross_income,Rating


	Select * from sales;




	--Finding Unique City name
	select Distinct city 
	from sales;


	--Unique Branch
	select branch,city 
	from sales
	group by branch,city
	order by branch;


	--Unique product with their count
	--select distinct product_line from sales
	select product_line,count(0) 
	from sales
	group by product_line

	--Unique customer with their count
	select customer,count(0) 
	from sales
	group by customer

	--Gender with their count
	select gender,count(0) 
	from sales
	group by gender


	--Most used payment
	select payment,count(payment) paycount 
	from sales 
	group by payment
	order by paycount desc
	LIMIT 1;


	--Most selling product 
	select product_line, Count(product_line) product_sold
	from sales 
	group by product_line
	order by product_sold desc


	--Total revenue by Month
	select to_char(date_::date,'Month') Month_, ROUND(CAST(SUM(total) AS NUMERIC), 2) Total_revenue
	from sales 
	group by Month_ 
	order by Total_revenue desc


	--Month with largest COGS value
	select to_char(date_::date, 'Month') Month_name , ROUND(CAST(SUM(cogs) AS NUMERIC), 2) total_cogs
	from sales 
	group by Month_name
	order by total_cogs desc
	--limit 1;


	--Product with highest revenue
	select product_line, round(cast(sum(total) as numeric),2) product_total 
	from sales
	group by product_line
	order by product_total desc
	--limit 1;


	--City with highest revenue
	select City, round(cast(sum(total) as numeric),2) city_total 
	from sales
	group by City
	order by city_total desc
	--limit 1;


	--Product with highest taxex
	select product_line, round(cast(Avg(tax) as numeric),2 ) product_tax 
	from sales
	group by product_line
	order by product_tax desc
	--limit 1;


	--Catogarizing productss based on ratings
	select product_line, 
		case 
			when rating > 7 then 'good'
			when rating > 4.5 then 'Average'
			else 'Bad'
		end ratings
	from sales


	-- Branches that sales are higher then average sales
	select branch,sum(quantity)
	from sales
	group by branch
	having sum(quantity) > (select avg(quantity) from sales)
	order by branch;


	--Most used product by gender
	select product_line, gender, count(gender) cnt
	from sales
	group by product_line,gender
	order by cnt desc;


	--Average ratings based on products
	select product_line,round(cast(avg(rating) as numeric),1) ratings
	from sales
	group by product_line
	order by ratings desc;


	--Poduct sold in a day based on time 	
	with day_seg as(
	Select time_, 
			case	
				When time_ between '05:00:00' and '09:29:59' Then 'Morning'
				When time_ between '09:30:00' and '11:59:59' Then 'Late Morning'
				When time_ between '12:00:00' and '13:29:59' Then 'Afternoon'
				When time_ between '13:30:00' and '15:59:59' Then 'Evening'
				When time_ between '16:00:00' and '18:59:59' Then 'Late Evening'
				When time_ between '19:00:00' and '22:29:59' Then 'Night'
				When time_ between '22:30:00' and '23:59:59' Then 'Mid Night'
				When time_ between '00:00:00' and '04:59:59' Then 'Early Morning'
				Else 'Unkown'
			End Day_Segment
	from sales
	)
	select ds.Day_Segment, count(s.product_line) product_sold
	from sales s join day_seg ds
	on ds.time_ = s.time_
	group by ds.Day_Segment 
	order by product_sold desc


	--Calculating the sales by weekday using date function
	with Weekday_ as (
	SELECT date_, 
		CASE 
			WHEN EXTRACT(DOW FROM date_::DATE) = 0 THEN 'Monday'
			WHEN EXTRACT(DOW FROM date_::DATE) = 1 THEN 'Tuesday'
			WHEN EXTRACT(DOW FROM date_::DATE) = 2 THEN 'Wednesday'
			WHEN EXTRACT(DOW FROM date_::DATE) = 3 THEN 'Thursday'
			WHEN EXTRACT(DOW FROM date_::DATE) = 4 THEN 'Friday'
			WHEN EXTRACT(DOW FROM date_::DATE) = 5 THEN 'Saturday'
			WHEN EXTRACT(DOW FROM date_::DATE) = 6 THEN 'Sunday'
			ELSE 'Unknown'
		END AS Weekday
	FROM sales
	group by date_,Weekday
	)
	select  w.weekday, count(s.product_line)
	from sales s join Weekday_ w
	on s.date_ = w.date_
	group by w.weekday
	order by w.weekday

	--- sales change week wise
	with weeksales as(
	select branch,product_line,payment,customer_type,gender,
		EXTRACT(WEEK From date_) weekno, round(cast(sum(total) as numeric),2) Total
	from sales
	group by weekno,branch,product_line,payment,customer_type,gender
	order by weekno
	)
	select 
		weekno,branch,product_line,payment,customer_type,gender,total,
		LAG(total, 1, 0) OVER (ORDER BY weekno) AS prev_total,
		total - LAG(total, 1, 0) OVER (ORDER BY weekno) AS total_change
	from weeksales;

	--- sales change month wise
	with monthsales as(
	select branch,product_line,payment,customer_type,gender,
		EXTRACT(Month From date_) monthno, round(cast(sum(total) as numeric),2) Total
	from sales
	group by monthno,branch,product_line,payment,customer_type,gender
	order by monthno
	)
	select 
		monthno, total,branch,product_line,payment,customer_type,gender,total,
		LAG(total, 1, 0) OVER (ORDER BY monthno) AS prev_total,
		total - LAG(total, 1, 0) OVER (ORDER BY monthno) AS total_change
	from monthsales;







			
