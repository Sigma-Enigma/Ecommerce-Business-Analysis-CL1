
-- Product Level Sales Analysis

USE ecommerce_data;

SELECT

YEAR(created_at) AS yr,
MONTH(created_at) AS mo,
COUNT( DISTINCT order_id) AS count_sales,
SUM( price_usd) AS tot_revenue,
SUM( price_usd - cogs_usd) AS tot_margin

FROM orders

WHERE created_at < '2013-01-04'

GROUP BY yr, mo

ORDER BY yr, mo;
