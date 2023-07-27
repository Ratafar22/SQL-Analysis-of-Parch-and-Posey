-- SUBQUERIES
-- 1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
SELECT sub3.region_name, sub3.sales_rep_name, sub3.total_amt
FROM(SELECT region_name, MAX(total_amt) total_amt
    FROM (SELECT s.name AS sales_rep_name,
            r.name AS region_name,
            SUM(o.total_amt_usd) AS total_amt
        FROM sales_reps AS s
        JOIN accounts AS a
        ON a.sales_rep_id = s.id
        JOIN orders AS o
        ON o.account_id = a.id
        JOIN region AS r
        ON r.id = s.region_id
     	GROUP BY 1,2) sub1
	GROUP BY 1) sub2
JOIN (SELECT s.name AS sales_rep_name,
          r.name AS region_name,
          SUM(o.total_amt_usd) AS total_amt
      FROM sales_reps AS s
      JOIN accounts AS a
      ON a.sales_rep_id = s.id
      JOIN orders AS o
      ON o.account_id = a.id
      JOIN region AS r
      ON r.id = s.region_id
      GROUP BY 1,2
      ORDER BY 3) sub3
ON sub3.region_name = sub2.region_name AND sub3.total_amt = sub2.total_amt;

-- 2. For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
SELECT r.name, COUNT(o.total) AS total_order
FROM sales_reps AS s
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN orders AS o
ON o.account_id = a.id
JOIN region AS r
ON r.id = s.region_id
GROUP BY 1
HAVING SUM(o.total_amt_usd) = 
		(SELECT MAX(total_amt)
    	FROM(SELECT r.name AS region_name,
            SUM(o.total_amt_usd) AS total_amt
         FROM sales_reps AS s
         JOIN accounts AS a
         ON a.sales_rep_id = s.id
         JOIN orders AS o
         ON o.account_id = a.id
         JOIN region AS r
         ON r.id = s.region_id
     	 GROUP BY 1) sub);
         
-- 3. How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?
SELECT COUNT(*)
FROM(SELECT	a.name
      FROM orders AS o
      JOIN accounts AS a
      ON a.id = o.account_id
      GROUP BY a.name
      HAVING SUM(o.total) > 
          (SELECT total_purchases
          FROM(SELECT a.name AS account_name, SUM(o.standard_qty) AS 		max_standard_paper, SUM(o.total) AS total_purchases
              FROM orders AS o
              JOIN accounts AS a
              ON a.id = o.account_id
              GROUP BY a.name
              ORDER BY 2 DESC
              LIMIT 1) sub)
     ) sub2	;
     
-- 4. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?
SELECT a.name, w.channel, COUNT(*)
FROM accounts AS a
JOIN web_events as w
ON w.account_id = a.id AND a.id = 
(SELECT id                                
FROM (SELECT a.id, a.name AS account_name, SUM(o.total_amt_usd) AS total_spent
      FROM orders AS o
      JOIN accounts AS a
      ON a.id = o.account_id
      GROUP BY 1,2
      ORDER BY 3 DESC
      LIMIT 1) sub )
GROUP BY 1,2;

-- 5. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
SELECT AVG(total_spent)
FROM(SELECT a.name AS account_name, SUM(total_amt_usd) AS total_spent
FROM orders AS o
      JOIN accounts AS a
      ON a.id = o.account_id
      GROUP BY 1
      ORDER BY 2 DESC
      LIMIT 10) sub;
 
-- 6. What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.
SELECT AVG(avg_spent) FROM(
SELECT account_id, AVG(total_amt_usd) AS avg_spent FROM orders
	GROUP BY 1
	HAVING AVG(total_amt_usd) >
		(SELECT AVG(total_amt_usd) AS avg_spent
		FROM orders)
        ) sub;
        
        
-- WITH Common Table Expressions (CTEs)
-- 1. Find the average number of events for each channel per day
WITH events AS (
          SELECT DAY(occurred_at) AS day, 
                        channel, COUNT(*) as events
          FROM web_events 
          GROUP BY 1,2)

SELECT channel, AVG(events) AS average_events
FROM events
GROUP BY channel
ORDER BY 2 DESC;

-- 2. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
WITH sub1 AS (
		SELECT s.name AS sales_rep, r.name AS region_name, SUM(o.total_amt_usd) AS total_amt
        FROM sales_reps AS s
        JOIN accounts AS a
        ON a.sales_rep_id = s.id
        JOIN orders AS o
        ON o.account_id = a.id
        JOIN region as r
        ON r.id = s.region_id
        GROUP BY 1,2
        ORDER BY 3 DESC ),
sub2 AS (
        SELECT region_name, MAX(total_amt) as total_amt
        FROM sub1
        GROUP BY 1)
SELECT sub1.sales_rep, sub1.region_name, sub1.total_amt
FROM sub1
JOIN sub2
ON sub1.region_name = sub2.region_name AND sub1.total_amt = sub2.total_amt;

-- 3. For the region with the largest sales total_amt_usd, how many total orders were placed?
WITH sub1 AS (
		SELECT r.name AS region_name, SUM(o.total_amt_usd) AS total_amt
        FROM sales_reps AS s
        JOIN accounts AS a
        ON a.sales_rep_id = s.id
        JOIN orders AS o
        ON o.account_id = a.id
        JOIN region as r
        ON r.id = s.region_id
        GROUP BY 1 ),
sub2 AS (
		SELECT MAX(total_amt)
		FROM sub1 )
SELECT r.name AS region_name, COUNT(o.total) AS total_order
FROM sales_reps AS s
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN orders AS o
ON o.account_id = a.id
JOIN region as r
ON r.id = s.region_id
GROUP BY 1
HAVING SUM(o.total_amt_usd) = (SELECT * FROM sub2);

-- 4. How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?
WITH sub1 AS (
      SELECT a.name AS account_name, SUM(o.standard_qty) AS max_standard_paper, SUM(o.total) AS total_purchases
      FROM orders AS o
      JOIN accounts AS a
      ON a.id = o.account_id
      GROUP BY a.name
      ORDER BY 2 DESC
      LIMIT 1 ),
sub2 AS (
SELECT a.name
      FROM orders AS o
      JOIN accounts AS a
      ON a.id = o.account_id
      GROUP BY a.name
      HAVING SUM(o.total) > (SELECT total_purchases FROM sub1))
SELECT COUNT(*)
FROM sub2;

-- 5. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?
WITH sub1 AS (
      SELECT a.id, a.name AS account_name, SUM(o.total_amt_usd) total_spent
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY a.id, a.name
      ORDER BY 3 DESC
      LIMIT 1)
SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (SELECT id FROM sub1)
GROUP BY 1, 2
ORDER BY 3 DESC;

-- 6. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
WITH sub1 AS (
      SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY a.id, a.name
      ORDER BY 3 DESC
      LIMIT 10)
SELECT AVG(total_spent) Avg_spent
FROM sub1;