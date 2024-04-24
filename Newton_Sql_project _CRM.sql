CREATE DATABASE SQLPROJECT;
USE SQLPROJECT;
CREATE TABLE GENDER(GenderID INT ,GenderCategory VARCHAR(50));
SELECT * FROM GENDER;
SELECT * FROM BANK_CHURN;
SELECT * FROM customerinfo;
-- select ï»¿CustomerId as CustomerID
--  from customerinfo
--  where Bank DOJ between '2019-10-01' AND '2019-12-31'
--  order by EstimatedSalary desc
--  limit 5;

select * from creditcard;
select * from geography ;
select * from activecustomer;
select * from exitcustomer;
-- ----------------------------------//////////////////////////////////////////------------------------------------------------------------------------
                                                -- 2
-- 2. Identify the top 5 customers with the highest Estimated Salary in the last
-- quarter of the year. (SQL)

-- REFERING TO CUSTOMERINFO (SECOND TAB)


-- -----------------------------------------------////////////////////////////////////////////////----------------------------------------------------------
                                 -- 3
-- Calculate the average number of products used by customers who have a credit
-- card. (SQL)

select round(avg(NumOfProducts),0) as average_used_products 
from bank_churn 
where HasCrCard =1;


 



-- -----------------------------------------------------------------------------------------------------
                                         -- 5

-- 5-- Compare the average credit score of customers who have exited and those who
-- remain. (SQL)
select e.ExitCategory,round(avg(b.CreditScore),0) as avg_credit_score
from bank_churn b
join exitcustomer e
on b.Exited=e.ï»¿ExitID
group by e.ExitCategory;


-- QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ------------------------------------------QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
                                                          -- 6
-- Which gender has a higher average estimated salary, and 
-- how does it relate to the number of active accounts? (SQL)                                               ppppppppppppppppppppppppppp

select g.GenderCategory,round(avg(c.EstimatedSalary),0) as avg_estimated_sal
from customerinfo c
join gender g
on c.GenderID=g.GenderID
group by 1
order by 2 desc 
;
-- AS WE GET TO KNOW FRMALE HAS THE HIGHEST SALARY THEN MALE SO IN NEXT QUERY I HAVE JUST CALCULATED IT 
select  b.IsActiveMember ,round(avg(c.EstimatedSalary),0) as avg_estimated_sal
from customerinfo c
join bank_churn b
on  c.ï»¿CustomerId=b.ï»¿CustomerId
where c.GenderID=2
group by 1
order by 2 desc 
;






-- QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ------------------------------------------QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ

-- 7. Segment the customers based on their credit score and identify the segment
-- with the highest exit rate. (SQL)

with seg as 
(
select count(ï»¿CustomerId) as Total_Customers ,
case 
   when CreditScore between '300' and '580' then '300-580'
   when CreditScore between '580' and '669' then '580-669'
   when CreditScore between '669' and '758' then '669-758'
   when CreditScore between '758' and '847' then '758-847'
  else  '847-936'
  end as segment ,
case 
   when CreditScore between '300' and '580' then 'Poor'
   when CreditScore between '580' and '669' then 'Fair'
   when CreditScore between '669' and '758' then 'Good'
   when CreditScore between '758' and '847' then 'Very Good'
  else  'Exceptional'
  end as segment_category 
  
  from bank_churn 
  group by 2,3

  )
  ,
 churnrt as 
  (
  select count(ï»¿CustomerId) as Churn_Customers ,
case 
   when CreditScore between '300' and '580' then '300-580'
   when CreditScore between '580' and '669' then '580-669'
   when CreditScore between '669' and '758' then '669-758'
   when CreditScore between '758' and '847' then '758-847'
  else  '847-936'
  end as segment ,
case 
   when CreditScore between '300' and '580' then 'Poor'
   when CreditScore between '580' and '669' then 'Fair'
   when CreditScore between '669' and '758' then 'Good'
   when CreditScore between '758' and '847' then 'Very Good'
  else  'Exceptional'
  end as segment_category 
  from bank_churn 
  where Exited=1
  group by 2,3

  )
