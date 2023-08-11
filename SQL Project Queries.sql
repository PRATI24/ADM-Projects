--1

select soh.SalesOrderNumber, p.Name, psc.Name, pc.Name, sod.UnitPrice, sod.UnitPriceDiscount, sod.LineTotal
FROM [Sales].[SalesOrderHeader] soh 
inner join [Sales].[SalesOrderDetail] sod
on soh.SalesOrderID = sod.SalesOrderID
inner join [Production].[Product] p 
on p.ProductID = sod.ProductID
inner join [Production].[ProductSubcategory] psc
on p.ProductSubcategoryID = psc.ProductSubcategoryID
inner join [Production].[ProductCategory] pc
on pc.ProductCategoryID = psc.ProductCategoryID
order by p.Name

--1B

select p.ProductID, p.Name, psc.ProductSubcategoryID, psc.Name, pc.ProductCategoryID, pc.Name
from [Production].[Product] p 
left join [Production].[ProductSubcategory] psc
on p.ProductSubcategoryID = psc.ProductSubcategoryID
left join [Production].[ProductCategory] pc
on psc.ProductCategoryID = pc.ProductCategoryID
order by p.Name

--2


select pc.Name, soh.OrderDate, sum(soh.SubTotal)
from [Sales].[SalesOrderHeader] soh
join [Sales].[SalesOrderDetail] sod
on sod.SalesOrderID = soh.SalesOrderID
join [Production].[Product] p
on p.ProductID = sod.ProductID
join [Production].[ProductSubcategory] psc
on p.ProductSubcategoryID = psc.ProductSubcategoryID
join [Production].[ProductCategory] pc
on pc.ProductCategoryID = psc.ProductCategoryID
where month(soh.OrderDate) = 12 and year(soh.OrderDate) = 2003
group by pc.Name, soh.OrderDate
order by soh.OrderDate


--3

select soh.SalesOrderID, sr.Name, sr.ReasonType, soh.ShipDate, soh.SubTotal, soh.TaxAmt, soh.Freight, soh.TotalDue
from [Sales].[SalesOrderHeader] soh
join [Sales].[SalesOrderHeaderSalesReason] sohsr
on soh.SalesOrderID = sohsr.SalesOrderID
join [Sales].[SalesReason] sr
on sohsr.SalesReasonID = sr.SalesReasonID
where sr.Name <> 'Quality' and sr.Name <> 'Manufacturer'


--4

select distinct(p.Name)
from [Sales].[SpecialOffer] so 
join [Sales].[SpecialOfferProduct] sop
on so.SpecialOfferID = sop.SpecialOfferID
join [Production].[Product] p 
on p.ProductID = sop.ProductID
where so.DiscountPct <=0.45 and p.Name not like 'R%'
order by p.Name desc


-----5
Select distinct(p.Name)
from [Production].[Product] p 
where p.Name like'%[-,/%0-9]%'

-----6
select top 1 sp.Name,(str1.TaxRate), str1.Name
from [Sales].[SalesTaxRate] str1
join [Person].[StateProvince] sp
on str1.StateProvinceID = sp.StateProvinceID
order by str1.TaxRate desc

-----7

select st.Name, pc.Name, sum(sod.LineTotal) as revenue
from [Production].[ProductCategory] pc
inner join [Production].[ProductSubcategory] psc
on pc.ProductCategoryID = psc.ProductCategoryID
inner join [Production].[Product] p
on p.ProductSubcategoryID = psc.ProductSubcategoryID
inner join [Sales].[SalesOrderDetail] sod
on sod.ProductID = p.ProductID
inner join [Sales].[SalesOrderHeader] so
on so.SalesOrderID = sod.SalesOrderID
inner join [Sales].[SalesTerritory] st
on st.TerritoryID = so.TerritoryID
group by st.Name, pc.Name
order by 1

--8

SELECT 
   CASE 
       WHEN DATEDIFF(YEAR, HireDate, getdate()) < 15 THEN 'LESS than 15'
       WHEN DATEDIFF(YEAR, HireDate, getdate()) BETWEEN 15 AND 18 THEN 'BETWEEN 15 AND 18'
       WHEN DATEDIFF(YEAR, HireDate, getdate()) > 18 THEN 'Greater than 18'
   END AS Experience, SUM(SOH.SubTotal) as TotalSales ,COUNT(E.EmployeeID) AS 'Number of Employees'
