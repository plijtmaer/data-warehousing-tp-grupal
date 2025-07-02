DROP VIEW IF EXISTS VW_OrderEmployee;

CREATE VIEW VW_OrderEmployee AS
SELECT
  o.orderID,
  e.employeeID,
  e.firstName || ' ' || e.lastName AS empleado_nombre,
  e.title AS puesto_empleado,
  e.city AS ciudad_empleado,
  e.country AS pais_empleado
FROM DWH_Fact_Orders o
JOIN DWH_Dim_Employees e ON o.employeeID = e.employeeID;
