DROP VIEW IF EXISTS VW_OrderShipper;

CREATE VIEW VW_OrderShipper AS
SELECT DISTINCT
  o.orderID,
  s.shipperID,
  s.companyName AS empresa_envio,
  s.phone AS telefono_envio
FROM DWH_Fact_Orders o
JOIN DWH_Dim_Shippers s ON o.shipperID = s.shipperID;
