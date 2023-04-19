SELECT c.CustomerID, c.CompanyName, (
SELECT SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) FROM [Order Details] od INNER JOIN Orders o ON od.OrderID = o.OrderID WHERE o.CustomerID = c.CustomerID
)AS SalesAmount FROM Customers c

/*SELECT c.CustomerID,
(
SELECT CompanyName FROM Customers WHERE CustomerID = 'BLONP'
) AS CompanyName, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS SalesAmount
FROM Customers c
INNER JOIN Orders o ON o.CustomerID = c.CustomerID
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.CustomerID*/


