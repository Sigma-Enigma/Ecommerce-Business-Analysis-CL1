-- Analyzing New & Repeat Conversion Rates

-- will need order data so join orders, also session data to determine number of potential buyers

SELECT *
FROM website_sessions
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-08'
;
