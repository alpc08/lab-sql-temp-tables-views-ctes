#Creating a Customer Summary Report
#In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history and payment details. 
#The report will be generated using a combination of views, CTEs, and temporary tables.

#Step 1: Create a View
#First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
CREATE VIEW rental_count AS (SELECT c.customer_id, CONCAT(c.first_name, " ", c.last_name) AS name, c.email, COUNT(r.rental_id) AS total_rental
							FROM customer c
							JOIN rental r
							ON c.customer_id= r.customer_id
							GROUP BY r.customer_id)
                            ORDER BY total_rental DESC;
SELECT * FROM rental_count;
#Step 2: Create a Temporary Table
#Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
#The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE total_paid ( SELECT rc.customer_id, rc.name,  SUM(p.amount) AS total
									FROM rental_count rc
									JOIN payment p
									ON rc.customer_id = p.customer_id
									GROUP BY rc.customer_id);                                    
#Step 3: Create a CTE and the Customer Summary Report
#Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
#The CTE should include the customer's name, email address, rental count, and total amount paid.
#Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, 
# this last column is a derived column from total_paid and rental_count.
WITH Customer_Summary_Report AS (SELECT rc.name, rc.email, rc.total_rental, tp.total
															FROM rental_count rc
															JOIN total_paid tp
															ON rc.customer_id = tp.customer_id)

SELECT *,(total/total_rental) AS payment_per_rental
FROM Customer_Summary_Report;