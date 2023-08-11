---use ADW_Target

---Revenue KPI

with cte1 as(
select t.CalendarYear,sum(s.SalesAmount) As Sales
from DimProductCategory c
join DimProductSubcategory sc
on c.ProductCategoryKey = sc.ProductCategoryKey
join DimProductGroup pg
on pg.ProductSubcategoryKey = sc.ProductSubcategoryKey
join DimProduct p
on p.ProductGroupKey = pg.ProductGroupKey
join FactInternetSales s
on s.ProductKey = p.ProductKey
join DimTime t
on t.TimeKey = s.OrderDateKey 
group by t.CalendarYear
)

select c.CalendarYear,sum(c.Sales) as Ty,sum(d.Sales) as Ly, (sum(c.Sales) - sum(d.Sales))/sum(d.sales)*100 as variance
from cte1 c
inner join cte1 d
on c.CalendarYear = d.CalendarYear + 1 
where c.CalendarYear = 2014
group by c.CalendarYear

---Profit KPI

with cte1 as(
select t.CalendarYear,(sum(s.SalesAmount) - sum(s.TotalProductCost)) As profit
from DimProductCategory c
join DimProductSubcategory sc
on c.ProductCategoryKey = sc.ProductCategoryKey
join DimProductGroup pg
on pg.ProductSubcategoryKey = sc.ProductSubcategoryKey
join DimProduct p
on p.ProductGroupKey = pg.ProductGroupKey
join FactInternetSales s
on s.ProductKey = p.ProductKey
join DimTime t
on t.TimeKey = s.OrderDateKey 
group by t.CalendarYear)

select c.CalendarYear, sum(c.profit) as ty, sum(d.profit) as ly, (sum(c.profit) - sum(d.profit))/sum(d.profit) *100 as variance
from cte1 c
join cte1 d
on c.CalendarYear = d.CalendarYear + 1 
where c.CalendarYear = 2014
group by c.CalendarYear

---orders KPI

with cte1 as(
select t.CalendarYear,count(distinct(s.SalesOrderNumber)) As orders
from FactInternetSales s
join DimTime t
on t.TimeKey = s.OrderDateKey 
group by t.CalendarYear)

select c.CalendarYear, c.orders as ty, d.orders as ly, cast((c.orders - d.orders) as float) /cast(d.orders as float) *100 as variance
from cte1 c
join cte1 d
on c.CalendarYear = d.CalendarYear+1 
where c.CalendarYear = 2014

---Category sales and profit visual

select t.CalendarYear,sum(s.SalesAmount) As Sales,(sum(s.SalesAmount) - sum(s.TotalProductCost)) As profit
from DimProductCategory c
join DimProductSubcategory sc
on c.ProductCategoryKey = sc.ProductCategoryKey
join DimProductGroup pg
on pg.ProductSubcategoryKey = sc.ProductSubcategoryKey
join DimProduct p
on p.ProductGroupKey = pg.ProductGroupKey
join FactInternetSales s
on s.ProductKey = p.ProductKey
join DimTime t
on t.TimeKey = s.OrderDateKey 
where t.CalendarYear = 2014 and c.EnglishProductCategoryName = 'Bikes'
group by t.CalendarYear

---Sub Category sales and profit visual

select t.CalendarYear,sc.EnglishProductSubcategoryName,sum(s.SalesAmount) As Sales,(sum(s.SalesAmount) - sum(s.TotalProductCost)) As profit
from DimProductCategory c
join DimProductSubcategory sc
on c.ProductCategoryKey = sc.ProductCategoryKey
join DimProductGroup pg
on pg.ProductSubcategoryKey = sc.ProductSubcategoryKey
join DimProduct p
on p.ProductGroupKey = pg.ProductGroupKey
join FactInternetSales s
on s.ProductKey = p.ProductKey
join DimTime t
on t.TimeKey = s.OrderDateKey 
where t.CalendarYear = 2014 and c.EnglishProductCategoryName = 'Bikes'
group by t.CalendarYear,sc.EnglishProductSubcategoryName

---Information Window

select t.CalendarYear,p.EnglishProductName,sum(s.SalesAmount) As Sales
from DimProductCategory c
join DimProductSubcategory sc
on c.ProductCategoryKey = sc.ProductCategoryKey
join DimProductGroup pg
on pg.ProductSubcategoryKey = sc.ProductSubcategoryKey
join DimProduct p
on p.ProductGroupKey = pg.ProductGroupKey
join FactInternetSales s
on s.ProductKey = p.ProductKey
join DimTime t
on t.TimeKey = s.OrderDateKey 
where t.CalendarYear = 2014 and c.EnglishProductCategoryName = 'Bikes'
group by t.CalendarYear,p.EnglishProductName

---Month trend visual

select t.CalendarYear,t.EnglishMonthName,t.MonthNumberOfYear,sum(s.SalesAmount) As Sales,(sum(s.SalesAmount) - sum(s.TotalProductCost)) As profit,count(distinct(s.SalesOrderNumber)) As orders
from FactInternetSales s
join DimTime t
on t.TimeKey = s.OrderDateKey 
where t.CalendarYear =2014
group by t.CalendarYear,t.EnglishMonthName,t.MonthNumberOfYear
order by t.CalendarYear,t.MonthNumberOfYear,t.EnglishMonthName