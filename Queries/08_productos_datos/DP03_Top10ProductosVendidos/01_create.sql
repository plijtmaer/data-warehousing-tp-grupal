-- Crear tabla de producto de datos: Top 10 productos más vendidos

DROP TABLE IF EXISTS DP03_Top10ProductosVendidos;

CREATE TABLE DP03_Top10ProductosVendidos AS
SELECT
  P.productID,
  P.productName,
  SUM(OD.quantity) AS cantidad_vendida
FROM DWH_Fact_OrderDetails OD
JOIN DWH_Dim_Products P ON OD.productID = P.productID
GROUP BY P.productID, P.productName
ORDER BY cantidad_vendida DESC
LIMIT 10;
