-- Control previo: verificar que hay datos para cargar
SELECT COUNT(*) as total_employee_territories FROM STG_EmployeeTerritories;

-- Limpieza previa: elimina los registros ya existentes para evitar duplicados
DELETE FROM DWH_Dim_EmployeeTerritories
WHERE (employeeID, territoryID) IN (SELECT employeeID, territoryID FROM STG_EmployeeTerritories);

-- Inserción desde STG_EmployeeTerritories
INSERT INTO DWH_Dim_EmployeeTerritories
SELECT
	employeeID,
	territoryID
FROM STG_EmployeeTerritories;

-- Control posterior: verificar que se cargaron los datos
SELECT COUNT(*) as employee_territories_cargados FROM DWH_Dim_EmployeeTerritories;