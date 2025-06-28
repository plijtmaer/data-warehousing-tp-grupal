-- Crear tabla de producto de datos: Pedidos por empleado

DROP TABLE IF EXISTS DP02_PedidosPorEmpleado;

CREATE TABLE DP02_PedidosPorEmpleado AS
SELECT
  E.employeeID,
  E.firstName || ' ' || E.lastName AS fullName,
  COUNT(O.orderID) AS cantidad_pedidos
FROM DWH_Fact_Orders O
JOIN DWH_Dim_Employees E ON O.employeeID = E.employeeID
GROUP BY E.employeeID, fullName;
