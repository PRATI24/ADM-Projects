PAGE 3

SELECT  DST.SalesTerritoryRegion, 
		PC.EnglishProductCategoryName,
		SUM(FIS.SalesAmount) AS TOTAL_SALES
FROM DimProductCategory PC JOIN DimProductSubcategory DPC 
ON PC.ProductCategoryKey = DPC.ProductCategoryKey
JOIN DimProductGroup DPG ON DPC.ProductSubcategoryKey = DPG.ProductSubcategoryKey
JOIN DimProduct DP ON DPG.ProductGroupKey = DP.ProductGroupKey
JOIN FactInternetSales FIS ON DP.ProductKey = FIS.ProductKey
JOIN DimSalesTerritory DST ON DST.SalesTerritoryKey = FIS.SalesTerritoryKey
JOIN DimTime DT ON DT.TimeKey = FIS.OrderDateKey
WHERE DT.CalendarYear = 2014
GROUP BY DST.SalesTerritoryRegion, PC.EnglishProductCategoryName
ORDER BY 1,2


----

SELECT TOP 5 DP.EnglishProductName,Sum(fis.SalesAmount)
FROM DimProductCategory PC JOIN DimProductSubcategory DPC 
ON PC.ProductCategoryKey = DPC.ProductCategoryKey
JOIN DimProductGroup DPG ON DPC.ProductSubcategoryKey = DPG.ProductSubcategoryKey
JOIN DimProduct DP ON DPG.ProductGroupKey = DP.ProductGroupKey
JOIN FactInternetSales FIS ON DP.ProductKey = FIS.ProductKey
JOIN DimTime DT ON DT.TimeKey = FIS.OrderDateKey
where PC.EnglishProductCategoryName = 'Bikes' and dt.CalendarYear = 2014
group by dp.EnglishProductName
order by 2 desc


------


SELECT DST.SalesTerritoryRegion,
		SUM(FIS.SalesAmount)AS TOTAL_SALES
FROM DimSalesTerritory DST 
INNER JOIN FactInternetSales FIS 
ON DST.SalesTerritoryKey = FIS.SalesTerritoryKey
INNER JOIN DimTime DT 
ON DT.TimeKey = FIS.OrderDateKey
WHERE CalendarYear = 2014 
GROUP BY DST.SalesTerritoryRegion
ORDER BY 2 DESC


-------


SELECT DC.Gender,
		SUM(FIS.SalesAmount) AS Total_Sales
FROM DimCustomer DC 
INNER JOIN FactInternetSales FIS
ON DC.CustomerKey = FIS.CustomerKey
INNER JOIN DimTime DT 
ON DT.TimeKey = FIS.OrderDateKey
where DT.CalendarYear = 2014 
GROUP BY DC.Gender

-------

---PAGE 1

--------


with c as
(
select t.CalendarYear,t.CalendarQuarter,sum(i.SalesAmount) as sales
from DimTime t
join FactInternetSales i
on t.TimeKey = i.OrderDateKey
group by t.CalendarYear,t.CalendarQuarter
)

select cc.CalendarYear,cc.CalendarQuarter,sum(cc.sales) as TY,sum(dd.sales) as LY
from c cc
left outer join c dd
on cc.CalendarYear = dd.CalendarYear + 1 and cc.CalendarQuarter = dd.CalendarQuarter
where cc.CalendarYear = 2014
group by cc.CalendarYear,cc.CalendarQuarter
order by 2


select t.MonthNumberOfYear,t.EnglishMonthName,c.EnglishProductCategoryName,Sum(s.SalesAmount) As sales
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
where t.CalendarYear = 2014
group by t.MonthNumberOfYear,t.EnglishMonthName,c.EnglishProductCategoryName
order by t.MonthNumberOfYear 




select sc.EnglishProductSubcategoryName,sum(s.SalesAmount) as sales
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
where t.CalendarYear = 2014
group by sc.EnglishProductSubcategoryName
order by 2 desc 




select Top 20 cu.FirstName,sum(s.SalesAmount) as sales
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
join DimCustomer cu
on cu.CustomerKey = s.CustomerKey
where t.CalendarYear = 2014
group by cu.FirstName
order by 2 desc 



--page 2 

-----


with cte1 as(
select t.CalendarYear,t.MonthNumberOfYear,t.EnglishMonthName,c.EnglishProductCategoryName,p.ProductKey,p.EnglishProductName,sc.EnglishProductSubcategoryName,sum(s.SalesAmount) As Sales
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
group by t.CalendarYear,t.MonthNumberOfYear,t.EnglishMonthName,c.EnglishProductCategoryName,p.EnglishProductName,p.ProductKey,sc.EnglishProductSubcategoryName
)

select c.MonthNumberOfYear,c.EnglishMonthName,c.EnglishProductCategoryName,c.EnglishProductName,sum(c.Sales) as Ty,sum(d.Sales) as Ly
from cte1 c
left outer join cte1 d
on c.CalendarYear = d.CalendarYear + 1 
and c.EnglishMonthName = d.EnglishMonthName 
and c.EnglishProductCategoryName = d.EnglishProductCategoryName
and c.EnglishProductName = d.EnglishProductName
and c.MonthNumberOfYear = d.MonthNumberOfYear
and c.ProductKey = d.ProductKey
and c.EnglishProductSubcategoryName = d.EnglishProductSubcategoryName
where c.CalendarYear = 2014 and c.EnglishProductSubcategoryName = 'Sports Bikes'
group by c.MonthNumberOfYear,c.EnglishMonthName,c.EnglishProductCategoryName,c.EnglishProductName
order by c.EnglishProductName,c.MonthNumberOfYear