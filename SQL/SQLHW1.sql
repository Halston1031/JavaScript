---- 找出和最貴的產品同類別的所有產品
WITH MostExpensive 
AS (
    SELECT MAX(UnitPrice) AS MaxPrice FROM Products
)
SELECT * FROM Products
WHERE CategoryID = (
    SELECT CategoryID FROM Products 
	WHERE UnitPrice = (SELECT MaxPrice FROM MostExpensive) 
);

---- 找出和最貴的產品同類別最便宜的產品
SELECT * FROM Products 
WHERE CategoryID IN (SELECT CategoryID FROM Products 
WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM Products) ) 
AND UnitPrice = (SELECT MIN(UnitPrice) FROM Products 
WHERE CategoryID IN (
		SELECT CategoryID FROM Products 
		WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM Products) 
	)
);

---- 計算出上面類別最貴的和最便宜的兩個產品的價差
WITH ProductMinMax 
AS (
    SELECT CategoryID, MAX(UnitPrice) AS MaxPrice, MIN(UnitPrice) AS MinPrice FROM Products 
	GROUP BY CategoryID 
)
SELECT TOP 1 CategoryID, MaxPrice - MinPrice AS PriceDifference FROM ProductMinMax 
ORDER BY PriceDifference DESC;

-- 找出沒有訂過任何商品的客戶,其所在城市中的所有客戶
SELECT * FROM Customers c 
WHERE NOT EXISTS(
	SELECT * FROM Orders 
	WHERE CustomerID = c.CustomerID
);

---- 找出第 5 貴跟第 8 便宜的產品的產品類別
WITH RankedProducts AS(
    SELECT ProductID, ProductName, CategoryID, UnitPrice,
           ROW_NUMBER() OVER (ORDER BY UnitPrice DESC) AS ExpensiveRank,
           ROW_NUMBER() OVER (ORDER BY UnitPrice ASC) AS CheapRank
    FROM Products
)
SELECT c.CategoryName FROM RankedProducts
INNER JOIN Categories c ON RankedProducts.CategoryID = c.CategoryID
WHERE ExpensiveRank = 5 OR CheapRank = 8;

---- 找出誰 買 過第 5 貴跟第 8 便宜的產品
WITH RankedProducts AS(
    SELECT ProductID, ProductName, CategoryID, UnitPrice,
           ROW_NUMBER() OVER (ORDER BY UnitPrice DESC) AS ExpensiveRank,
           ROW_NUMBER() OVER (ORDER BY UnitPrice ASC) AS CheapRank
    FROM Products
)
SELECT c.CustomerID, od.ProductID FROM Customers c
INNER JOIN Orders o ON o.CustomerID = c.CustomerID
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
WHERE od.ProductID IN (
	SELECT ProductID FROM RankedProducts
    WHERE ExpensiveRank = 5 OR CheapRank = 8
);

---- 找出誰 賣 過第 5 貴跟第 8 便宜的產品
WITH RankedProducts AS(
    SELECT ProductID, ProductName, CategoryID, UnitPrice,
           ROW_NUMBER() OVER (ORDER BY UnitPrice DESC) AS ExpensiveRank,
           ROW_NUMBER() OVER (ORDER BY UnitPrice ASC) AS CheapRank
    FROM Products
)
SELECT e.EmployeeID, ProductID FROM Employees e
INNER JOIN Orders o ON o.EmployeeID = e.EmployeeID
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
WHERE od.ProductID IN (
	SELECT ProductID FROM RankedProducts WHERE ExpensiveRank = 5 OR CheapRank = 8
);

---- 找出 13 號星期五的訂單 (惡魔的訂單)
SELECT OrderID, CONVERT(varchar, OrderDate, 110) as OrderDate FROM Orders
WHERE DATEPART(WEEKDAY, OrderDate) = 6 AND DATEPART(DAY, OrderDate) = 13;

---- 找出誰訂了惡魔的訂單
SELECT OrderID, CustomerID,CONVERT(varchar, OrderDate, 110) as OrderDate FROM Orders
WHERE DATEPART(WEEKDAY, OrderDate) = 6 AND DATEPART(DAY, OrderDate) = 13;

