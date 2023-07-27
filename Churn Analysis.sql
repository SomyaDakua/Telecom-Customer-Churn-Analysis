/**Churn Rate Calculation**/
/*To count the number of total employees who have churned
and assigning the value to a session variable
for future use*/
SELECT COUNT(*) FROM 
(SELECT Customer FROM telecom 
WHERE Customer_Status='Churned')e;

SET @Churned_cust =1869;

/*Counting total number of customers 
and assigning it to a session variable*/
SELECT COUNT(Customer) FROM telecom;
Set @Total_cust=7042;

#Churn rate calculation for a 6 year period
SELECT CONCAT(ROUND(1.00*(SELECT @Churned_cust)/(SELECT @Total_cust)*100,2),'%') AS Churn_Rate;

#Total Number of people who churned in the first 3 years in percent
SELECT
(SELECT COUNT(Customer) 
FROM telecom
WHERE ROUND(Tenure_in_Months/12) BETWEEN 0 AND 3 
AND Customer_Status='Churned')/
(SELECT COUNT(Customer)
FROM telecom
WHERE ROUND(Tenure_in_Months/12) BETWEEN 0 AND 3)*100.00 AS Churn_percent_for_first_3_yrs; 

#Total Number of people who churned in the last 3 years in percent
SELECT
(SELECT COUNT(Customer) 
FROM telecom
WHERE ROUND(Tenure_in_Months/12) BETWEEN 4 AND 6 
AND Customer_Status='Churned')/
(SELECT COUNT(Customer)
FROM telecom
WHERE ROUND(Tenure_in_Months/12) BETWEEN 4 AND 6)*100.00 AS Churn_percent_for_last_3_yrs;

#Total number of people who churned in the last 3 years
SELECT COUNT(Customer) 
FROM telecom
WHERE ROUND(Tenure_in_Months/12) BETWEEN 4 AND 6 
AND Customer_Status='Churned'; 

/*This peice of code retrieves data on the total number of customers joined
in 6 yrs,total number of customers joined in first 3 yrs and total customers 
joined in the last 3 yrs*/
SELECT 
(SELECT COUNT(Customer) FROM telecom WHERE Customer_Status='Joined') AS Total_joined_Cust,
(SELECT COUNT(Customer) FROM telecom WHERE ROUND(Tenure_in_Months/12) BETWEEN 0 AND 3
AND Customer_Status='Joined')AS Cust_Joined_in_First_3yrs,
(SELECT COUNT(Customer) FROM telecom WHERE ROUND(Tenure_in_Months/12) BETWEEN 4 AND 6
AND Customer_Status='Joined')AS Cust_Joined_in_Last_3yrs;

/**Demographic Analysis**/
#Data on total number of males who churned
SELECT COUNT(Customer)
AS Total_male_churned
FROM telecom
WHERE Customer_Status='Churned' AND Gender='Male';
SET @Male_Churned=930;

#Data on number of females who churned
SELECT COUNT(Customer)
AS Total_male_churned
FROM telecom
WHERE Customer_Status='Churned' AND Gender='Female';
SET @Female_Churned=939;

SELECT COUNT(Customer) FROM telecom
WHERE Customer_Status='Churned';
SET @Churned_cust=1869;

#Breakdown on male vs female churn rate
SELECT 
((SELECT @Male_Churned)/(SELECT @Churned_cust) *100.00) As Male_Churn,
((SELECT @Female_Churned)/(SELECT @Churned_cust) *100.00) As Female_Churn;

SELECT Customer,AGE,ROW_NUMBER() OVER(ORDER BY AGE dESC) FROM telecom
WHERE Customer_Status='Churned';

/*Breakdown of churned customers based upon age group*/
SELECT
(SELECT COUNT(Customer) 
FROM telecom
WHERE AGE < 20 AND AGE <40 AND Customer_Status = 'Churned')AS "<20",
(SELECT COUNT(Customer) 
FROM telecom
WHERE AGE >= 20 AND AGE <40 AND Customer_Status = 'Churned')AS "20-40",
(SELECT COUNT(Customer)  
FROM telecom
WHERE AGE >= 40 AND AGE<60 AND Customer_Status = 'Churned')AS"40-60",
(SELECT COUNT(Customer) 
FROM telecom
WHERE AGE>= 60 AND AGE <=80 AND Customer_Status = 'Churned')AS "60-80"
FROM telecom
LIMIT 1;


/**Geographical Analysis**/
/*This data is to be imported to
Tableau server to create a world map*/
SELECT Customer,City,Zip_Code,Latitude,Longitude
FROM telecom
WHERE Customer_Status='Churned';

/**Tenure Analysis**/
SELECT COUNT(Customer) AS Churned_Customers,
ROUND(Tenure_in_Months/12) AS Tenure_in_Years
FROM telecom
WHERE Customer_Status='Churned'
GROUP BY Tenure_in_Years
ORDER BY Tenure_in_Years DESC ;

#TO get an idea for the remaining analysis to be done
SELECT Offer,Phone_Service,Internet_Service,Internet_Type,Premium_Tech_Support,Paperless_Billing,Payment_Method,Total_Charges,Total_Revenue,ROUND(Tenure_in_Months/12)
FROM telecom
WHERE Customer_Status='Churned'
ORDER BY ROUND(Tenure_in_Months/12) DESC;



/*Created another column in the telecom
table to calculate average price paid per customer*/
ALTER TABLE telecom
ADD COLUMN avg_price_paid DOUBLE NULL;

UPDATE telecom
SET avg_price_paid = Total_charges / (Tenure_in_months / 12);
Commit;

/**Paperless Billing Analysis**/
SELECT 
(SELECT COUNT(Customer) FROM telecom
WHERE Customer_Status='Churned' AND Paperless_Billing='Yes') AS Churned_Cust_using_pb,
(SELECT COUNT(Customer) FROM telecom
WHERE Customer_Status='Churned' AND Paperless_Billing='No') AS Churned_Cust_not_using_pb,
 @Churned_cust AS Total_churned_cust; 
 
 /**Total Charges Analysis**/
/**Mean for churned vs stayed customer**/
SELECT
(SELECT AVG(avg_price_paid) FROM telecom
WHERE Customer_Status='Stayed') AS Stayed_price,
(SELECT AVG(avg_price_paid) FROM telecom
WHERE Customer_Status='Churned')AS Churned_price;

/**Median for Churned vs stayed customer**/
SELECT Customer,avg_price_paid
FROM (
    SELECT Customer, avg_price_paid, ROW_NUMBER() OVER (ORDER BY avg_price_paid) AS w
    FROM telecom
    WHERE Customer_Status = 'Churned'
) AS subquery
WHERE w = 935;


SELECT Customer, avg_price_paid
FROM (
    SELECT Customer, avg_price_paid, ROW_NUMBER() OVER (ORDER BY avg_price_paid) AS w
    FROM telecom
    WHERE Customer_Status = 'Stayed'
) AS subquery
WHERE w=2360;

/***This Ends our analysis,Next we proceed to Visualize the data using Tableau***/















