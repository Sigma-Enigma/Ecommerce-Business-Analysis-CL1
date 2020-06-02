-- Analyzing Repeat Behaviors


-- how many customers come back for another session from 2014 to nov 1 2014

-- rows for number of repeat sessions, and columns aggregate of the number of  sessions

-- multi step query, few ways to do it. First one to mind is make tables that says is repeat 1, is repeat 2, is repeat 3 etc

USE ecommerce_data;

SELECT 

	is_repeat_session AS repeated_session,
    COUNT( DISTINCT ) AS users

FROM website_sessions

WHERE created_at BETWEEN '2014-01-01' AND '2014-11-01'

GROUP BY

ORDER BY