show databases;

use classicmodels;

show tables;

-- Getting the details of all the tables--
select * from customers;
select * from employees;
select * from offices;
select * from orderdetails;
select * from orders;
select * from payments;
select * from productlines;
select * from products;

-- Getting the details of the how many rows are present in each table--
SELECT COUNT(*) Total_Customer FROM CUSTOMERS; -- 122 Rows are present in customers table --
SELECT COUNT(*) Total_Employees FROM EMPLOYEES; -- 23 Rows are present in employees table --
SELECT COUNT(*) Total_Offices FROM OFFICES; -- 07 Rows are present in offices table --
SELECT COUNT(*) Order_Details FROM ORDERDETAILS; -- 2996 Rows are present in Order Details table --
SELECT COUNT(*) Total_Orders FROM ORDERS; -- 326 Rows are present in Orders table --
SELECT COUNT(*) Total_Payments FROM PAYMENTS; -- 273 Rows are present in Payments table --
SELECT COUNT(*) Total_Productlines FROM PRODUCTLINES; -- 07 Rows are present in Product Lines table --
SELECT COUNT(*) Total_Products FROM PRODUCTS; -- 110 Rows are present in Products table --

-- Total Sales Or Revenue-- 
SELECT SUM(quantityOrdered * priceEach) AS TOTAL_REVENUE FROM ORDERDETAILS;

-- Total Profit -- 
SELECT  SUM((quantityOrdered * priceEach) - (buyprice * quantityOrdered)) as TOTAL_PROFIT FROM PRODUCTS P
JOIN ORDERDETAILS O ON O.PRODUCTCODE = P.PRODUCTCODE;

-- Total Orders	--
SELECT COUNT(distinct ordernumber) AS TOTAL_ORDERS FROM ORDERDETAILS;

-- Total Products Sold	--
SELECT SUM(quantityOrdered) AS TOTAL_PRODUCTS_SOLD FROM ORDERDETAILS;

-- Monthly Products Sold -- 
SELECT DATE_FORMAT(ORDERDATE, '%Y-%m') AS YEARMONTH, SUM(QUANTITYORDERED) AS TOTAL_PRODUCTS_SOLD
FROM ORDERDETAILS OD
JOIN ORDERS O ON O.ORDERNUMBER = OD.ORDERNUMBER
GROUP BY YEARMONTH
ORDER BY YEARMONTH;

-- Monthly Revenue -- 
SELECT DATE_FORMAT(ORDERDATE, '%Y-%m') AS YEARMONTH, SUM(quantityOrdered * priceEach) AS TOTAL_REVENUE
FROM ORDERDETAILS OD
JOIN ORDERS O ON O.ORDERNUMBER = OD.ORDERNUMBER
GROUP BY YEARMONTH
ORDER BY TOTAL_REVENUE desc; -- There is a huge increase in the number of products sold and revenue generated in month november in 2003 and 2004 --

-- Products Sold by Sales Representative --
SELECT CONCAT(FIRSTNAME, ' ', LASTNAME) AS EMPLOYEE_FULL_NAME, SUM(QUANTITYORDERED) AS TOTAL_PRODUCTS
FROM EMPLOYEES E
JOIN CUSTOMERS C ON C.SALESREPEMPLOYEENUMBER = E.EMPLOYEENUMBER
JOIN ORDERS O ON C.CUSTOMERNUMBER = O.CUSTOMERNUMBER
JOIN ORDERDETAILS OD ON O.ORDERNUMBER = OD.ORDERNUMBER
GROUP BY EMPLOYEENUMBER
ORDER BY TOTAL_PRODUCTS DESC;

-- Total Revenue by Country --
SELECT COUNTRY, SUM(QUANTITYORDERED * PRICEEACH) AS TOTAL_REVENUE
FROM CUSTOMERS C
JOIN ORDERS O ON O.CUSTOMERNUMBER = C.CUSTOMERNUMBER
JOIN ORDERDETAILS OD ON O.ORDERNUMBER = OD.ORDERNUMBER
GROUP BY COUNTRY
ORDER BY TOTAL_REVENUE DESC;

