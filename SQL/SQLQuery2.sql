SET IDENTITY_INSERT TestTable1 ON 
INSERT INTO TestTable1(ProductID,ProductName, UnitPrice)
SELECT TOP 3 ProductID,ProductName, UnitPrice FROM Products
ORDER BY UnitPrice 
SET IDENTITY_INSERT TestTable1 OFF 

SELECT * FROM TestTable1