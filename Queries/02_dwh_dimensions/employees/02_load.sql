-- Limpieza previa: elimina los registros con employeeID ya existentes para evitar duplicados
DELETE FROM DWH_Dim_Employees
WHERE employeeID IN (SELECT employeeID FROM TMP_Employees_Fix);

-- Inserción de empleados desde la tabla corregida con jerarquía válida
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
FROM TMP_Employees_Fix;
