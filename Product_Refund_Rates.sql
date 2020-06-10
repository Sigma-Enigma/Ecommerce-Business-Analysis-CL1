-- Monthly Product Refund Rates

-- montly rate by product, look at change in rate to see if product quality issues have been resolved

USE ecommerce_data;


-- want total orders per month, orders returned, and percent returned
SELECT
	YEAR ( order_items.created_at) AS yr,
	MONTH( order_items.created_at) AS mo,
	COUNT( DISTINCT order_items.order_item_id ) AS items_ordered,
	COUNT( DISTINCT order_item_refunds.order_item_refund_id ) AS items_returned,
	COUNT( DISTINCT order_item_refunds.order_item_refund_id ) / COUNT( DISTINCT order_items.order_item_id ) AS perc_returned,
	COUNT( DISTINCT CASE WHEN order_items.product_id = 1 THEN order_item_refunds.order_item_refund_id ELSE NULL END ) / COUNT( DISTINCT CASE WHEN order_items.product_id = 1 THEN order_items.order_item_id ELSE NULL END  ) AS p1_perc_returned,
	COUNT( DISTINCT CASE WHEN order_items.product_id = 2 THEN order_item_refunds.order_item_refund_id ELSE NULL END ) / COUNT( DISTINCT CASE WHEN order_items.product_id = 2 THEN order_items.order_item_id ELSE NULL END  ) AS p2_perc_returned,
	COUNT( DISTINCT CASE WHEN order_items.product_id = 3 THEN order_item_refunds.order_item_refund_id ELSE NULL END ) / COUNT( DISTINCT CASE WHEN order_items.product_id = 3 THEN order_items.order_item_id ELSE NULL END  ) AS p3_perc_returned,
	COUNT( DISTINCT CASE WHEN order_items.product_id = 4 THEN order_item_refunds.order_item_refund_id ELSE NULL END ) / COUNT( DISTINCT CASE WHEN order_items.product_id = 4 THEN order_items.order_item_id ELSE NULL END  ) AS p4_perc_returned

FROM order_items
	LEFT JOIN order_item_refunds
    ON order_item_refunds.order_item_id = order_items.order_item_id

WHERE order_items.created_at <= '2014-10-15'

GROUP BY 1,2

ORDER BY 1,2
;