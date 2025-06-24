-- Creación de tabla dimensional para empleados

CREATE TABLE IF NOT EXISTS DWH_Dim_Employees (
  employeeID INTEGER PRIMARY KEY,
  lastName TEXT,
  firstName TEXT,
  title TEXT,
  titleOfCourtesy TEXT,
  birthDate TEXT,
  hireDate TEXT,
  address TEXT,
  city TEXT,
  region TEXT,
  postalCode TEXT,
  country TEXT,
  homePhone TEXT,
  extension TEXT,
  notes TEXT,
  reportsTo INTEGER
);
