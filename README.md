# SQL-Analysis-of-Parch & Posey

## Introduction
I queried the Parch and Posey paper company database using MySQL and PostgreSQL. Parch and Posey is an online paper company that sells different paper types (Standard, Poster, and Gloss). It is worth noting that this dataset does not represent a particular company. It was developed for learning purposes. 

The database consists of over 15000 rows and 5 different tables namely:
- Orders
- Accounts
- Web_events
- Sales_reps
- Region

Below is the Schema of the database
![](Parch&Posey_Schema.png)

## Creating Database

I created the database in MySQL workbench for the analysis. The query for creating the database can be copied from [Parch&Posey_database](https://github.com/Ratafar22/SQL-Analysis-of-Parch-and-Posey/blob/main/Parch%26Posey-database.sql) and you can load it into any server of your choice.

*Note: you might need to tweak the syntax to suit the database you are using.*

## Skills and Concepts Demonstrated

1. **Basic SQL**

These includes using syntax such as SELECT, FROM, WHERE, ORDERBY, IN, BETWEEN, LIKE, AND, & LIMIT

*Some examples are shown below*

 ``` sql
-- select only the id, account_id, and occurred_at columns for all orders in the orders table. show the first 10 rows

SELECT id, account_id, occurred_at 
FROM orders
LIMIT 10;
```

```sql
-- Use the web_events table to find all information regarding individuals who were contacted via the organic or adwords channels, 
and started their account at any point in 2016, sorted from newest to oldest.

SELECT *
FROM web_events
WHERE channel IN('organic', 'adwords') 
AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;
```
I also demonstrated how to write SQL queries in a Python environment. This is useful when you want to display the output of each query in the next cell. 
To do this, I made use of a Jupyter Notebook to write my SQL queries. The steps needed to follow are shown below

- **install ipython-sql libaray using the syntax**
  
    *pip install ipython-sql*

- **Load External SQL Module**

    *%load_ext sql*
  
- **Now Connect to the Database**
 
    *%sql mysql+pymysql://username:password@localhost/database_name* 		**for mysql**

    *sqlite:///yourdatabase.sqlite* 			**for Sqlite**

    *postgres://name:password@localhost:6259/database_name* 		or
  
    *postgres://localhost:6259/database_name* 		**for postgre**

After successfully connecting to the database, one can now start writing SQL queries in the Python environment but note that one needs to start each query with **%sql** or **%%sql** as demonstrated below
``` sql
-- select all columns from the orders table

%%sql
    SELECT * 
    FROM orders;
```
For more examples on how the queries and output look like in Python, check out my queries [Basic_SQL](https://github.com/Ratafar22/SQL-Analysis-of-Parch-and-Posey/blob/main/Basic_SQL_Parch_Posey.ipynb) . *Note: The file size is big and might take some time to load*


2. **Aggregates funtions** : These functions are used to perform operations on a set of values to return a single value. They can be used to summarise data. They include SUM, COUNT, MIN, MAX, AVG, GROUP BY, HAVING etc

*Examples:*
```sql
--Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.

SELECT	AVG(standard_amt_usd) Avg_standard_amt,
	AVG(gloss_amt_usd) Avg_gloss_amt,
       	AVG(poster_amt_usd) Avg_poster_amt,
        AVG(standard_qty) Avg_standard_qty,
	AVG(gloss_qty) Avg_gloss_qty,
       	AVG(poster_qty) Avg_poster_qty
FROM orders;
```

```sql
--  Find the total sales in usd for each account.

SELECT a.name, SUM(o.total_amt_usd) total_sales_usd
FROM accounts a
JOIN orders o 
ON o.account_id = a.id
GROUP BY a.name;
```
Find more examples of queries in which I used other Aggregation functions here [SQl_Aggregations](https://github.com/Ratafar22/SQL-Analysis-of-Parch-and-Posey/blob/main/Aggregations.sql)


3. **JOINS:** There are cases whereby one needs to join two or more tables together to be able to generate more insights from the datasets, this is where the use of the Join comes in. There are several types of Joins such as Inner Join, Outer Join, Left join, and Right join. You can learn more about the use of these joins [here](https://www.w3schools.com/mysql/mysql_join.asp)

*Samples of Join queries:*
```sql
-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first

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
```
Other JOIN queries can be found [here](https://github.com/Ratafar22/SQL-Analysis-of-Parch-and-Posey/blob/main/JOINS.sql)


5. **Subqueries and Temporary Tables:** Both subqueries and table expressions are methods used to write a query that creates a table, and then write another query that interacts with this newly created table. To create a CTE, we use the *WITH* syntax

*Examples of Subquery and CTEs are demonstrated below:*
```sql
--  Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

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
```

```sql
-- Find the average number of events for each channel per day
WITH events AS (
          SELECT DAY(occurred_at) AS day, 
                        channel, COUNT(*) as events
          FROM web_events 
          GROUP BY 1,2)

SELECT channel, AVG(events) AS average_events
FROM events
GROUP BY channel
ORDER BY 2 DESC;
```
Go to [Subqueries&CTEs](https://github.com/Ratafar22/SQL-Analysis-of-Parch-and-Posey/blob/main/Subqueries_%26_Temporary_Tables.sql) to find more of my queries on Subqueries and CTEs


6. **Windows Functions:** It allows one to do a comparison between rows without doing any join. It can be used to calculate the running total of a column. It uses syntax such as *OVER*, *PARTITION* and *ORDER BY*, *RANK*, *ROW NUMBER*, *LOD* and *LAG*. Examples of how Window functions work are shown below

```sql
-- Create a running total of standard_amt_usd (in the orders table) over order time with no date truncation.
SELECT standard_amt_usd,
	SUM(standard_amt_usd) OVER(ORDER BY occurred_at) AS running_total
FROM orders;
```

```sql
-- Select the id, account_id, and total variable from the orders table, then create a column called total_rank that ranks this total amount of paper ordered (from highest to lowest) for each account using a partition. Your final table should have these four columns.
SELECT 	id,
	account_id,
        total,
        RANK() OVER(PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders;
```
Check out other sample window functions queries [here](https://github.com/Ratafar22/SQL-Analysis-of-Parch-and-Posey/blob/main/Window_Functions.sql)

