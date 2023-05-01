-- Leonardo Olmos Saucedo / Lab SQL basics

USE bank;

-- 1. Get the id values of the first 5 clients from district_id with a value equals to 1.
SELECT c.client_id AS client_id
FROM `client`c
WHERE c.district_id = 1
ORDER BY 1
LIMIT 5;

-- 2. In the client table, get an id value of the last client where the district_id equals to 72.
SELECT c.client_id AS client_id
FROM `client` c
WHERE c.district_id = 72
ORDER BY 1 DESC
LIMIT 1;

-- 3. Get the 3 lowest amounts in the loan table.
SELECT l.amount AS amount
FROM loan l 
ORDER BY l.amount
LIMIT 3;

-- 4. What are the possible values for status, ordered alphabetically in ascending order in the loan table?
SELECT DISTINCT(l.status) AS `status`
FROM loan l
ORDER BY 1;

-- 5. What is the loan_id of the highest payment received in the loan table?
SELECT l.loan_id AS loan_id
FROM loan l
ORDER BY l.payments DESC
LIMIT 1;

SELECT l.loan_id AS loan_id, l.payments
FROM loan l
ORDER BY l.payments DESC
LIMIT 10;

SELECT * 
FROM loan
WHERE loan_id = 6312;

-- 6. What is the loan amount of the lowest 5 account_ids in the loan table? Show the account_id and the corresponding amount
SELECT l.account_id AS account_id, l.amount AS amount
FROM loan l 
ORDER BY l.account_id
LIMIT 5;

-- 7. What are the account_ids with the lowest loan amount that have a loan duration of 60 in the loan table?
SELECT l.account_id
FROM loan l 
WHERE l.duration = 60
ORDER BY l.amount
LIMIT 5;

-- 8. What are the unique values of k_symbol in the order table?
SELECT DISTINCT(o.k_symbol)
FROM `order` o;

-- 9. In the order table, what are the order_ids of the client with the account_id 34?
SELECT o.order_id 
FROM `order` o 
WHERE o.account_id = 34;

-- 10. In the order table, which account_ids were responsible for orders between order_id 29540 and order_id 29560 (inclusive)?
SELECT DISTINCT(o.account_id)
FROM `order` o 
WHERE o.order_id BETWEEN 29540 AND 29560;

-- 11. In the order table, what are the individual amounts that were sent to (account_to) id 30067122?
SELECT o.amount
FROM `order` o
WHERE o.account_to = 30067122;

-- 12. In the trans table, show the trans_id, date, type and amount of the 10 first transactions from account_id 793 in chronological order, from newest to oldest.
SELECT t.trans_id, t.date, t.type, t.amount
FROM trans t
WHERE t.account_id = 793
ORDER BY 2 DESC, 1 DESC
LIMIT 10;

/* 13. In the client table, of all districts with a district_id lower than 10, how many clients are from each district_id? 
Show the results sorted by the district_id in ascending order. */
SELECT c.district_id, COUNT(c.client_id) AS total_clients
FROM `client` c
WHERE c.district_id < 10
GROUP BY c.district_id
ORDER BY 1;

-- 14. In the card table, how many cards exist for each type? Rank the result starting with the most frequent type.
SELECT c.type, COUNT(*) AS total_by_type
FROM card c
GROUP BY c.type
ORDER BY 2 DESC;

-- 15. Using the loan table, print the top 10 account_ids based on the sum of all of their loan amounts.
SELECT l.account_id, SUM(l.amount) AS total_loan
FROM loan l
GROUP BY l.account_id
ORDER BY SUM(l.amount) DESC
LIMIT 10;

-- 16. In the loan table, retrieve the number of loans issued for each day, before (excl) 930907, ordered by date in descending order.
SELECT l.date, COUNT(l.loan_id)
FROM loan l
WHERE l.date < '930907'
GROUP BY l.date
ORDER BY 1 DESC;

/* 17. In the loan table, for each day in December 1997, count the number of loans issued for each unique loan duration, ordered by date and duration, both in ascending order. 
You can ignore days without any loans in your output. */
SELECT l.date, l.duration, COUNT(*)
FROM loan l
WHERE l.date BETWEEN '971201' AND '971231'
GROUP BY l.duration, l.date
ORDER BY 1, 2;

/* 18. In the trans table, for account_id 396, sum the amount of transactions for each type (VYDAJ = Outgoing, PRIJEM = Incoming). 
Your output should have the account_id, the type and the sum of amount, named as total_amount. 
Sort alphabetically by type.
*/
SELECT t.account_id, t.type, SUM(t.amount) AS total_amount
FROM trans t
WHERE t.account_id = 396
GROUP BY t.account_id, t.type
ORDER BY 2;

-- 19. From the previous output, translate the values for type to English, rename the column to transaction_type, round total_amount down to an integer
SELECT t.account_id, CASE 
	WHEN t.type = 'VYDAJ' THEN 'OUTGOING'
    ELSE 'INCOMING'
END AS transaction_type, FLOOR(SUM(t.amount)) AS total_amount
FROM trans t
WHERE t.account_id = 396
GROUP BY t.account_id, t.type
ORDER BY 2;

-- 20. From the previous result, modify your query so that it returns only one row, with a column for incoming amount, outgoing amount and the difference.
SELECT S1.*, (S1.INCOMING - S1.OUTGOING) AS difference 
FROM (
SELECT t.account_id, 
	FLOOR(SUM(CASE WHEN t.type = 'PRIJEM' THEN t.amount END)) AS 'INCOMING',
	FLOOR(SUM(CASE WHEN t.type = 'VYDAJ' THEN t.amount END)) AS 'OUTGOING'
FROM trans t
WHERE t.account_id = 396) AS S1;

-- 21. Continuing with the previous example, rank the top 10 account_ids based on their difference.
SELECT S1.account_id, (S1.INCOMING - S1.OUTGOING) AS difference 
FROM (
SELECT t.account_id, 
	FLOOR(SUM(CASE WHEN t.type = 'PRIJEM' THEN t.amount END)) AS 'INCOMING',
	FLOOR(SUM(CASE WHEN t.type = 'VYDAJ' THEN t.amount END)) AS 'OUTGOING'
FROM trans t
GROUP BY t.account_id) AS S1
ORDER BY 2 DESC
LIMIT 10;

