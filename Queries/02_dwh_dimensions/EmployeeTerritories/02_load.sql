-- Limpieza previa de registros existentes
DELETE FROM DWH_Dim_EmployeeTerritories;

-- Inserción desde TMP_EmployeeTerritories
INSERT INTO DWH_Dim_EmployeeTerritories (
	employeeID,
	territoryID
)
SELECT
	employeeID,
	territoryID
FROM TMP_EmployeeTerritories;