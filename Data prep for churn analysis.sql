# First, a database is created to store the tables
CREATE DATABASE Churn;

/*Since directly importing data caused several issues
  we assign VARCHAR() to each column and then import*/
CREATE TABLE telecom
( Customer VARCHAR(255) NOT NULL PRIMARY KEY,
  Gender  VARCHAR(255) NULL,
  Age  VARCHAR(255) NULL,
  Married  VARCHAR(255) NULL,
  Number_of_Dependents  VARCHAR(255) NULL,
  City  VARCHAR(255) NULL ,
  Zip_Code  VARCHAR(255) NULL,
  Latitude  VARCHAR(255) NULL,
  Longitude  VARCHAR(255) NULL,
  Number_of_Referrals  VARCHAR(255) NULL,
  Tenure_in_Months  VARCHAR(255) NULL,
  Offer  VARCHAR(255) NULL,
  Phone_Service  VARCHAR(255) NULL,
  Avg_Monthly_Long_Distance_Charges  VARCHAR(255) NULL,
  Multiple_Lines  VARCHAR(255) NULL,
  Internet_Service  VARCHAR(255) NULL,
  Internet_Type  VARCHAR(255) NULL,
  Avg_Monthly_GB_Download  VARCHAR(255) NULL,
  Online_Security  VARCHAR(255) NULL,
  Online_Backup  VARCHAR(255) NULL,
  Device_Protection_Plan  VARCHAR(255) NULL,
  Premium_Tech_Support  VARCHAR(255) NULL,
  Streaming_TV  VARCHAR(255) NULL,
  Streaming_Movies  VARCHAR(255) NULL,
  Streaming_Music  VARCHAR(255) NULL,
  Unlimited_Data  VARCHAR(255) NULL,
  Contract  VARCHAR(255) NULL,
  Paperless_Billing  VARCHAR(255) NULL,
  Payment_Method  VARCHAR(255) NULL,
  Monthly_Charge  VARCHAR(255) NULL,
  Total_Charges	 VARCHAR(255) NULL,
  Total_Refunds	 VARCHAR(255) NULL,
  Total_Extra  VARCHAR(255) NULL,
  Data_Charges	 VARCHAR(255) NULL,
  Total_Long_Distance_Charges  VARCHAR(255) NULL,	
  Total_Revenue	 VARCHAR(255) NULL,
  Customer_Status  VARCHAR(255) NULL
  
);
#To check if we imported every record
SELECT COUNT(*) FROM telecom;

/*Creating another table that contains 
zip code and respective population*/
CREATE TABLE zip_pop
( Zip_Code INT,  
  Population INT) ;
  
/*Now we change columns back to their original data type*/  
ALTER TABLE telecom
MODIFY Number_of_Dependents INT,
MODIFY Zip_Code INT,
MODIFY Latitude DOUBLE,
MODIFY Longitude DOUBLE,
MODIFY Number_of_Referrals INT,
MODIFY Monthly_Charge DOUBLE,
MODIFY Total_Charges DOUBLE,
MODIFY Total_Refunds DOUBLE,
MODIFY Total_Revenue DOUBLE,
MODIFY Total_Extra DOUBLE,
MODIFY Total_Long_Distance_Charges DOUBLE,
MODIFY Tenure_in_Months INT;

/* Error 1265 was displayed while modifying these columns
MODIFY Avg_Monthly_Long_Distance_Charges DOUBLE,
MODIFY  Avg_Monthly_GB_Download DOUBLE,
the primary issue we
faced was the null values,so we replace the null
values with 0.00*/


UPDATE telecom
SET Avg_Monthly_Long_Distance_Charges=NULLIF(Avg_Monthly_Long_Distance_Charges,0.00);
ALTER TABLE telecom
MODIFY Avg_Monthly_Long_Distance_Charges DOUBLE;

UPDATE telecom
SET Avg_Monthly_GB_Download=NULLIF(Avg_Monthly_GB_Download,0.00);
ALTER TABLE telecom
MODIFY Avg_Monthly_GB_Download DOUBLE;

#Assigning primary key to zip_pop
ALTER TABLE zip_pop
ADD PRIMARY KEY(Zip_Code);

/*Only after assigning primary key,
we can use that primary key as a 
foreign key from another table*/
ALTER TABLE telecom
ADD FOREIGN KEY (Zip_code) REFERENCES zip_pop(Zip_Code)ON DELETE CASCADE;



/*Our data is finally prepared for analysis**/