---- 找出惡魔的訂單裡有什麼產品
SELECT DISTINCT od.ProductID, p.ProductName FROM Orders o
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
INNER JOIN Products p ON p.ProductID = od.ProductID
WHERE DATEPART(WEEKDAY, OrderDate) = 6 AND DATEPART(DAY, OrderDate) = 13 
ORDER BY od.ProductID;

---- 列出從來沒有打折 (Discount) 出售的產品
SELECT * FROM Orders o
INNER jOIN [Order Details] od ON od.OrderID = o.OrderID
WHERE od.Discount = 0;

---- 列出購買非本國的產品的客戶(不等於自己所在地)
SELECT DISTINCT c.CustomerID, c.ContactName, c.Country, s.Country FROM Customers c
INNER JOIN Orders o ON o.CustomerID = c.CustomerID
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
INNER JOIN Products p ON p.ProductID = od.ProductID
INNER JOIN Suppliers s ON s.SupplierID = p.SupplierID
WHERE(s.Country <> c.Country) 
ORDER BY c.CustomerID;

---- 列出在同個城市中有公司員工可以服務的客戶(公司員工.location == 客戶.location)
SELECT c.CustomerID, c.City, e.City FROM Employees e
INNER JOIN Customers c ON c.City = e.City;

---- 列出哪些產品沒有人買過
SELECT p.ProductID, p.ProductName FROM Products p
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING COUNT(od.ProductID) = 0;

----------------------------------------------------------------------------------------
---- 列出所有在每個月月底的訂單
SELECT o.OrderDate, o.OrderID FROM Orders o
WHERE DATEPART(DAY, o.OrderDate) >= 20 AND DATEPART(DAY, o.OrderDate) <= 31;

---- 列出每個月月底售出的產品
SELECT o.OrderDate, o.OrderID, p.ProductID, p.ProductName FROM Orders o
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
INNER JOIN Products p ON p.ProductID = od.ProductID
WHERE DATEPART(DAY, o.OrderDate) >= 20 AND DATEPART(DAY, o.OrderDate) <= 31;

---- 找出有敗過最貴的三個產品中的任何一前三位客戶
WITH top_3_products AS (
  SELECT TOP 3 ProductID FROM Products ORDER BY UnitPrice DESC
)
SELECT TOP 3 c.CustomerID, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalPrice FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE od.ProductID IN (
  SELECT ProductID FROM top_3_products
)
GROUP BY c.CustomerID ORDER BY TotalPrice DESC;

---- 找出有敗過銷售金額前三高產品的前三位客戶
SELECT DISTINCT TOP 3 c.CustomerID, c.CompanyName, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS SalesAmount 
FROM Customers c
INNER JOIN Orders o ON o.CustomerID = c.CustomerID
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
WHERE od.ProductID IN (
	SELECT TOP 3  od.ProductID FROM [Order Details] od GROUP BY od.ProductID ORDER BY SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) DESC
)
GROUP BY c.CustomerID, c.CompanyName ORDER BY SalesAmount DESC;

---- 找出有敗過銷售金額前三高產品所屬類別的前三位客戶
WITH top_products AS (
    SELECT TOP 3 od.ProductID FROM [Order Details] od 
	GROUP BY od.ProductID ORDER BY SUM((od.UnitPrice * od.Quantity) * (1 - od.Discount)) DESC
), 
top_categories AS (
    SELECT DISTINCT p.CategoryID FROM Products p
    INNER JOIN top_products tp ON tp.ProductID = p.ProductID
),
top_customers AS (
    SELECT TOP 3 c.CustomerID, SUM((od.UnitPrice * od.Quantity) * (1 - od.Discount)) AS total_spending FROM Customers c
    INNER JOIN Orders o ON o.CustomerID = c.CustomerID
    INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
    INNER JOIN Products p ON p.ProductID = od.ProductID
    INNER JOIN top_categories tc ON tc.CategoryID = p.CategoryID
    GROUP BY c.CustomerID ORDER BY SUM((od.UnitPrice * od.Quantity) * (1 - od.Discount)) DESC
)
SELECT CustomerID, total_spending FROM top_customers;

---- 列出消費總金額高於所有客戶平均消費總金額的客戶的名字，以及其客戶的消費總金額
WITH customer_total_spending AS (
    SELECT c.CustomerID, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS total_spending FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY c.CustomerID
),
average_total_spending AS (
    SELECT AVG(total_spending) AS average_spending FROM customer_total_spending
)
SELECT c.CustomerID, cts.total_spending FROM Customers c
JOIN customer_total_spending cts ON c.CustomerID = cts.CustomerID
CROSS JOIN average_total_spending ats
WHERE cts.total_spending > ats.average_spending;

