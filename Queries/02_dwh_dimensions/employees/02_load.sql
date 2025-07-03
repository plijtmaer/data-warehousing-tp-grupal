-- Limpieza previa: elimina los registros con employeeID ya existentes para evitar duplicados
DELETE FROM DWH_Dim_Employees
WHERE employeeID IN (SELECT employeeID FROM STG_Employees);

-- Inserción de empleados desde STG_Employees (con jerarquía válida corregida)
INSERT INTO DWH_Dim_Employees (
  employeeID,
  lastName,
  firstName,
  title,
  titleOfCourtesy,
  birthDate,
  hireDate,
  address,
  city,
  region,
  postalCode,
  country,
  homePhone,
  extension,
  notes,
  reportsTo
)
SELECT
  employeeID,
  lastName,
  firstName,
  title,
  titleOfCourtesy,
  birthDate,
  hireDate,
  address,
  city,
  region,
  postalCode,
  country,
  homePhone,
  extension,
  notes,
  reportsTo
FROM STG_Employees;
