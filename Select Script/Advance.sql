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