---- 列出最熱銷的產品，以及被購買的總金額
SELECT TOP 1 ProductID, SUM(Quantity * UnitPrice * (1 - Discount)) AS TotalAmount FROM [Order Details]
GROUP BY ProductID ORDER BY TotalAmount DESC;

---- 列出最少人買的產品
SELECT TOP 1 ProductID, SUM(Quantity) AS TotalQuantity FROM [Order Details]
GROUP BY ProductID ORDER BY TotalQuantity ASC;

---- 列出最沒人要買的產品類別 (Categories)
SELECT TOP 1 COUNT(DISTINCT o.CustomerID) AS NoCustomers, c.CategoryID FROM Orders o
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
INNER JOIN Products p ON p.ProductID = od.ProductID
INNER JOIN Categories c ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID ORDER BY NoCustomers ASC;

---- 列出跟銷售最好的供應商買最多金額的客戶與購買金額 (含購買其它供應商的產品)
WITH top_supplier AS (
    SELECT TOP 1 s.SupplierID FROM Suppliers s
    INNER JOIN Products p ON p.SupplierID = s.SupplierID
    INNER JOIN [Order Details] od ON od.ProductID = p.ProductID
    GROUP BY s.SupplierID ORDER BY SUM(od.Quantity) DESC
)
SELECT TOP 1 SUM((od.UnitPrice * od.Quantity) * (1 - od.Discount)) AS total_spending, c.CustomerID FROM Customers c
INNER JOIN Orders o ON o.CustomerID = c.CustomerID
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
INNER JOIN Products p ON p.ProductID = od.ProductID
WHERE p.SupplierID = (SELECT SupplierID FROM top_supplier)
GROUP BY c.CustomerID ORDER BY total_spending DESC;

---- 列出跟銷售最好的供應商買最多金額的客戶與購買金額 (不含購買其它供應商的產品) ???
WITH top_supplier AS (
  SELECT TOP 1 p.SupplierID FROM [Order Details] od
  INNER JOIN Products p ON od.ProductID = p.ProductID
  GROUP BY p.SupplierID ORDER BY SUM(od.Quantity) DESC
),
supplier_orders AS (
  SELECT o.CustomerID, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS total_amount FROM Orders o
  INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
  INNER JOIN Products p ON od.ProductID = p.ProductID
  INNER JOIN top_supplier ts ON p.SupplierID = ts.SupplierID
  GROUP BY o.CustomerID
)
SELECT c.CustomerID, c.CompanyName, so.total_amount FROM supplier_orders so
INNER JOIN Customers c ON so.CustomerID = c.CustomerID
WHERE so.total_amount = (
  SELECT MAX(total_amount) FROM supplier_orders
);

---- 列出哪些產品沒有人買過
SELECT p.ProductID, p.ProductName FROM Products p
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE od.OrderID IS NULL;

---- 列出沒有傳真 (Fax) 的客戶和它的消費總金額
SELECT c.CustomerID, c.CompanyName, SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TotalConsumption
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE c.Fax IS NULL
GROUP BY c.CustomerID, c.CompanyName;

---- 列出 每一個城市 消費的 產品種類數量
SELECT c.City, COUNT(DISTINCT p.ProductID) TotalQuantity FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.City;

---- 列出 目前沒有庫存的產品 在過去總共被訂購的數量
SELECT od.ProductID, SUM(od.Quantity) AS TotalQuantityOrdered FROM [Order Details] od
INNER JOIN Products p ON p.ProductID = od.ProductID
WHERE p.UnitsInStock = 0 AND od.Quantity > 0
GROUP BY od.ProductID;

---- 列出 目前沒有庫存的產品 在過去曾經被那些客戶訂購過
SELECT p.ProductID, p.ProductName, SUM(od.Quantity) AS TotalQuantityOrdered FROM Products p
INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE p.UnitsInStock = 0 
GROUP BY p.ProductID, p.ProductName;

