-- CAPA DE ENRIQUECIMIENTO

-- METRICAS DE CLIENTES

CREATE TABLE IF NOT EXISTS ENR_Customer_Analytics (
  customerID TEXT PRIMARY KEY,
  total_orders INTEGER,
  total_spent REAL,
  avg_order_value REAL,
  first_order_date DATE,
  last_order_date DATE,
  days_since_last_order INTEGER,
  customer_lifetime_days INTEGER,
  customer_tier TEXT, -- 'VIP', 'Premium', 'Regular', 'New'
  is_active INTEGER, -- 1 = activo últimos 90 días, 0 = inactivo
  country_gdp REAL, -- enriquecido desde world data
  country_life_expectancy REAL,
  fecha_calculo DATE DEFAULT CURRENT_DATE,
  FOREIGN KEY (customerID) REFERENCES DWH_Dim_Customers(customerID)
);

-- ENRIQUECIMIENTO DE PRODUCTOS


CREATE TABLE IF NOT EXISTS ENR_Product_Analytics (
  productID INTEGER PRIMARY KEY,
  total_quantity_sold INTEGER,
  total_revenue REAL,
  avg_selling_price REAL,
  total_orders_containing_product INTEGER,
  first_sale_date DATE,
  last_sale_date DATE,
  days_since_last_sale INTEGER,
  product_popularity_rank INTEGER,
  category_revenue_share_pct REAL,
  supplier_dependency_score REAL, -- basado en concentración de ventas
  price_stability_score REAL, -- basado en variación de precios
  product_status TEXT, -- 'Top Seller', 'Regular', 'Slow Moving', 'Obsolete'
  fecha_calculo DATE DEFAULT CURRENT_DATE,
  FOREIGN KEY (productID) REFERENCES DWH_Dim_Products(productID)
);

-- ENRIQUECIMIENTO DE EMPLEADOS


CREATE TABLE IF NOT EXISTS ENR_Employee_Performance (
  employeeID INTEGER PRIMARY KEY,
  total_orders_handled INTEGER,
  total_revenue_generated REAL,
  avg_order_value REAL,
  total_customers_served INTEGER,
  employee_rank_by_revenue INTEGER,
  tenure_years REAL,
  orders_per_year REAL,
  territory_coverage_count INTEGER,
  direct_reports_count INTEGER, -- cuántos empleados reportan a este
  hierarchy_level INTEGER, -- nivel jerárquico (1=CEO, 2=VP, etc.)
  performance_score REAL, -- score basado en múltiples métricas
  employee_tier TEXT, -- 'Star Performer', 'High Performer', 'Average', 'Needs Improvement'
  fecha_calculo DATE DEFAULT CURRENT_DATE,
  FOREIGN KEY (employeeID) REFERENCES DWH_Dim_Employees(employeeID)
);

-- SCRIPT DE CARGA - ENRIQUECIMIENTO CLIENTES


-- Limpiar tabla antes de recalcular
DELETE FROM ENR_Customer_Analytics;

INSERT INTO ENR_Customer_Analytics (
  customerID, total_orders, total_spent, avg_order_value,
  first_order_date, last_order_date, days_since_last_order,
  customer_lifetime_days, customer_tier, is_active,
  country_gdp, country_life_expectancy
)
WITH customer_stats AS (
  SELECT 
    o.customerID,
    COUNT(DISTINCT o.orderID) as total_orders,
    SUM(od.totalPrice) as total_spent,
    AVG(od.totalPrice) as avg_order_value,
    MIN(o.orderDate) as first_order_date,
    MAX(o.orderDate) as last_order_date,
    JULIANDAY('now') - JULIANDAY(MAX(o.orderDate)) as days_since_last_order,
    JULIANDAY(MAX(o.orderDate)) - JULIANDAY(MIN(o.orderDate)) as customer_lifetime_days
  FROM DWH_Fact_Orders o
  JOIN DWH_Fact_OrderDetails od ON o.orderID = od.orderID
  GROUP BY o.customerID
),
customer_enriched AS (
  SELECT 
    cs.*,
    c.country,
    wd.gdp as country_gdp,
    wd.life_expectancy as country_life_expectancy,
    -- Clasificación de tier basada en gasto total
    CASE 
      WHEN cs.total_spent >= 5000 THEN 'VIP'
      WHEN cs.total_spent >= 2000 THEN 'Premium'
      WHEN cs.total_spent >= 500 THEN 'Regular'
      ELSE 'New'
    END as customer_tier,
    -- Cliente activo si compró en últimos 90 días
    CASE 
      WHEN cs.days_since_last_order <= 90 THEN 1
      ELSE 0
    END as is_active
  FROM customer_stats cs
  JOIN DWH_Dim_Customers c ON cs.customerID = c.customerID
  LEFT JOIN TMP_WorldData2023 wd ON c.country = wd.country
)
SELECT 
  customerID, total_orders, total_spent, avg_order_value,
  first_order_date, last_order_date, days_since_last_order,
  customer_lifetime_days, customer_tier, is_active,
  country_gdp, country_life_expectancy
