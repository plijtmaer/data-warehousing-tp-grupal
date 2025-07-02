DROP VIEW IF EXISTS VW_Orders;

CREATE VIEW VW_Orders AS
SELECT
  o.orderID,
  o.customerID,
  cu.companyName AS cliente_nombre,
  o.employeeID,
  o.shipperID,
  o.orderDate,
  o.requiredDate,
  o.shippedDate,
  o.freight
FROM DWH_Fact_Orders o
JOIN DWH_Dim_Customers cu ON o.customerID = cu.customerID;
