/*=========================================================
Project : Olist E-commerce Analysis
Author  : Rohit Lal
Database: SQL Server
=========================================================*/

USE olist_project;
go 

/*=========================================================
1. Total Orders, Customers, Sellers, Products and Revenue
=========================================================*/

select count (order_id) as total_orders
from olist_orders_dataset ;

select count (customer_id) as total_customer
from olist_customers_dataset;

select count (seller_id) as total_seller
from olist_sellers_dataset;

select count(product_id) as total_product
from olist_products_dataset_2;

select sum (price) as total_revenue
from olist_order_items_dataset;

/*======================================
2. Calculate Average Order Value (AOV).
=======================================*/

select count ( distinct o.order_id) as total_order,
sum (ol.price) as total_revenue,
sum (ol.price) / count(distinct o.order_id) as toal_avrage_value
from olist_orders_dataset as o
inner join olist_order_items_dataset as ol
on o.order_id = ol.order_id;

/*=====================================
   Task 3 : Monthly Revenue Trend
 =====================================*/

select year (o.order_purchase_timestamp) as order_year,
month (o.order_purchase_timestamp) as order_months,
sum (ol.price) as total_revenue
from olist_orders_dataset as o
inner join olist_order_items_dataset as ol
on o.order_id = ol.order_id
group by year (o.order_purchase_timestamp),
         month (o.order_purchase_timestamp)
order by total_revenue desc;

-- =======================================
-- 4. Top 10 Product Categories by Revenue.
-- =======================================

select top 10 p.product_category_name,
sum (ol.price) as total_revenue
from olist_products_dataset_2 as p
inner join olist_order_items_dataset as ol
on p.product_id = ol.product_id
group by  p.product_category_name
order by total_revenue desc;

/*==============================
5. Top 10 Customers by Spending.
==============================*/

select top 10 o.customer_id,
sum (ol.price) as total_spending
from olist_orders_dataset as o
inner join olist_order_items_dataset as ol
on o.order_id = ol.order_id 
group by o.customer_id
order by total_spending desc; 

/*===========================
6. Top 10 Sellers by Revenue.
============================*/

select top 10 s.seller_id,
sum (ol.price) as revenue
from olist_sellers_dataset as s
inner join olist_order_items_dataset as ol
on s.seller_id = ol.seller_id 
group by s.seller_id
order by revenue desc;

/*==================
7. Revenue by State.
===================*/

select top 5
c.customer_state,
sum (ol.price) as revenue
from olist_orders_dataset as o
inner join olist_order_items_dataset as ol
on o.order_id = ol.order_id
inner join olist_customers_dataset as c
on o.customer_id = c.customer_id
group by c.customer_state
order by revenue desc;


/*===========================================
8. Average Delivery Time and Delayed Orders.
============================================*/

select 
 avg( DATEDIFF ( day,
 order_purchase_timestamp,
 order_estimated_delivery_date) )AS avrage_delivery_time
 from olist_orders_dataset;
 
select count (order_id)as delayed_order
from olist_orders_dataset
where order_delivered_customer_date > order_estimated_delivery_date ;

/*====================================================
9. Most Used Payment Method and Installment Analysis.
=====================================================*/

select
payment_type, 
count (order_id) as total_order
from olist_order_payments_dataset
group by payment_type
order by total_order desc;

/*=========================
10. Find Repeat Customers.
=========================*/

select customer_id,
count (order_id) as total_revenue
from olist_orders_dataset
group by customer_id 
having count(order_id) > 1
order by total_revenue;

/*=============================================
11. Rank Product Categories using DENSE_RANK().
==============================================*/

select 
o.product_category_name,
count (ol.price) as total_revenue,
dense_rank () over( order by sum(ol.price) desc) as categeroy_rank
from olist_products_dataset_2 as o
inner join olist_order_items_dataset as ol
on o.product_id = ol.product_id
group by o.product_category_name
having count(ol.price) > 1
order by categeroy_rank;

use olist_project;
go 
/*================================================
12. Create a Monthly Revenue View using CTE/View.
================================================*/

create view monthlyrevenueviwe as 
select 
year ( o.order_purchase_timestamp) as order_year,
month ( o.order_purchase_timestamp) as order_month,
sum(ol.price) as total_revenue                                       
from olist_orders_dataset as o
inner join olist_order_items_dataset as ol
on o.order_id = ol.order_id 
group by year (o.order_purchase_timestamp),
         month (o.order_purchase_timestamp);

select * from monthlyrevenueviwe;