FROM customer_enriched;

-- SCRIPT DE CARGA - ENRIQUECIMIENTO PRODUCTOS

DELETE FROM ENR_Product_Analytics;

INSERT INTO ENR_Product_Analytics (
  productID, total_quantity_sold, total_revenue, avg_selling_price,
  total_orders_containing_product, first_sale_date, last_sale_date,
  days_since_last_sale, product_popularity_rank, category_revenue_share_pct,
  product_status
)
WITH product_stats AS (
  SELECT 
    od.productID,
    SUM(od.quantity) as total_quantity_sold,
    SUM(od.totalPrice) as total_revenue,
    AVG(od.unitPrice) as avg_selling_price,
    COUNT(DISTINCT od.orderID) as total_orders_containing_product,
    MIN(o.orderDate) as first_sale_date,
    MAX(o.orderDate) as last_sale_date,
    JULIANDAY('now') - JULIANDAY(MAX(o.orderDate)) as days_since_last_sale
  FROM DWH_Fact_OrderDetails od
  JOIN DWH_Fact_Orders o ON od.orderID = o.orderID
  GROUP BY od.productID
),
category_totals AS (
  SELECT 
    p.categoryID,
    SUM(ps.total_revenue) as category_total_revenue
  FROM product_stats ps
  JOIN DWH_Dim_Products p ON ps.productID = p.productID
  GROUP BY p.categoryID
),
product_enriched AS (
  SELECT 
    ps.*,
    p.categoryID,
    -- Ranking de popularidad por revenue
    ROW_NUMBER() OVER (ORDER BY ps.total_revenue DESC) as product_popularity_rank,
    -- Participación en revenue de la categoría
    ROUND(
      (ps.total_revenue * 100.0 / ct.category_total_revenue), 2
    ) as category_revenue_share_pct,
    -- Estado del producto
    CASE 
      WHEN ps.total_revenue >= 10000 THEN 'Top Seller'
      WHEN ps.total_revenue >= 2000 THEN 'Regular'
      WHEN ps.days_since_last_sale > 180 THEN 'Obsolete'
      ELSE 'Slow Moving'
    END as product_status
  FROM product_stats ps
  JOIN DWH_Dim_Products p ON ps.productID = p.productID
  JOIN category_totals ct ON p.categoryID = ct.categoryID
)
SELECT 
  productID, total_quantity_sold, total_revenue, avg_selling_price,
  total_orders_containing_product, first_sale_date, last_sale_date,
  days_since_last_sale, product_popularity_rank, category_revenue_share_pct,
  product_status
FROM product_enriched;

-- Limpiar la tabla antes de recalcular
DELETE FROM ENR_Employee_Performance;