select s.Total_Customers, s.segment , s.segment_category ,c.Churn_Customers ,round(((c.Churn_Customers/s.Total_Customers) *100),2) as churn_rate 
 from seg s
 join churnrt c 
 on s.segment = c.segment 
 order by churn_rate desc;
 
 
--  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
 -- QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ------------------------------------------QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
 
                                                                        -- --8 
-- 8. Find out which geographic region has the highest number of active customers
-- with a tenure greater than 5 years. (SQL)	

select count(b.ï»¿CustomerId) , g.GeographyLocation
from bank_churn  b 
join customerinfo  c 
on  b.ï»¿CustomerId=c.ï»¿CustomerId 
join geography g 
on c.GeographyID=g.ï»¿GeographyID
where b.IsActiveMember =1 and b.Tenure>5
group  by 2 
order by 1 desc 
limit 1 ;						





--  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
 -- QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ------------------------------------------QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
 								                        -- 11
 
--  11. Examine the trend of customers joining over time and identify any seasonal
-- patterns (yearly or monthly). Prepare the data through SQL and then visualize
ALTER TABLE customerinfo RENAME COLUMN BankDOJ TO Bankjd;

select count(ï»¿CustomerId) as total_customers,                                                                                 --   (THIS QUESTION I HAVE DONE IN CUSTOMERINFO TAB BEACAUSE OF THE BANK DOJ ISSUE )
case 
   when year(Bank DOJ) = '2019' then '2019'
   when year(Bank DOJ) = '2018' then '2018'
   when year(Bank DOJ) = '2017' then '2017'
   else '2016'
   end as yearwise 
   from customerinfo
   group by 2 ;

select Bank DOJ from  customerinfo;





--  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
 -- QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ------------------------------------------QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
 								                        -- 15
--   15. Using SQL, write a query to find out the gender-wise average income of males and
-- females in each geography id. Also, rank the gender according to the average value.
-- (SQL)                                                      
SELECT round(avg(c.EstimatedSalary),0) as avg_income ,  g.GeographyLocation , d.GenderCategory , rank() over( order by round(avg(c.EstimatedSalary),0) ) as ranking
from customerinfo c
join geography g 
on c.GeographyID=g.ï»¿GeographyID
join gender d 
on c.GenderID=d.GenderID
   group by  2,3
   order by 2 ;                                                 


--  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
 -- QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ------------------------------------------QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
 								                        -- 16

-- 16. Using SQL, write a query to find out the average tenure of the people who have exited
-- in each age bracket (18-30, 30-50, 50+).

select case 
          when  Age between '18' and '30' then '18-30'
          when  Age between '30' and '50' then '30-50'                                                                                          --  ALSO SUBJECTIVE 9 (ON THE BASIS OF AGE CATEGORY)
          else '50+'
          end as age_segment ,
          round(avg(Age),0) as average_age 
from customerinfo 
group by 1 ;


--  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
 -- QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ------------------------------------------QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
 								                        -- 23
--   23. Without using “Join”, can we get the “ExitCategory” from ExitCustomers table to
-- Bank_Churn table? If yes do this using SQL. 

SELECT bc.*,
       (SELECT ExitCategory FROM exitcustomer e WHERE e.ï»¿ExitID = bc.Exited) AS ExitCategory                                                          --  ALSO SUBJECTIVE 9 (ON THE BASIS OF EXIT CATEGORY)
FROM Bank_Churn bc;


--  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
 -- QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ------------------------------------------QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
                                                          -- 25
-- 25. Write the query to get the customer IDs, their last name, and whether they are active or not for
-- the customers whose surname ends with “on”.
   
   select c.ï»¿CustomerId , c.Surname ,b.IsActiveMember 
   from customerinfo c                                                                                                                                  --  ALSO SUBJECTIVE 9 (ON THE BASIS OF ACTIVE/NON ACTIVE )
   join bank_churn b 
   on c.ï»¿CustomerId=b.ï»¿CustomerId 
   where c.Surname like '%on';
   
   
                                                        SUBJECTIVE
   
   -- ---------------------------------////////////////////////---------------------/////////////////------------------------------
                                                 -- SUBJECTIVE 9

-- 9. Utilize SQL queries to segment customers based on demographics and
-- account details.