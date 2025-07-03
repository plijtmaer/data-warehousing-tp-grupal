-- Creación de tabla dimensional para EmployeeTerritories

CREATE TABLE IF NOT EXISTS DWH_Dim_EmployeeTerritories (
  employeeID INTEGER,
  territoryID TEXT,
  PRIMARY KEY (employeeID, territoryID)
);
