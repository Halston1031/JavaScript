SELECT c.CategoryName AS Category, od.Quantity AS Qty, YEAR(o.OrderDate) AS OrderYear INTO PivotData FROM Categories c
INNER JOIN Products p ON p.CategoryID = c.CategoryID
INNER JOIN [Order Details] od ON od.ProductID = p.ProductID
INNER JOIN Orders o ON od.OrderID = o.OrderID

