-- Limpieza previa de la tabla para evitar duplicados
DELETE FROM DWH_Fact_Orders;

-- Inserción de datos desde la tabla de staging 'orders'
INSERT INTO DWH_Fact_Orders (
  orderID,
  customerID,
  employeeID,
  shipperID,
  orderDate,
  requiredDate,
  shippedDate,
  freight
)
SELECT
  orderID,
  customerID,
  employeeID,
  shipVia AS shipperID,     -- Se renombra para mantener consistencia con la dimensión de shippers
  orderDate,
  requiredDate,
  shippedDate,
  freight
FROM TMP_Orders;
