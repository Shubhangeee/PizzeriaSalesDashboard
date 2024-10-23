----Data Clean Up
select * from [PizzaInn].[dbo].[Tbl_Pizza_Sales]

ALTER TABLE [PizzaInn].[dbo].[Tbl_Pizza_Sales]
ADD  [Day Name] VARCHAR(50),
	 [Order Name] VARCHAR(50),
	 [Day Number] INT;

SELECT DATENAME(WEEKDAY, ORDER_DATE), upper(FORMAT(CAST(ORDER_DATE AS DATE), 'ddd')) ,
CASE When DATENAME(WEEKDAY, ORDER_DATE) = 'Sunday' THEN 1
	   When DATENAME(WEEKDAY, ORDER_DATE) = 'Monday' THEN 2
	   When DATENAME(WEEKDAY, ORDER_DATE) = 'Tuesday' THEN 3
	   When DATENAME(WEEKDAY, ORDER_DATE) = 'Wednesday' THEN 4
	   When DATENAME(WEEKDAY, ORDER_DATE) = 'Thursday' THEN 5
	   When DATENAME(WEEKDAY, ORDER_DATE) = 'Friday' THEN 6
	   When DATENAME(WEEKDAY, ORDER_DATE) = 'Saturday' THEN 7
	   ELSE DATENAME(WEEKDAY, ORDER_DATE)
	   END 
from [PizzaInn].[dbo].[Tbl_Pizza_Sales]

update [PizzaInn].[dbo].[Tbl_Pizza_Sales] set 
[Day Name] = DATENAME(WEEKDAY, ORDER_DATE), 
[Order Name] = upper(FORMAT(CAST(ORDER_DATE AS DATE), 'ddd')) ,
[Day Number] = CASE When DATENAME(WEEKDAY, ORDER_DATE) = 'Sunday' THEN 1
	   When DATENAME(WEEKDAY, ORDER_DATE) = 'Monday' THEN 2
	   When DATENAME(WEEKDAY, ORDER_DATE) = 'Tuesday' THEN 3
	   When DATENAME(WEEKDAY, ORDER_DATE) = 'Wednesday' THEN 4
	   When DATENAME(WEEKDAY, ORDER_DATE) = 'Thursday' THEN 5
	   When DATENAME(WEEKDAY, ORDER_DATE) = 'Friday' THEN 6
	   When DATENAME(WEEKDAY, ORDER_DATE) = 'Saturday' THEN 7
	   ELSE DATENAME(WEEKDAY, ORDER_DATE)
	   END 


------------------------------------------------------------------------------------------------------------------------
--Make pizza size meaningful by specifying full name
select distinct pizza_size from [PizzaInn].[dbo].[Tbl_Pizza_Sales]

Select pizza_size
, CASE When pizza_size = 'L' THEN 'Large'
	   When pizza_size = 'XXL' THEN 'Xtra Xtra Large'
	   When pizza_size = 'M' THEN 'Medium'
	   When pizza_size = 'XL' THEN 'Xtra Large'
	   When pizza_size = 'S' THEN 'Small'
	   ELSE pizza_size
	   END as Update_pizza_size
From [PizzaInn].[dbo].[Tbl_Pizza_Sales]

Update [PizzaInn].[dbo].[Tbl_Pizza_Sales]
SET pizza_size = CASE When pizza_size = 'L' THEN 'Large'
	   When pizza_size = 'XXL' THEN 'Extra Extra Large'
	   When pizza_size = 'M' THEN 'Medium'
	   When pizza_size = 'XL' THEN 'Extra Large'
	   When pizza_size = 'S' THEN 'Small'
	   ELSE pizza_size
	   END

select distinct pizza_size from [PizzaInn].[dbo].[Tbl_Pizza_Sales]

------------------------------------------------------------------------------------------------------------------------
--KPI Requirements
		--1. Total Revenue:
