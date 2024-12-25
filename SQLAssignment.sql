use classicmodels;

SELECT * FROM classicmodels.employees;
##1a.
select employeeNumber,firstName,lastName from employees
where jobTitle="Sales Rep" and reportsTo=1102;

SELECT * FROM classicmodels.productlines;
##1b
select distinct productLine from productlines
where productLine like '%Cars';

SELECT * FROM classicmodels.customers;
##2a
select customerNumber,customerName, 
case 
when country IN ("USA","Canada") then 'North America'
when country IN ("UK","France","Germany") then 'Europe'
else 'Other'
end as CustomerSegment
from customers;

##3a
SELECT * FROM classicmodels.orderdetails;
select productCode,sum(quantityOrdered) as total_ordered from orderdetails
group by productCode
order by total_ordered desc
limit 10;

##3b
SELECT * FROM classicmodels.payments;
select monthname(paymentDate) as payment_month,count(checkNumber) as num_payments
from payments
group by payment_month
having num_payments>20
order by num_payments desc;

##4
create database Customers_Orders;
use Customers_Orders;
create table Customers(
  customer_id int primary key auto_increment,
  first_name varchar(50) NOT NULL,
  last_name varchar(50) NOT NULL,
  email varchar(255) UNIQUE,
  phone_number varchar(20) 
  );
create table Orders(
  order_id int primary key auto_increment,
  customer_id int,
  foreign key(customer_id) references Customers(customer_id),
  order_date date,
  total_amount decimal(10,2),
  check (total_amount>=0)
  );
  
  ##5
  select c.country,count(orderNumber) as order_count 
  from customers AS c
  join orders as o
  on c.customerNumber=o.customerNumber
  group by c.country
  order by order_count desc
  limit 5;
  
  ##6
  create table project(
    EmployeeID int primary key auto_increment,
    FullName varchar(50) NOT NULL,
    Gender enum("Male","Female"),
    ManagerID int
    );
insert into project(EmployeeID,FullName,Gender,ManagerID)
values 
   (1,"Pranaya","Male",3),
   (2,"Priyanka","Female",1),
   (3,"Preety","Female",null),
   (4,"Anurag","Male",1),
   (5,"Sambit","Male",1),
   (6,"Rajesh","Male",3),
   (7,"Hina","Female",3);
   
select * from project;

select q.FullName as ManagerName,p.FullName as EmpName
from project as p
join project as q
on p.ManagerID=q.EmployeeID;


##7
drop table if exists facility;
create table facility(
  Facility_ID int not null,
  Name varchar(100),
  State varchar(100) not null,
  Country varchar(100)
  );
  alter table facility 
  modify Facility_ID int primary key auto_increment;
  alter table facility
  add City varchar(100) not null after Name;
  desc facility;
 
 ##8
 create VIEW product_category_sales AS
 select p.productLine, 
 sum(quantityOrdered*priceEach) as total_sales,
 count(os.orderNumber) as number_of_orders 
 from productlines as p
 join products as ps
 on ps.productCode=p.productLine
 join orderdetails as o
 on o.productCode=ps.productCode
 join orders as os
 on os.orderNumber=o.orderNumber
group by p.productLine;
 
 ##9
call get_country_payments(2017,"USA",@amount);
select @amount as Total_amount;
 
 
 ##10
 select c.customerName,count(orderNumber) as Order_count,
 dense_rank() over( order by count(orderNumber) DESC)
 as order_frequency_rnk
 from customers as c
 join orders as o
 where c.customerNumber=o.customerNumber
 group by c.customerName;
 
 SELECT * FROM classicmodels.orders;
 with YOYchange as(
 select year(orderDate) as Year,monthname(orderDate) as Month,count(orderNumber) as Total_orders,
 LAG(count(orderNumber)) over (order by year(orderDate),month(orderDate)) as previous_total_orders
 from orders
 group by year(orderDate),monthname(orderDate),month(orderDate)
   order by year(orderDate),month(orderDate)
)
select Year,Month,Total_orders,round((Total_orders-previous_total_orders)/previous_total_orders*100,0) as "%YOY_Change"
from YOYchange;

##11

select productLine,count(productCode) as Total 
from products
where buyPrice>(select avg(buyPrice) from products)
group by productLine
order by count(productCode) desc;

##12
create table Emp_EH(
EmpID int Primary Key, EmpName varchar(100), EmailAddress varchar(100));

Drop procedure if exists EH;
create procedure 'EH'(IN @EmpID INT ,@EmpName varchar(100),@EmailAddress varchar(100))
AS
BEGIN

BEGIN TRY
INSERT INTO Emp_EH
select @EmpID,@EmpName, @EmailAddress
end try

begin CATCH

RaiseError("Error occurred")
end catch

Exec EH 
@EmpID=123,
@EmpName='Aishwarya',
EmailAddress='ash.18giri@gmail.com'
Go

end

##13
drop table if exists Emp_BIT ;
create table Emp_BIT(Name varchar(50),Occupation varchar(50),Working_date date,Working_hours int);
insert into Emp_BIT(Name,Occupation,Working_date,Working_hours)
values
('Robin', 'Scientist', 2020-10-04, 12),  
('Warner', 'Engineer', 2020-10-04, 10),  
('Peter', 'Actor', 2020-10-04, 13),  
('Marco', 'Doctor', 2020-10-04, 14),  
('Brayden', 'Teacher', 2020-10-04, 12),  
('Antonio', 'Business', 2020-10-04, 11);  



 
 


