create database zepto_sql_project ;
show databases;
use zepto_sql_project ;
-- drop table zepto_v2;
create table zepto_v2(Category varchar(120), name varchar(120),
mrp numeric(8,2), discountPercent numeric(5,2), 
availableQuantity integer, discountedSellingPrice numeric(8,2), weightInGms integer, OutOfStock boolean, Quantity integer);
# check the import table from
select * from zepto_v2 ;
-- count the rows
select count(*) from zepto_v2 ;
-- sample data 
select * from zepto_v2 limit 10 ;
ALTER TABLE zepto_v2 CHANGE `ï»¿Category` Category VARCHAR(100);
-- add one more column
alter table zepto_v2 add column sku_id int primary key auto_increment ;
select * from zepto_v2 ;
-- checking null values
select * from zepto_v2 where name is NULL 
or
mrp is NULL 
or
discountPercent is NULL 
or
Category is NULL 
or
availableQuantity is NULL 
or
discountedSellingPrice is NULL 
or
weightInGms is NULL
or 
outOfStock is NULL 
or
quantity is NULL ;
-- different product Categories
select distinct Category from zepto_v2  order by category ;
-- product in out of stock vs out of stock 
select outOfStock, count(sku_id) from zepto_v2 group by outOfStock ;

-- product name present multiple times
select name , count(sku_id) as "Number of skus" from zepto_v2 group by name having
 count(sku_id)>1 order by count(sku_id) desc ;
 
-- data cleaning
-- product with price = 0
select * from zepto_v2 where mrp=0 or DiscountedSellingPrice =0 ;
 -- we need to remove the zero mrp product
 set sql_safe_updates = 0;
 delete from zepto_v2 where mrp = 0 ;
 
-- now again checking the product having zero mrp (to check cleaning is done or not)
 select * from zepto_v2 where mrp = 0 or DiscountedSellingPrice = 0 ; 
 
 -- convert paise into rupee
 select * from zepto_v2 ;
 update zepto_v2 
 set mrp =mrp/100,
 discountedSellingPrice = discountedSellingPrice/100; 
 select mrp, discountedSellingPrice from zepto_v2 ;
 
 -- Q1 find the top 10 best valued products based on the discounted pecentage 
 select name, mrp, discountedSellingPrice from zepto_v2 order by discountPercent desc limit 10; 
 
 -- Q2 what are the product with the high mrp but out of stock
 select distinct mrp, outOfStock, Category from zepto_v2 where mrp >300   
 and outOfStock = true order by mrp desc;
 
 -- Q3 calculate Estimated Revenue for each category
select Category, sum(discountedSellingPrice *  availableQuantity) as total_revenue from zepto_v2 
group by Category order by total_revenue ;

-- Q4 find all products where mrp is greater than 500 and discount is less than 10%
select distinct name, mrp, discountPercent from zepto_v2 where mrp > 500 and discountPercent < 10
  order by mrp desc, discountPercent desc ;
  
-- Q5 identifies the top 5 categories offering the highest avg discount percentage 
select Category, round(avg(discountPercent), 2) as avg_discount from zepto_v2 
group by Category order by avg_discount desc limit 5; 

-- Q6 find the price per gram for products above 100g and short by best values.
select Distinct name,weightInGms,discountedSellingPrice, round(discountedSellingPrice/weightInGms, 2) as price_per_gram from zepto_v2 
where weightInGms > 100 order by price_per_gram;

-- Q7 Group the product into categories like low, medium, bulk 
select max(weightInGms) from zepto_v2;
select min(weightInGms) from zepto_v2;
select distinct name, weightInGms,
case when weightInGms < 1000 then 'Low'
when weightInGms < 5000 then 'Medium'
else 'Bulk' end as weight_category from zepto_v2 ; 

 -- Q8 what is the total Inventory Weight per Category 
select Category, sum(weightInGms * availableQuantity) as total_weight from zepto_v2
group by Category order by total_weight ;




 
 







