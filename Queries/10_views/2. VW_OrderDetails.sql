DROP VIEW IF EXISTS VW_OrderDetails;

CREATE VIEW VW_OrderDetails AS
SELECT
  od.orderID,
  od.productID,
  p.productName,
  ca.categoryName,
  od.quantity,
  od.unitPrice,
  od.discount,
  od.totalPrice
FROM DWH_Fact_OrderDetails od
JOIN DWH_Dim_Products p ON od.productID = p.productID
LEFT JOIN DWH_Dim_Categories ca ON p.categoryID = ca.categoryID;