FROM HumanResources.Employee E
LEFT JOIN Sales.SalesPerson SP
ON E.EmployeeID = SP.SalesPersonID
INNER JOIN Sales.SalesOrderHeader SOH
ON E.EmployeeID = SOH.SalesPersonID
where SOH.SalesPersonID = 275
Group by    CASE 
       WHEN DATEDIFF(YEAR, HireDate, getdate()) < 15 THEN 'LESS than 15'
       WHEN DATEDIFF(YEAR, HireDate, getdate()) BETWEEN 15 AND 18 THEN 'BETWEEN 15 AND 18'
       WHEN DATEDIFF(YEAR, HireDate, getdate()) > 18 THEN 'Greater than 18'
END


--9

SELECT PC.Name,AVG(SD.OrderQty)
FROM [Sales].[SalesOrderDetail] SD
INNER JOIN [Sales].[SalesOrderHeader] SOD
ON SOD.SalesOrderID = SD.SalesOrderID
INNER JOIN [Production].[Product] P
ON SD.ProductID = P.ProductID
INNER JOIN [Production].[ProductSubcategory] PSC
ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
INNER JOIN [Production].[ProductCategory] PC
ON PC.ProductCategoryID = PSC.ProductCategoryID
WHERE (DATEPART(MONTH, SOD.OrderDate) = 4 OR DATEPART(MONTH, SOD.OrderDate) = 5) AND DATEPART(YEAR, SOD.OrderDate) = 2003
GROUP BY PC.Name

--10
with cte1 as ( select pc.Name, month(soh.OrderDate) as months, sum(sod.OrderQty) as quantity_Clothing
              from [Production].[ProductCategory] pc
			  join [Production].[ProductSubcategory] psc
			  on pc.ProductCategoryID = psc.ProductCategoryID
			  join [Production].[Product] p
			  on psc.ProductSubcategoryID = p.ProductSubcategoryID
			  join [Sales].[SalesOrderDetail] sod
			  on sod.ProductID = p.ProductID
			  join [Sales].[SalesOrderHeader] soh
			  on sod.SalesOrderID = soh.SalesOrderID
			  where pc.Name = 'Clothing' and year(soh.OrderDate) = 2003
			  group by pc.Name, month(soh.OrderDate)),
cte2 as ( select pc.Name, month(soh.OrderDate) as months, sum(sod.OrderQty) as quantity_bike
              from [Production].[ProductCategory] pc
			  join [Production].[ProductSubcategory] psc
			  on pc.ProductCategoryID = psc.ProductCategoryID
			  join [Production].[Product] p
			  on psc.ProductSubcategoryID = p.ProductSubcategoryID
			  join [Sales].[SalesOrderDetail] sod
			  on sod.ProductID = p.ProductID
			  join [Sales].[SalesOrderHeader] soh
			  on sod.SalesOrderID = soh.SalesOrderID
			  where pc.Name = 'Bikes' and year(soh.OrderDate) = 2003
			  group by pc.Name, month(soh.OrderDate))
select 2003 , cte1.months, cte1.quantity_Clothing, cte2.quantity_bike
from cte1 inner join cte2
on cte2.months = cte1.months
where cte1.quantity_Clothing < cte2.quantity_bike

--10B

select LEFT(p.Name,10) as Product_Name_Broken, pd.Description
from [Production].[Product] p
join [Production].[ProductModel] pm
on p.ProductModelID = pm.ProductModelID
join [Production].[ProductModelProductDescriptionCulture] pmpdc
on pmpdc.ProductModelID = pm.ProductModelID
join [Production].[ProductDescription] pd
on pd.ProductDescriptionID = pmpdc.ProductDescriptionID