SELECT SUM(total_price) AS Total_Revenue FROM [PizzaInn].[dbo].[Tbl_Pizza_Sales];

		--2. Average Order Value
SELECT (SUM(total_price) / COUNT(DISTINCT order_id)) AS Avg_order_Value FROM [PizzaInn].[dbo].[Tbl_Pizza_Sales]
 
		--3. Total Pizzas Sold
SELECT SUM(quantity) AS Total_pizza_sold FROM [PizzaInn].[dbo].[Tbl_Pizza_Sales]
 
		--4. Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_Orders FROM [PizzaInn].[dbo].[Tbl_Pizza_Sales]
 
		--5. Average Pizzas Per Order
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2))
AS Avg_Pizzas_per_order
FROM [PizzaInn].[dbo].[Tbl_Pizza_Sales]


--A. Daily Trend for Total Orders
SELECT DATENAME(DW, order_date) AS order_day, COUNT(DISTINCT order_id) AS total_orders 
FROM [PizzaInn].[dbo].[Tbl_Pizza_Sales]
GROUP BY DATENAME(DW, order_date)

 
--B. Monthly Trend for Orders
select DATENAME(MONTH, order_date) as Month_Name, COUNT(DISTINCT order_id) as Total_Orders
from [PizzaInn].[dbo].[Tbl_Pizza_Sales]
GROUP BY DATENAME(MONTH, order_date)
 


--C. Percentage of Sales by Pizza Category
SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from [PizzaInn].[dbo].[Tbl_Pizza_Sales]) AS DECIMAL(10,2)) AS PCT
FROM [PizzaInn].[dbo].[Tbl_Pizza_Sales]
GROUP BY pizza_category

 
--D. Percentage of Sales by Pizza Size
SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from [PizzaInn].[dbo].[Tbl_Pizza_Sales]) AS DECIMAL(10,2)) AS PCT
FROM [PizzaInn].[dbo].[Tbl_Pizza_Sales]
GROUP BY pizza_size
ORDER BY pizza_size



--E. Total Pizzas Sold by Pizza Category
SELECT pizza_category, SUM(quantity) as Total_Quantity_Sold
FROM [PizzaInn].[dbo].[Tbl_Pizza_Sales]
WHERE MONTH(order_date) = 2
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC

 
--F. Top 5 Pizzas by Revenue
SELECT Top 5 pizza_name, SUM(total_price) AS Total_Revenue
FROM [PizzaInn].[dbo].[Tbl_Pizza_Sales]
GROUP BY pizza_name
ORDER BY Total_Revenue DESC
 
--G. Bottom 5 Pizzas by Revenue
SELECT Top 5 pizza_name, SUM(total_price) AS Total_Revenue
FROM [PizzaInn].[dbo].[Tbl_Pizza_Sales]
GROUP BY pizza_name
ORDER BY Total_Revenue ASC
 
--H. Top 5 Pizzas by Quantity
SELECT Top 5 pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM [PizzaInn].[dbo].[Tbl_Pizza_Sales]
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC

 
--I. Bottom 5 Pizzas by Quantity
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM [PizzaInn].[dbo].[Tbl_Pizza_Sales]
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold ASC


--J. Top 5 Pizzas by Total Orders
SELECT Top 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM [PizzaInn].[dbo].[Tbl_Pizza_Sales]
GROUP BY pizza_name
ORDER BY Total_Orders DESC
 
--K. Borrom 5 Pizzas by Total Orders
SELECT Top 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM [PizzaInn].[dbo].[Tbl_Pizza_Sales]
GROUP BY pizza_name
ORDER BY Total_Orders ASC
 
--NOTE
--If you want to apply the pizza_category or pizza_size filters to the above queries you can use WHERE clause. Follow some of below examples
SELECT Top 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM [PizzaInn].[dbo].[Tbl_Pizza_Sales]
WHERE pizza_category = 'Classic'
GROUP BY pizza_name
ORDER BY Total_Orders ASC

------------------------------------------------------------------------------------------------------------------------