---- 列出每位員工的下屬的業績總金額
WITH EmployeePerformance AS (
    SELECT e.ReportsTo AS EmployeeID, SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TotalAchievement FROM Employees e
    INNER JOIN Orders o ON o.EmployeeID = e.EmployeeID
    INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
    WHERE e.ReportsTo IS NOT NULL
    GROUP BY e.ReportsTo
)
SELECT ep.EmployeeID, e.FirstName + ' ' + e.LastName AS EmployeeName, ep.TotalAchievement,
    (
        SELECT COUNT(*) FROM Employees e2 
        WHERE e2.ReportsTo = ep.EmployeeID
    ) AS SubordinateCount
FROM EmployeePerformance ep
INNER JOIN Employees e ON e.EmployeeID = ep.EmployeeID
ORDER BY ep.EmployeeID;

---- 列出每家貨運公司運送最多的那一種產品類別與總數量
WITH cte AS (
    SELECT s.ShipperID, c.CategoryName, SUM(od.Quantity) AS TotalQuantity,
        ROW_NUMBER() OVER (PARTITION BY s.ShipperID ORDER BY SUM(od.Quantity) DESC) AS RowNumber FROM [Order Details] od
    INNER JOIN Products p ON p.ProductID = od.ProductID
    INNER JOIN Categories c ON c.CategoryID = p.CategoryID
    INNER JOIN Orders o ON o.OrderID = od.OrderID
    INNER JOIN Shippers s ON s.ShipperID = o.ShipVia
    GROUP BY s.ShipperID, c.CategoryName
)
SELECT ShipperID, CategoryName, TotalQuantity FROM cte
WHERE RowNumber = 1;

---- 列出每一個客戶買最多的產品類別與金額
WITH t1 AS (
    SELECT c.CustomerID, cat.CategoryName, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalAmount,
        ROW_NUMBER() OVER (PARTITION BY c.CustomerID ORDER BY SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) DESC) AS RowNumber FROM Customers c
    INNER JOIN Orders o ON o.CustomerID = c.CustomerID
    INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
    INNER JOIN Products p ON p.ProductID = od.ProductID
    INNER JOIN Categories cat ON cat.CategoryID = p.CategoryID
    GROUP BY c.CustomerID, cat.CategoryName
)
SELECT CustomerID, CategoryName, TotalAmount FROM t1
WHERE RowNumber = 1;

---- 列出每一個客戶買最多的那一個產品與購買數量
WITH t1 AS (
    SELECT c.CustomerID, p.ProductName, SUM(od.Quantity) AS TotalQuantity,
        ROW_NUMBER() OVER (PARTITION BY c.CustomerID ORDER BY SUM(od.Quantity) DESC) AS RowNumber FROM [Order Details] od
    INNER JOIN Products p ON p.ProductID = od.ProductID
    INNER JOIN Orders o ON o.OrderID = od.OrderID
    INNER JOIN Customers c ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, p.ProductName
)
SELECT CustomerID, ProductName, TotalQuantity FROM t1
WHERE RowNumber = 1;

---- 按照城市分類，找出每一個城市最近一筆訂單的送貨時間
WITH cteLatestOrders AS (
    SELECT ShipCity, MAX(ShippedDate) AS recentDate FROM Orders
    WHERE ShipCity IS NOT NULL
    GROUP BY ShipCity
)
SELECT ShipCity, recentDate FROM cteLatestOrders;

---- 列出購買金額第五名與第十名的客戶，以及兩個客戶的金額差距
WITH CustomerTotalSpending AS (
    SELECT c.CustomerID, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSpending FROM Customers c
    INNER JOIN Orders o ON o.CustomerID = c.CustomerID
    INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
    GROUP BY c.CustomerID
), RankedCustomers AS (
    SELECT CustomerID, TotalSpending, ROW_NUMBER() OVER (ORDER BY TotalSpending DESC) AS Rank FROM CustomerTotalSpending
)
SELECT * FROM (
    SELECT c1.CustomerID AS CustomerID1, c1.TotalSpending AS TotalSpending1, c2.CustomerID AS CustomerID2, c2.TotalSpending AS TotalSpending2, c2.TotalSpending - c1.TotalSpending AS Difference FROM RankedCustomers c1
    CROSS JOIN RankedCustomers c2
    WHERE c1.Rank = 5 AND c2.Rank = 10
) AS Comparison;