--11
select LEFT(p.Name,10) as Product_Name_Broken, pd.Description, len(p.Name) - 10 as no_of_char_deleted
from [Production].[Product] p
join [Production].[ProductModel] pm
on p.ProductModelID = pm.ProductModelID
join [Production].[ProductModelProductDescriptionCulture] pmpdc
on pmpdc.ProductModelID = pm.ProductModelID
join [Production].[ProductDescription] pd
on pd.ProductDescriptionID = pmpdc.ProductDescriptionID

--12

select sum(sod.OrderQty)
from [HumanResources].[Employee] e
join [Sales].[SalesOrderHeader] soh
on e.EmployeeID = soh.SalesPersonID
join [Sales].[SalesOrderDetail] sod
on sod.SalesOrderID = soh.SalesOrderID
where e.MaritalStatus = 'M' and (GETDATE() - e.BirthDate)>=40 and (GETDATE() - e.BirthDate)<=50 and (soh.OrderDate between '01/07/2003' and '01/10/2003')


--13

SELECT COUNT(SC.CustomerID) AS "Count_of_Customers"   
FROM (SELECT SOH.CustomerID,                
COUNT(DISTINCT(PSC.ProductCategoryID)) AS [Count]         
FROM Sales.Customer C             
JOIN Sales.SalesOrderHeader SOH                  
ON C.CustomerID = SOH.CustomerID             
JOIN Sales.SalesOrderDetail SOD                 
ON SOH.SalesOrderID = SOD.SalesOrderID              
JOIN Production.Product P                  
ON SOD.ProductID = P.ProductID              
JOIN Production.ProductSubcategory PSC                 
ON P.ProductSubcategoryID = PSC.ProductSubcategoryID             
JOIN Production.ProductCategory PC              
ON PSC.ProductCategoryID = PC.ProductCategoryID         
GROUP BY SOH.CustomerID) AS SC WHERE SC.[Count]=4 
GROUP BY SC.[Count] 

--14
select pc.Name, sum(sod.LineTotal) as 'Total Sales', round(sum(sod.LineTotal)*100/(select sum( sod.LineTotal) from [Sales].[SalesOrderDetail] sod inner join[Sales].[SalesOrderHeader] soh on sod.SalesOrderID = soh.SalesOrderID where month(soh.OrderDate) = 6 and year(soh.OrderDate) = 2004),2) as 'Percent to Total'
from [Sales].[SalesOrderHeader] soh 
join [Sales].[SalesOrderDetail] sod
on sod.SalesOrderID = soh.SalesOrderID
join [Production].[Product] p 
on p.ProductID = sod.ProductID
join [Production].[ProductSubcategory] psc
on psc.ProductSubcategoryID = p.ProductSubcategoryID
join [Production].[ProductCategory] pc
on pc.ProductCategoryID = psc.ProductCategoryID
where month(soh.OrderDate) = 6 and year(soh.OrderDate) = 2004 and (pc.Name = 'Bikes' or pc.Name = 'Accessories')  
group by pc.Name

--15

select pc.Name , round(100*(sum(SD.LineTotal)/(select sum(S.LineTotal)
FROM [Sales].[SalesOrderDetail] S
INNER JOIN [Sales].[SalesOrderHeader] SH
ON S.SalesOrderID = SH.SalesOrderID
where Datepart(q, SH.OrderDate) = 2 and Datepart(year, SH.OrderDate) = 2003)), 2)
FROM [Sales].[SalesOrderDetail] SD
INNER JOIN [Sales].[SalesOrderHeader] SH
ON SD.SalesOrderID = SH.SalesOrderID
INNER JOIN [Production].[Product] P
ON SD.ProductID = P.ProductID
INNER JOIN [Production].[ProductSubcategory] PSC
on PSC.ProductSubcategoryID = P.ProductSubcategoryID
inner join [Production].[ProductCategory] pc
on PSC.ProductCategoryID = pc.ProductCategoryID
where Datepart(q, SH.OrderDate) = 2 and Datepart(year, SH.OrderDate) = 2003
group by pc.Name
order by 2 desc


--16

