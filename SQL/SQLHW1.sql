---- 找出和最貴的產品同類別的所有產品
WITH MostExpensive 
-- 定義CTE query要查詢的暫存內容
AS (
    SELECT MAX(UnitPrice) AS MaxPrice FROM Products
)
SELECT * FROM Products
-- 執行根據CTE欄位的query
WHERE CategoryID = (
    SELECT CategoryID FROM Products WHERE UnitPrice = (SELECT MaxPrice FROM MostExpensive) 
);

---- 找出和最貴的產品同類別最便宜的產品
SELECT * FROM Products 
WHERE CategoryID IN (SELECT CategoryID FROM Products WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM Products) ) 
AND UnitPrice = (SELECT MIN(UnitPrice) FROM Products WHERE CategoryID 
	IN (SELECT CategoryID FROM Products WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM Products) )
);

---- 計算出上面類別最貴的和最便宜的兩個產品的價差 / \
WITH ProductMinMax 
AS (
    SELECT CategoryID, MAX(UnitPrice) AS MaxPrice, MIN(UnitPrice) AS MinPrice FROM Products GROUP BY CategoryID
)
SELECT CategoryID, MaxPrice - MinPrice AS PriceDifference FROM ProductMinMax;

-- 找出沒有訂過任何商品的客戶所在的城市的所有客戶

---- 找出第 5 貴跟第 8 便宜的產品的產品類別

---- 找出誰買過第 5 貴跟第 8 便宜的產品

---- 找出誰賣過第 5 貴跟第 8 便宜的產品

---- 找出 13 號星期五的訂單 (惡魔的訂單)

---- 找出誰訂了惡魔的訂單

---- 找出惡魔的訂單裡有什麼產品

---- 列出從來沒有打折 (Discount) 出售的產品

---- 列出購買非本國的產品的客戶

---- 列出在同個城市中有公司員工可以服務的客戶

---- 列出那些產品沒有人買過

----------------------------------------------------------------------------------------

---- 列出所有在每個月月底的訂單

---- 列出每個月月底售出的產品

---- 找出有敗過最貴的三個產品中的任何一個的前三個大客戶

---- 找出有敗過銷售金額前三高個產品的前三個大客戶

---- 找出有敗過銷售金額前三高個產品所屬類別的前三個大客戶

---- 列出消費總金額高於所有客戶平均消費總金額的客戶的名字，以及客戶的消費總金額

---- 列出最熱銷的產品，以及被購買的總金額

---- 列出最少人買的產品

---- 列出最沒人要買的產品類別 (Categories)

---- 列出跟銷售最好的供應商買最多金額的客戶與購買金額 (含購買其它供應商的產品)

---- 列出跟銷售最好的供應商買最多金額的客戶與購買金額 (不含購買其它供應商的產品)

---- 列出那些產品沒有人買過

---- 列出沒有傳真 (Fax) 的客戶和它的消費總金額

---- 列出每一個城市消費的產品種類數量

---- 列出目前沒有庫存的產品在過去總共被訂購的數量

---- 列出目前沒有庫存的產品在過去曾經被那些客戶訂購過

---- 列出每位員工的下屬的業績總金額

---- 列出每家貨運公司運送最多的那一種產品類別與總數量

---- 列出每一個客戶買最多的產品類別與金額

---- 列出每一個客戶買最多的那一個產品與購買數量

---- 按照城市分類，找出每一個城市最近一筆訂單的送貨時間

---- 列出購買金額第五名與第十名的客戶，以及兩個客戶的金額差距

