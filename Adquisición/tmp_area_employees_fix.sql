PRAGMA foreign_keys = ON;

-- Detectar empleados con jefe inexistente
SELECT *
FROM TMP_Employees e
WHERE reportsTo IS NOT NULL
  AND reportsTo NOT IN (
      SELECT employeeID FROM TMP_Employees
    );

--El empleado que no cuenta con jefe es Andrew Fuller, el VP de Sales. 
--Para resolverlo, se crea una tabla nueva con foreign key, se inserta primera el registro del VP y luego al resto de los empleados.
--Esto se hace porque SQLite no nos permite agregar un constraint luego de haber definido las tablas.
--Crear tabla nueva de empleados
CREATE TABLE TMP_Employees_Fix (
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
    photo TEXT,
    notes TEXT,
    reportsTo INTEGER,
    photoPath TEXT,
    FOREIGN KEY (reportsTo) REFERENCES TMP_Employees_Fix(employeeID)
);


--Como el campo de reportsTo del VP es un string, hay que actualizarlo a NULL para que se pueda insertar correctamente
UPDATE TMP_Employees
SET reportsTo = NULL
WHERE TRIM(CAST(reportsTo AS TEXT)) = 'NULL';

--Verificar
SELECT * FROM TMP_Employees WHERE reportsto IS NULL;

--Insertar VP
INSERT INTO TMP_Employees_Fix
SELECT * FROM TMP_Employees WHERE employeeID = 2;

--Insertar empleados que responden directamente al VP
INSERT INTO TMP_Employees_Fix
SELECT * FROM TMP_Employees
WHERE employeeID IN (1, 3, 4, 5, 8);

--Insertar resto de empleados
INSERT INTO TMP_Employees_Fix
SELECT * FROM TMP_Employees
WHERE employeeID IN (6, 7, 9);

--Verificar
SELECT *
FROM TMP_Employees_Fix;