select top 1 pc.Name, max(sod.OrderQty) as 'Maximum Product Sold', min(sod.OrderQty) as 'Minimum Product Sold', max(sod.OrderQty) - min(sod.OrderQty) as 'Difference Between Max and Min'
from [Sales].[SalesOrderHeader] soh 
join [Sales].[SalesOrderDetail] sod
on sod.SalesOrderID = soh.SalesOrderID
join [Production].[Product] p 
on p.ProductID = sod.ProductID
join [Production].[ProductSubcategory] psc
on psc.ProductSubcategoryID = p.ProductSubcategoryID
join [Production].[ProductCategory] pc
on pc.ProductCategoryID = psc.ProductCategoryID
where year(soh.OrderDate) = 2003
group by pc.Name
order by 4 desc

--17

(Select Distinct PSC.Name
FROM [Sales].[SalesOrderDetail] SD
INNER JOIN [Sales].[SalesOrderHeader] SH
ON SD.SalesOrderID = SH.SalesOrderID
INNER JOIN [Production].[Product] P
ON SD.ProductID = P.ProductID
INNER JOIN [Production].[ProductSubcategory] PSC
on PSC.ProductSubcategoryID = P.ProductSubcategoryID
inner join [Production].[ProductCategory] pc
on PSC.ProductCategoryID = pc.ProductCategoryID
where pc.Name = 'Clothing' and DATEPART(Month, SH.OrderDate) = 1 and DATEPART(YEAR, SH.OrderDate)=2003)
INTERSECT
(Select Distinct PSC.Name
FROM [Sales].[SalesOrderDetail] SD
INNER JOIN [Sales].[SalesOrderHeader] SH
ON SD.SalesOrderID = SH.SalesOrderID
INNER JOIN [Production].[Product] P
ON SD.ProductID = P.ProductID
INNER JOIN [Production].[ProductSubcategory] PSC
on PSC.ProductSubcategoryID = P.ProductSubcategoryID
inner join [Production].[ProductCategory] pc
on PSC.ProductCategoryID = pc.ProductCategoryID
where pc.Name = 'Clothing' and DATEPART(Month, SH.OrderDate) = 2 and DATEPART(YEAR, SH.OrderDate)=2004)
order by 1


--18
with cte as (select rank() over(partition by pc.Name order by avg(sod.LineTotal)) as rn, pc.Name as p1, p.Name as p2, avg(sod.LineTotal) as average
from [Sales].[SalesOrderHeader] soh 
join [Sales].[SalesOrderDetail] sod
on sod.SalesOrderID = soh.SalesOrderID
join [Production].[Product] p 
on p.ProductID = sod.ProductID
join [Production].[ProductSubcategory] psc
on psc.ProductSubcategoryID = p.ProductSubcategoryID
join [Production].[ProductCategory] pc
on pc.ProductCategoryID = psc.ProductCategoryID
where year(soh.OrderDate) = 2003 
group by pc.Name, p.Name);
 
select cte.p1 as Product_Category, cte.p2 as Product, cte.average as Minimum_Average_Salary
from cte 
where rn =1
order by 1,3

--19B

ALTER TABLE CustomProductID_Pratishtha ADD ProductName VARCHAR(50);

UPDATE CustomProductID_Pratishtha
SET CustomProductID_Pratishtha.ProductName = p.Name
from CustomProductID_Pratishtha s
inner join Production.Product p
on s.prodid = p.ProductID;

SELECT * FROM CustomProductID_Pratishtha



-----19A

SELECT TOP 25 SalesOrderDetail.ProductID
INTO CustomProductID_pratishtha
FROM   Production.Product Product
    JOIN Sales.SalesOrderDetail SalesOrderDetail 
       ON Product.ProductID = SalesOrderDetail.ProductID
GROUP BY SalesOrderDetail.ProductID 

SELECT * FROM CustomProductID_Pratishtha

--20

SELECT * INTO SalesOrderDetail_Pratishtha
FROM Sales.SalesOrderDetail
WHERE OrderQty <= 10 
         or OrderQty >= 30

 

SELECT * FROM SalesOrderDetail_Pratishtha


--21

create Table SalesDetails_Pratishtha (
	catid int,
	scatid int,
	cat varchar(255),
	scat varchar(255)
	);


