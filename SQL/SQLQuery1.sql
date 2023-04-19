SELECT * FROM Shippers
INSERT INTO Shippers(CompanyName, Phone)
VALUES(N'Fedex1', N'02-33334444'), (N'Fedex2', N'02-44445555'),(N'Fedex3', N'02-55556666')

INSERT INTO Shippers(CompanyName)
VALUES(N'Black Cat')

SET IDENTITY_INSERT Shippers OFF