-- Total Sales Contribution by Product Vendor --
SELECT PRODUCTVENDOR, SUM(QUANTITYORDERED * PRICEEACH) AS TOTAL_SALES
FROM PRODUCTS P
JOIN ORDERDETAILS OD ON P.PRODUCTCODE = OD.PRODUCTCODE
GROUP BY PRODUCTVENDOR
ORDER BY TOTAL_SALES DESC;

-- Total Sales by Product Category(Product lines) --
SELECT PRODUCTLINE, SUM(QUANTITYORDERED * PRICEEACH) AS TOTAL_SALES
FROM PRODUCTS P
JOIN ORDERDETAILS OD ON P.PRODUCTCODE = OD.PRODUCTCODE
GROUP BY PRODUCTLINE
ORDER BY TOTAL_SALES DESC;

-- Total Sales by Products --
SELECT PRODUCTNAME, SUM(QUANTITYORDERED * PRICEEACH) AS TOTAL_SALES
FROM PRODUCTS P
JOIN ORDERDETAILS OD ON P.PRODUCTCODE = OD.PRODUCTCODE
GROUP BY PRODUCTNAME
ORDER BY TOTAL_SALES DESC;

-- Customers by Revenue --
SELECT CUSTOMERNAME, SUM(QUANTITYORDERED * PRICEEACH) AS TOTAL_REVENUE
FROM CUSTOMERS C
JOIN ORDERS O ON C.CUSTOMERNUMBER = O.CUSTOMERNUMBER
JOIN ORDERDETAILS OD ON O.ORDERNUMBER = OD.ORDERNUMBER
GROUP BY C.CUSTOMERNUMBER
ORDER BY TOTAL_REVENUE DESC
LIMIT 10;

-- Number of customers for each sales representative --
select e.employeenumber,concat(e.firstname," ",e.lastname) FullName,count(*) Total_customers
from customers c
join employees e on c.salesrepemployeenumber = e.employeenumber
where salesrepemployeenumber is not null
group by e.employeenumber
order by Total_customers desc;

-- Customers and their country who dont have sales representative --
select customernumber,customername,country,city
from customers
where salesRepEmployeeNumber is null;

-- Number of employees in each office --
select officecode,count(*) Total_Employees
from employees
group by officecode;

-- Total quantity of products ordered by each customer --
select o.Customernumber,Customername,country,sum(quantityordered) Total_Quantity_of_Products
from orderdetails od
join orders o on od.ordernumber=o.ordernumber
join customers c on c.customernumber=o.customernumber
group by O.customernumber
order by Total_Quantity_of_Products desc;

-- Number of orders placed by each customer --
select customername,count(*) Total_Orders
from orders o
join customers c on c.customerNumber = o.customerNumber
group by o.customernumber
order by count(*) desc;

-- Amount received from the customers --
select sum(amount) Total_amount from payments;

-- Number of products in each productline --
select productline,count(*) Total_products
from products 
group by productline
order by Total_products desc;

-- Orders in each productline --
select productline,count(o.orderNumber) Total_orders
from products p
join orderdetails od on p.productcode=od.productcode
join orders o on o.ordernumber=od.ordernumber
group by productline
order by Total_orders desc;

-- Which product has highest number of Customers --
select p.Productcode,productname,count(c.customernumber) Total_customers
from customers c
join orders o on c.customernumber=o.customernumber
join orderdetails od on o.ordernumber=od.ordernumber
join products p on p.productcode=od.productcode
group by p.Productcode,productname
order by Total_customers desc
limit 1;

-- Which product has least number of Customers --
select p.Productcode,productname,count(c.customernumber) Total_customers
from customers c
join orders o on c.customernumber=o.customernumber
join orderdetails od on o.ordernumber=od.ordernumber
join products p on p.productcode=od.productcode
group by p.Productcode,productname
order by Total_customers asc
limit 1;

-- Product which is not ordered by any customer --
select distinct P.Productcode,productname,p.productline
from products p
left join orderdetails od on p.productcode=od.productcode
join productlines pl on p.productline=pl.productline
where od.productcode is null;