Insert Into SalesDetails_Pratishtha
Select pc.ProductCategoryID, PSC.ProductSubcategoryID, pc.Name, PSC.Name
from [Production].[ProductSubcategory] PSC
inner join [Production].[ProductCategory] pc
on PSC.ProductCategoryID = pc.ProductCategoryID;

alter table SalesDetails_Pratishtha
add totalrev2003 int;

with c1 as (select sum(sh.TotalDue) as totalrev, s.scatid
from SalesDetails_Pratishtha s
inner join Production.ProductSubcategory psc
on psc.ProductCategoryID = s.catid
inner join Production.Product p
on p.ProductSubcategoryID = psc.ProductSubcategoryID
inner join Sales.SalesOrderDetail sd
on p.ProductID = sd.ProductID
inner join Sales.SalesOrderHeader sh
on sd.SalesOrderID = sh.SalesOrderID
where year(sh.OrderDate) = 2003
group by s.scatid)


update SalesDetails_Pratishtha
set totalrev2003 = c1.totalrev
from SalesDetails_Pratishtha s
inner join c1
on c1.scatid = s.scatid;

alter table SalesDetails_Pratishtha
add totalrev2004 int;

with c2 as (select sum(sh.TotalDue) as totalrev, s.scatid
from SalesDetails_Pratishtha s
inner join Production.ProductSubcategory psc
on psc.ProductCategoryID = s.catid
inner join Production.Product p
on p.ProductSubcategoryID = psc.ProductSubcategoryID
inner join Sales.SalesOrderDetail sd
on p.ProductID = sd.ProductID
inner join Sales.SalesOrderHeader sh
on sd.SalesOrderID = sh.SalesOrderID
where year(sh.OrderDate) = 2004
group by s.scatid)

update SalesDetails_Pratishtha
set totalrev2004 = c2.totalrev
from SalesDetails_Pratishtha s
inner join c2
on c2.scatid = s.scatid;


--22A

SELECT * 
INTO   Employee_Pratishtha1 
FROM   HumanResources.Employee e
ALTER TABLE Employee_Pratishtha1 
ADD Salary NUMERIC (38 , 4)

 

UPDATE a 
SET a.Salary = SalesPerson.SalesYTD
FROM Employee_Pratishtha1 a
    JOIN HumanResources.Employee Employee 
       ON a.EmployeeID = Employee.EmployeeID
    JOIN Sales.SalesPerson SalesPerson
       ON Employee.EmployeeID = SalesPerson.SalesPersonID

 
SELECT * FROM Employee_Pratishtha1


--22B

UPDATE a  

SET Salary = (SELECT CASE 
               WHEN Gender = 'M' THEN Salary * 1.17  
               WHEN Gender = 'F' THEN Salary * 1.20  
END 
FROM  Employee_Pratishtha1  t 
WHERE a.EmployeeID = t.EmployeeID ) 
FROM Employee_Pratishtha1 a 
SELECT * FROM Employee_Pratishtha1;


--23

SELECT * 
INTO CopyProduct 
FROM Production.Product

Update CopyProduct 
SET Name = REPLACE( 
REPLACE( 
REPLACE( 
REPLACE( 
REPLACE( 
REPLACE( 
REPLACE(Name, '-', ''), ',', ''), '/', ''),'@',''),'$',''),'&',''),'*','')
FROM CopyProduct


--24

SELECT * INTO SalesOderHeader_Pratishtha
FROM Sales.SalesOrderHeader ;

WITH  cte AS ( 
SELECT  ROW_NUMBER () OVER( ORDER BY SalesOrderID) AS RowNumber 
FROM SalesOderHeader_Pratishtha) 

DELETE FROM cte 
WHERE RowNumber  like '%00' ;


SELECT * FROM SalesOderHeader_Pratishtha;

--25

SELECT *  
INTO SalesOderDetail_Pratishtha
FROM Sales.SalesOrderDetail ;

WITH CTE 
AS (SELECT ROW_NUMBER()  OVER (  
PARTITION BY ProductID            
ORDER BY ProductID 
) DUPLICATE 
FROM SalesOderDetail_Pratishtha) 

DELETE FROM CTE 
WHERE  DUPLICATE > 1 ;




 














