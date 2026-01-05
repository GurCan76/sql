select p1.product_name, p2.product_name, (p1.unit_price- p2.unit_price) as  DIfference_Price
    FROM products p1 INNER JOIN products p2
    where p1.unit_price - p2.unit_price 
    < 0.25 AND p1.unit_price - p2.unit_price 
    >= 0 
    AND p1.product_id <> p2.product_id;

-- Subqueries

select p1.product_id, p1.product_name, (select avg(unit_price) from products) as UNit_Price ,p1.unit_price - (select avg(unit_price) from products) as Difference_UNit_Price 
    FROM products p1
    ORDER BY unit_price DESC;


-- Return each country happiness score for the year alongside the country's average happiness score

select hs.year, hs.country, hs.happiness_score, country_hs.avgscore
    FROM happiness_scores hs
        LEFT JOIN (
                    select country, AVG(happiness_score) as AvgScore
                        FROM happiness_scores hs1
                            GROUP BY hs1.country
                ) as country_hs
                ON hs.country = country_hs.country
                ORDER BY country DESC
     ;

select year, country, happiness_score from happiness_scores
UNION all
select 2024, country, ladder_score from happiness_scores_current;

-- Multiple SUbQueries with different aliases
select hs.year, hs.country, hs.happiness_score, country_hs. Avg_HS_BY_Country
    FROM (select year, country, happiness_score from happiness_scores
            UNION all
            select 2024, country, ladder_score from happiness_scores_current    ) 
        as hs
        LEFT JOIN (
                    select country, AVG(happiness_score) as Avg_HS_BY_Country
                        FROM happiness_scores hs1
                            GROUP BY hs1.country
                ) as country_hs
                ON hs.country = country_hs.country
                 
       WHERE hs.happiness_score > country_hs.Avg_HS_BY_Country +1
     ;


-- TRY ON OWN AGAIN --------------------------
-- Give list of factories, along with the names of the products they produce and number of product they produce
select factory, count(product_id)  from products 
    GROUP BY factory
 ;



Select fp.factory, fp.product_name, fn.factory_Count
 FROM
(select factory,product_name  from products GROUP BY factory,product_name) FP
LEFT JOIN
(select factory, count(product_id) as factory_Count from products 
    GROUP BY factory) FN
ON
    fp.factory = fn.factory
ORDER BY
    fp.factory    
;


-- hello fourth commit

-- Return regions with average happiness score more than overall average happinesss core

SELECT  AVG(hs.happiness_score)
FROM
happiness_scores hs


;
select hs.region, hs.Average_HS_Region
from (SELECT  hs.region,  AVG(hs.happiness_score) as Average_HS_Region
        FROM
        happiness_scores hs
        GROUP BY hs.region) as HS

 WHERE hs.Average_HS_Region > (SELECT  AVG(hs.happiness_score)
                                FROM
                                happiness_scores hs) 
;

-- USING HAVING CLAUSE
SELECT  hs.region,  AVG(hs.happiness_score) as Average_HS_Region
FROM happiness_scores hs
GROUP BY hs.region
HAVING Average_HS_Region >  (SELECT  AVG(hs.happiness_score) FROM happiness_scores hs)
;

-- COORELATED SUBQUERIES ... HAPPEN TO BE SLOW.. SOME DATABASES OPTIMIZE ON THEIR OWN.
SELECT H.COUNTRY, H.happiness_score 
FROM happiness_scores H
WHERE  EXISTS 
(SELECT I.country_name 
FROM inflation_rates I
WHERE I.country_name = H.country
)
;
-- OTHER WAY IS TO TO USE INNER JOIN FOR OPTIMIZED RESULTS.
SELECT COUNTRY FROM happiness_scores;
SELECT * FROM inflation_rates;

SELECT H.COUNTRY, H.happiness_score 
FROM happiness_scores H
INNER JOIN
inflation_rates I 
ON H.country= I.country_name and h.YEAR = i.YEAR
;

SELECT H.COUNTRY, H.happiness_score 
FROM happiness_scores H
WHERE  H.country IN
(SELECT DISTINCT(I.country_name )
FROM inflation_rates I
)
;

-- Identify products that have a unit price less than unit price of all products from Wicked choccy's. Also include which facotry is priducing them as well.

SELECT factory, product_name, unit_price FROM
    products p
WHERE p.unit_price <
(select min(unit_price)
FROM products
where factory LIKE '%Wicked%'
)
;

--  USING subqueries in CTE   such as WITH
-- Return regions with average happiness score more than overall average happinesss core
WITH HS as (
        SELECT  
            region
            ,AVG(happiness_score) as Average_HS_Region
        FROM happiness_scores            
        GROUP BY region
        )
select 
    hs.region
    ,hs.Average_HS_Region
from HS
WHERE hs.Average_HS_Region > (
    SELECT  AVG(hs.happiness_score)
    FROM
    happiness_scores hs
    ) 
;


-- Using multiple CTE's
-- For each country , return countries from the same region with a lower happiness score in 2023
WITH HS as (
select 
    hs1.YEAR
    , hs1.region
    , hs1.country
    , hs1.happiness_score
FROM happiness_scores HS1
where year = 2023
)
SELECT 
    hs1.YEAR
    ,hs1.region
    , hs1.country
    , hs1.happiness_score
    , hs2.country
    , hs2. happiness_score
FROM HS hs1 INNER JOIN HS hs2
ON hs1.region = hs2.region and hs1.country <> hs2.country

where hs2.happiness_score < hs1.happiness_score
ORDER BY hs1.region, hs1.happiness_score,  hs1.country asc
;

-- All orders above 200 CAD . Also to tal number of orders above 200.


with OrdersDetail as (
    select o.order_id, sum  (o.units * p.unit_price) as OrderCost
        FROM orders o
        LEFT JOIN
        products p
        ON o.product_id = p.product_id
        GROUP BY order_id
        HAVING  ordercost >200   
-- remove orderby in final query to optimize it.
  --      ORDER BY order_id
)
select count(order_id)
        FROM
        `OrdersDetail`
 
;

-- compare 2023 and 2024 happiness score sside by side


Select * from 
(
with hs23 as (select * from happiness_scores where year = 2023),
     hs24 as (select * from happiness_scores_current)
select hs23.country
        ,hs23.happiness_score as hs_2023
        ,hs24.ladder_score as hs_2024
FROM hs23 INNER JOIN hs24
ON hs23.country = hs24.country
) as hs_23_24
where hs_2023 > hs_2024
;

-- Using recursive CTE's
-- Create the reporting chain gierarchy of employees

select * 
FROM employees;