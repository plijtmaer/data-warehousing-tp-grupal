--Crear tablas para área temporal

-- 1. Tabla base: Regiones
CREATE TABLE TMP_Regions (
    regionID INTEGER PRIMARY KEY,
    regionDescription TEXT
);

-- 2. Territorios depende de Regions
CREATE TABLE TMP_Territories (
    territoryID INTEGER PRIMARY KEY,
    territoryDescription TEXT,
    regionID INTEGER,
    FOREIGN KEY (regionID) REFERENCES TMP_Regions(regionID)
);

-- 3. Employees 
-- Se agrega la foreign key autorreferencial luego de insertar los datos para evitar errores
CREATE TABLE TMP_Employees (
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
    photoPath TEXT
);

-- 4. EmployeeTerritories depende de Employees y Territories
CREATE TABLE TMP_EmployeeTerritories (
    employeeID INTEGER,
    territoryID INTEGER,
    PRIMARY KEY (employeeID, territoryID),
    FOREIGN KEY (employeeID) REFERENCES TMP_Employees(employeeID),
    FOREIGN KEY (territoryID) REFERENCES TMP_Territories(territoryID)
);

-- 5. Customers
CREATE TABLE TMP_Customers (
    customerID TEXT PRIMARY KEY,
    companyName TEXT,
    contactName TEXT,
    contactTitle TEXT,
    address TEXT,
    city TEXT,
    region TEXT,
    postalCode TEXT,
    country TEXT,
    phone TEXT,
    fax TEXT
);

-- 6. Categories
CREATE TABLE TMP_Categories (
    categoryID INTEGER PRIMARY KEY,
    categoryName TEXT,
    description TEXT,
    picture TEXT
);

-- 7. Suppliers
CREATE TABLE TMP_Suppliers (
    supplierID INTEGER PRIMARY KEY,
    companyName TEXT,
    contactName TEXT,
    contactTitle TEXT,
    address TEXT,
    city TEXT,
    region TEXT,
    postalCode TEXT,
    country TEXT,
    phone TEXT,
    fax TEXT,
    homePage TEXT
);

-- 8. Products depende de Categories y Suppliers
CREATE TABLE TMP_Products (
    productID INTEGER PRIMARY KEY,
    productName TEXT,
    supplierID INTEGER,
    categoryID INTEGER,
    quantityPerUnit TEXT,
    unitPrice REAL,
    unitsInStock INTEGER,
    unitsOnOrder INTEGER,
    reorderLevel INTEGER,
    discontinued INTEGER,
    FOREIGN KEY (supplierID) REFERENCES TMP_Suppliers(supplierID),
    FOREIGN KEY (categoryID) REFERENCES TMP_Categories(categoryID)
);

-- 9. Shippers
CREATE TABLE TMP_Shippers (
    shipperID INTEGER PRIMARY KEY,
    companyName TEXT,
    phone TEXT
);

-- 10. Orders depende de Customers, Employees y Shippers
CREATE TABLE TMP_Orders (
    orderID INTEGER PRIMARY KEY,
    customerID TEXT,
    employeeID INTEGER,
    orderDate TEXT,
    requiredDate TEXT,
    shippedDate TEXT,
    shipVia INTEGER,
    freight REAL,
    shipName TEXT,
    shipAddress TEXT,
    shipCity TEXT,
    shipRegion TEXT,
    shipPostalCode TEXT,
    shipCountry TEXT,
    FOREIGN KEY (customerID) REFERENCES TMP_Customers(customerID),
    FOREIGN KEY (employeeID) REFERENCES TMP_Employees(employeeID),
    FOREIGN KEY (shipVia) REFERENCES TMP_Shippers(shipperID)
);

-- 11. OrderDetails depende de Orders y Products
CREATE TABLE TMP_OrderDetails (
    orderID INTEGER,
    productID INTEGER,
    unitPrice REAL,
    quantity INTEGER,
    discount REAL,
    PRIMARY KEY (orderID, productID),
    FOREIGN KEY (orderID) REFERENCES TMP_Orders(orderID),
    FOREIGN KEY (productID) REFERENCES TMP_Products(productID)
);

-- 12. WorldData2023 (sin relaciones, es necesario validar primero)
CREATE TABLE TMP_WorldData2023 (
    country TEXT PRIMARY KEY,
    density_pkm2 TEXT,
    abbreviation TEXT,
    agricultural_land_pct TEXT,
    land_area_km2 TEXT,
    armed_forces_size TEXT,
    birth_rate TEXT,
    calling_code TEXT,
    capital_major_city TEXT,
    co2_emissions TEXT,
    cpi TEXT,
    cpi_change_pct TEXT,
    currency_code TEXT,
    fertility_rate TEXT,
    forested_area_pct TEXT,
    gasoline_price TEXT,
    gdp TEXT,
    gross_primary_enrollment_pct TEXT,
    gross_tertiary_enrollment_pct TEXT,
    infant_mortality TEXT,
    largest_city TEXT,
    life_expectancy TEXT,
    maternal_mortality_ratio TEXT,
    minimum_wage TEXT,
    official_language TEXT,
    out_of_pocket_expenditure TEXT,
    physicians_per_thousand TEXT,
    population TEXT,
    labor_force_participation_pct TEXT,
    tax_revenue_pct TEXT,
    total_tax_rate TEXT,
    unemployment_rate TEXT,
    urban_population TEXT,
    latitude REAL,
    longitude REAL
);
