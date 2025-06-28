-- Crear tabla de producto de datos: Clientes top por ingresos

DROP TABLE IF EXISTS DP05_ClientesTopPorIngresos;

CREATE TABLE DP05_ClientesTopPorIngresos AS
SELECT
  C.customerID,
  C.companyName,
  C.country,
  ROUND(SUM(OD.unitPrice * OD.quantity), 2) AS total_ingresos
FROM DWH_Fact_OrderDetails OD
JOIN DWH_Fact_Orders O ON OD.orderID = O.orderID
JOIN DWH_Dim_Customers C ON O.customerID = C.customerID
GROUP BY C.customerID, C.companyName, C.country
ORDER BY total_ingresos DESC;