-- Insertar métricas enriquecidas por empleado
INSERT INTO ENR_Employee_Performance (
  employeeID,
  total_orders_handled,
  total_revenue_generated,
  avg_order_value,
  total_customers_served,
  employee_rank_by_revenue,
  tenure_years,
  orders_per_year,
  territory_coverage_count,
  direct_reports_count,
  hierarchy_level,
  performance_score,
  employee_tier,
  fecha_calculo
)
WITH employee_orders AS (
  SELECT 
    o.employeeID,
    COUNT(DISTINCT o.orderID) AS total_orders_handled,
    SUM(od.unitPrice * od.quantity * (1 - od.discount)) AS total_revenue_generated,
    AVG(od.unitPrice * od.quantity * (1 - od.discount)) AS avg_order_value,
    COUNT(DISTINCT o.customerID) AS total_customers_served,
    MIN(o.orderDate) AS first_order,
    MAX(o.orderDate) AS last_order
  FROM DWH_Fact_Orders o
  JOIN DWH_Fact_OrderDetails od ON o.orderID = od.orderID
  GROUP BY o.employeeID
),
enriched_employees AS (
  SELECT 
    eo.employeeID,
    eo.total_orders_handled,
    eo.total_revenue_generated,
    eo.avg_order_value,
    eo.total_customers_served,
    
    -- Ranking por revenue
    RANK() OVER (ORDER BY eo.total_revenue_generated DESC) AS employee_rank_by_revenue,
    
    -- Años de antigüedad
    ROUND(
      (JULIANDAY('now') - JULIANDAY(e.hireDate)) / 365.25, 1
    ) AS tenure_years,
    
    -- Pedidos por año
    ROUND(
      eo.total_orders_handled / 
      ((JULIANDAY(eo.last_order) - JULIANDAY(eo.first_order)) / 365.25), 2
    ) AS orders_per_year,
    
    -- Cantidad de territorios cubiertos
    (SELECT COUNT(*) 
     FROM DWH_Dim_EmployeeTerritories et 
     WHERE et.employeeID = e.employeeID
    ) AS territory_coverage_count,
    
    -- Cantidad de empleados reportando (subordinados directos)
    (SELECT COUNT(*) 
     FROM DWH_Dim_Employees sub 
     WHERE sub.reportsTo = e.employeeID
    ) AS direct_reports_count,
    
    -- Nivel jerárquico estimado (1 = CEO, mayor = más bajo)
    CASE 
      WHEN e.reportsTo IS NULL THEN 1
      ELSE 2 + (
        SELECT COUNT(*) 
        FROM DWH_Dim_Employees lvl 
        WHERE lvl.employeeID = e.reportsTo AND lvl.reportsTo IS NOT NULL
      )
    END AS hierarchy_level,
    
    -- Score compuesto (puede afinarse según peso deseado)
    ROUND(
      (
        (eo.total_revenue_generated / 1000.0) + 
        eo.total_orders_handled + 
        eo.total_customers_served * 0.5 +
        COALESCE((SELECT COUNT(*) FROM DWH_Dim_Employees sub WHERE sub.reportsTo = e.employeeID), 0) * 2
      ) / 10.0, 2
    ) AS performance_score,
    
    -- Tier en base al performance_score
    CASE 
      WHEN (eo.total_revenue_generated / 1000.0) >= 200 THEN 'Star Performer'
      WHEN (eo.total_revenue_generated / 1000.0) >= 100 THEN 'High Performer'
      WHEN (eo.total_revenue_generated / 1000.0) >= 30 THEN 'Average'
      ELSE 'Needs Improvement'
    END AS employee_tier,
    
    DATE('now', 'localtime') AS fecha_calculo

  FROM employee_orders eo
  JOIN DWH_Dim_Employees e ON eo.employeeID = e.employeeID
)
SELECT 
  * 
FROM enriched_employees;


-- VISTAS ANALÍTICAS ENRIQUECIDAS


-- Vista consolidada de análisis de clientes
CREATE VIEW IF NOT EXISTS VW_Customer_360 AS
SELECT 
  c.customerID,
  c.companyName,
  c.city,
  c.country,
  e.total_orders,
  e.total_spent,
  e.avg_order_value,
  e.customer_tier,
  e.is_active,
  e.country_gdp,
  e.country_life_expectancy,
  CASE e.is_active 
    WHEN 1 THEN 'Activo'
    ELSE 'Inactivo'
  END as status_texto
FROM DWH_Dim_Customers c
LEFT JOIN ENR_Customer_Analytics e ON c.customerID = e.customerID;

-- Vista de productos top por categoría
CREATE VIEW IF NOT EXISTS VW_Top_Products_By_Category AS
SELECT 
  cat.categoryName,
  p.productName,
  e.total_revenue,
  e.product_popularity_rank,
  e.category_revenue_share_pct,
  e.product_status
FROM ENR_Product_Analytics e
JOIN DWH_Dim_Products p ON e.productID = p.productID
JOIN DWH_Dim_Categories cat ON p.categoryID = cat.categoryID
WHERE e.product_popularity_rank <= 5
ORDER BY cat.categoryName, e.total_revenue DESC;

-- CONSULTAS DE VERIFICACIÓN


-- Top 10 clientes por revenue
SELECT 
  customerID, 
  total_spent,
  customer_tier,
  country_gdp
FROM ENR_Customer_Analytics 
ORDER BY total_spent DESC 
LIMIT 10;

-- Productos con mejor performance
SELECT 
  productID,
  total_revenue,
  product_status,
  category_revenue_share_pct
FROM ENR_Product_Analytics 
WHERE product_status = 'Top Seller'
ORDER BY total_revenue DESC; 

