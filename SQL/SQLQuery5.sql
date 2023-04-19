/*SELECT EmployeeID, FirstName, ReportsTo, (
	SELECT 
		FirstName
	FROM Employees
	WHERE EmployeeID = e.ReportsTo
)As Boss
FROM Employees e*/

 ---recursive
WITH e 
AS(
	SELECT EmployeeID, FirstName, ReportsTo, 1 AS Level, CAST(FirstName AS nvarchar(1000)) AS Hierachy
	FROM Employees
	WHERE ReportsTo IS NULL
	UNION ALL 
		SELECT slave.EmployeeID, slave.FirstName, slave.ReportsTo, e.Level + 1 AS Level, CAST(e.Hierachy + '/' + slave.FirstName AS nvarchar(1000)) AS Hierachy
	FROM Employees slave
	INNER JOIN e ON slave.ReportsTo = e.EmployeeID
)
SELECT * FROM e