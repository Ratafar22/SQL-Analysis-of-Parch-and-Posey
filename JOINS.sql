-- QUESTIONS
-- 1. Pull all the data from the accounts table, and all the data from the orders table
SELECT orders.*, accounts.*
FROM orders
JOIN accounts
ON accounts.id = orders.account_id;

-- 2. Pull standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.
SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.website, accounts.primary_poc
FROM orders
JOIN accounts
ON accounts.id = orders.account_id;

-- 3. Provide a table for all web_events associated with account name of Walmart. There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.
SELECT w.occurred_at, w.channel, a.primary_poc, a.name
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
WHERE a.name = 'Walmart';

-- 4. Provide a table that provides the region for each sales_rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT  s.name rep_name, a.name account_name, r.name region
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN region r
ON r.id = s.region_id
ORDER BY a.name ASC; 

-- 5. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: region name, account name, and unit price.
SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) AS unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id =a.id ;

-- 6. Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region, s.name sales_rep_name, a.name account_name
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
AND r.name = 'Midwest'
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name ASC;

-- 7. Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region, s.name sales_rep_name, a.name account_name
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
AND r.name = 'Midwest' 
AND s.name LIKE 'S%'
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name ASC;

-- 8. Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region, s.name sales_rep_name, a.name account_name
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
AND r.name = 'Midwest' 
AND s.name LIKE '% K%'
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name ASC;

-- 9. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100. Your final table should have 3 columns: region name, account name, and unit price. 
SELECT r.name region, a.name account_name, total_amt_usd/(total+0.01) AS unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id =s.id 
JOIN orders o
ON o.account_id = a.id
AND standard_qty > 100;

-- 10. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first
SELECT r.name region, a.name account_name, total_amt_usd/(total+0.01) AS unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id =s.id 
JOIN orders o
ON o.account_id = a.id
AND standard_qty > 100
AND poster_qty > 50
ORDER BY unit_price ASC;

-- 11. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the largest unit price first
SELECT r.name region, a.name account_name, total_amt_usd/(total+0.01) AS unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id =s.id 
JOIN orders o
ON o.account_id = a.id
AND standard_qty > 100
AND poster_qty > 50
ORDER BY unit_price DESC;

-- 12. What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels. You can try SELECT DISTINCT to narrow down the results to only the unique values.
SELECT DISTINCT a.name, w.channel
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
AND account_id = 1001;

-- 13. Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.
SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
AND o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01'
ORDER BY o.occurred_at DESC;