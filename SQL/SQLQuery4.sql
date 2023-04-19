WITH t1 AS
(
	SELECT
	c.CustomerID, c.CompanyName,(
		SELECT SUM(od.UnitPrice * od.Quantity * (1 -  od.Discount))
		FROM [Order Details] od
		INNER JOIN Orders o ON od.OrderID = o.OrderID
		WHERE o.CustomerID = c.CustomerID
	)AS SalesAmount
	FROM Customers c
), 
t2 AS(
	SELECT * FROM t1 
	WHERE SalesAmount >= 3000
)
SELECT * FROM t2
