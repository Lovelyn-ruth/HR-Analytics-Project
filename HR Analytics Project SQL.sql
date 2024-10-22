create database drsk;
use drsk;

select * from train;

-- 1 . total no. of records in the data
select count(*) from train;


-- 2 . total no. of distinct records in the data(no. of duplicates)
select distinct count(*) from train;

-- 3 . renaming column name
alter table train
rename column `Employee ID` to `Employee_ID`;

select * from train;
select Employee_ID from train;

-- 4 . what is the number of male and female present in the data
select gender, count(Employee_ID) as Gender_wise_count from train
group by gender;


-- 5 . Find the employee id who has received high number of promotions
select employee_id, sum(`Number of promotions`) as Total_Promotions from train
group by employee_id
order by Total_Promotions desc;


-- 6 . How many employees got the highest numbers of promotions?
select count(employee_id) as No_of_employees from 
(select employee_id, sum(`Number of promotions`) as Total_Promotions from train
                         group by employee_id
                         having Total_Promotions = 4
                         order by Total_Promotions desc) IQ ;
                         
  alter table train
 add column Salary_Package float;
 
 update train
 set Salary_Package = `Monthly Income`*12;
 
 alter table train
 rename column `job role` to Dept;
 
 alter table train
 rename column `years at company` to Work_Experience;

-- 7 . Find and display the information of top3 employees from each dept based on their Company Tenure
 
with ABC
as (select dept, employee_id, `company tenure`, 
row_number() over (partition by dept order by `company tenure` desc) as Ranks from train)
select * from ABC
where ranks <=3;
 
 with ABC
as (select dept, employee_id, `company tenure`, 
rank() over (partition by dept order by `company tenure` desc) as Ranks from train)
select dept,employee_id from ABC
where ranks <=3;

 
 -- 8 . If the company tenure is same for more than 1 person, then provide those particular people ranks according to the promotions
 
with ABC
as (select dept, employee_id, `company tenure`, `number of promotions`,age, salary_package,
rank() over (partition by dept order by `company tenure` desc, `number of promotions` desc,age desc, salary_package desc) as Ranks from train)
select * from ABC
where ranks <=3;

 
 -- 9 . Find number of employees working in each department
 SELECT dept, COUNT(employee_id) AS no_of_employees
FROM train
GROUP BY dept;

 -- 10 . Display employee_id,gender,dept,salary_package of employees whose salary package lies betweeen 50000 and 65000
 select employee_id,gender,dept,salary_package from train
 where salary_package between 50000 and 65000
 order by salary_package;
 

 -- 11 . Find the number of employees whose performance is average and above
 select count(*) as No_of_Employees
from train
where `performance rating` in ('average', 'high');


-- 12 . Find employee id in each department which has highest salary
with salary as(
select employee_id,dept, max(salary_package) as max_salary,
row_number() over(partition by dept order by max(salary_package) desc) as Ranks
from train
group by employee_id,dept
order by dept,max_salary desc)
select employee_id,dept, max_salary from salary
where Ranks=1;

-- 13 . Find employee id in each department which has second highest salary
with salary as(
select employee_id,dept, max(salary_package) as max_salary,
row_number() over(partition by dept order by max(salary_package) desc) as Ranks
from train
group by employee_id,dept
order by dept,max_salary desc)
select employee_id,dept, max_salary from salary
where Ranks=2;

-- 14 . Find second highest salary in each department using sub queries
select dept,max(salary_package) from train
where salary_package < (select max(salary_package) from train)
group by  dept;


 # comparing two classes on employees;
 # one class : work experience>=10
 # second class : work experience<10
 
--  15 . How many employees are there whose experience is greater than or equal to 10 years but they are getting lesser salaries
-- than the employees having experience of less than 10 years in each job role
 with ABC
 as (select A.Employee_ID as AE, A.Dept as AD, A.Work_Experience as AWE, A.Salary_Package as ASP, 
 B.Employee_ID as BE, B.Dept as BD, B.Work_Experience as BWE, B.Salary_Package as BSP from train A
 inner join train B 
 on  A.Work_Experience >=10 and B.Work_Experience <10 
 where A.Salary_Package<B.Salary_Package)
 select count(*) from ABC;
