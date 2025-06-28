-- Crear tabla de producto de datos: Frecuencia de pedidos por cliente

DROP TABLE IF EXISTS DP07_FrecuenciaPedidosPorCliente;

CREATE TABLE DP07_FrecuenciaPedidosPorCliente AS
SELECT
  C.customerID,
  C.companyName,
  C.country,
  COUNT(O.orderID) AS cantidad_pedidos
FROM DWH_Fact_Orders O
JOIN DWH_Dim_Customers C ON O.customerID = C.customerID
GROUP BY C.customerID, C.companyName, C.country
ORDER BY cantidad_pedidos DESC;
