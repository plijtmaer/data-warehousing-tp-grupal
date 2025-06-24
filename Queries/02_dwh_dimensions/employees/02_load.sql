-- Limpieza previa: elimina los registros con employeeID ya existentes para evitar duplicados

DELETE FROM DWH_Dim_Employees
WHERE employeeID IN (SELECT employeeID FROM TMP_Employees);


-- Inserción de datos desde staging TMP_Employees
INSERT INTO DWH_Dim_Employees
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
FROM TMP_Employees;
