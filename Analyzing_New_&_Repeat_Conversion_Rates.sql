-- Analyzing New & Repeat Conversion Rates

-- will need order data so join orders, also session data to determine number of potential buyers

SELECT *
FROM website_sessions
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-08'
;

-- columns is_repeat_session (either row group 0 or row group 1), sessions, conv_rate, rev_per_session
