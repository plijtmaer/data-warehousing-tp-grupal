-- METADATA PARA NUEVAS CAPAS: DQM, MEMORIA Y ENRIQUECIMIENTO

-- ========================================
-- TABLAS DQM
-- ========================================

INSERT INTO MET_Tablas VALUES ('DQM_Procesos', 'Registro de procesos ejecutados sobre el DWA', 'dqm', '2025-06-25', 'Grupo 10', 'Control de calidad - procesos');
INSERT INTO MET_Tablas VALUES ('DQM_Descriptivos', 'Estadísticas descriptivas de entidades procesadas', 'dqm', '2025-06-25', 'Grupo 10', 'Control de calidad - descriptivos');
INSERT INTO MET_Tablas VALUES ('DQM_Indicadores', 'Indicadores de calidad calculados', 'dqm', '2025-06-25', 'Grupo 10', 'Control de calidad - indicadores');
INSERT INTO MET_Tablas VALUES ('DQM_Reglas', 'Reglas de calidad configurables', 'dqm', '2025-06-25', 'Grupo 10', 'Control de calidad - reglas');

-- ========================================
-- TABLAS DE MEMORIA
-- ========================================

INSERT INTO MET_Tablas VALUES ('MEM_Customers_History', 'Historial de cambios en clientes', 'memoria', '2025-06-25', 'Grupo 10', 'Versionado histórico de dimensión customers');
INSERT INTO MET_Tablas VALUES ('MEM_Products_History', 'Historial de cambios en productos', 'memoria', '2025-06-25', 'Grupo 10', 'Versionado histórico de dimensión products');
INSERT INTO MET_Tablas VALUES ('MEM_Employees_History', 'Historial de cambios en empleados', 'memoria', '2025-06-25', 'Grupo 10', 'Versionado histórico de dimensión employees');

-- ========================================
-- TABLAS DE ENRIQUECIMIENTO
-- ========================================

INSERT INTO MET_Tablas VALUES ('ENR_Customer_Analytics', 'Métricas analíticas calculadas de clientes', 'enriquecimiento', '2025-06-25', 'Grupo 10', 'Datos derivados y KPIs de clientes');
INSERT INTO MET_Tablas VALUES ('ENR_Product_Analytics', 'Métricas analíticas calculadas de productos', 'enriquecimiento', '2025-06-25', 'Grupo 10', 'Datos derivados y KPIs de productos');
INSERT INTO MET_Tablas VALUES ('ENR_Employee_Performance', 'Métricas de rendimiento de empleados', 'enriquecimiento', '2025-06-25', 'Grupo 10', 'Datos derivados y KPIs de empleados');

-- ========================================
-- CAMPOS DQM_PROCESOS
-- ========================================

INSERT INTO MET_Campos VALUES
('DQM_Procesos', 'proceso_id', 'INTEGER', 'Identificador único del proceso', 'Sí', 'No'),
('DQM_Procesos', 'nombre_proceso', 'TEXT', 'Nombre descriptivo del proceso', 'No', 'No'),
('DQM_Procesos', 'tipo_proceso', 'TEXT', 'Tipo de proceso ejecutado', 'No', 'No'),
('DQM_Procesos', 'tabla_origen', 'TEXT', 'Tabla de origen del proceso', 'No', 'Sí'),
('DQM_Procesos', 'tabla_destino', 'TEXT', 'Tabla de destino del proceso', 'No', 'Sí'),
('DQM_Procesos', 'fecha_ejecucion', 'DATETIME', 'Fecha y hora de ejecución', 'No', 'No'),
('DQM_Procesos', 'estado', 'TEXT', 'Estado del proceso', 'No', 'No'),
('DQM_Procesos', 'registros_procesados', 'INTEGER', 'Cantidad de registros procesados', 'No', 'Sí'),
('DQM_Procesos', 'registros_exitosos', 'INTEGER', 'Cantidad de registros exitosos', 'No', 'Sí'),
('DQM_Procesos', 'registros_rechazados', 'INTEGER', 'Cantidad de registros rechazados', 'No', 'Sí'),
('DQM_Procesos', 'tiempo_ejecucion_seg', 'REAL', 'Tiempo de ejecución en segundos', 'No', 'Sí'),
('DQM_Procesos', 'observaciones', 'TEXT', 'Observaciones del proceso', 'No', 'Sí');

-- ========================================
-- CAMPOS DQM_INDICADORES
-- ========================================

INSERT INTO MET_Campos VALUES
('DQM_Indicadores', 'indicador_id', 'INTEGER', 'Identificador único del indicador', 'Sí', 'No'),
('DQM_Indicadores', 'proceso_id', 'INTEGER', 'Referencia al proceso DQM', 'No', 'No'),
('DQM_Indicadores', 'tipo_indicador', 'TEXT', 'Tipo de indicador de calidad', 'No', 'No'),
('DQM_Indicadores', 'tabla_nombre', 'TEXT', 'Tabla evaluada', 'No', 'No'),
('DQM_Indicadores', 'campo_nombre', 'TEXT', 'Campo evaluado', 'No', 'Sí'),
('DQM_Indicadores', 'valor_indicador', 'REAL', 'Valor calculado del indicador', 'No', 'No'),
('DQM_Indicadores', 'umbral_minimo', 'REAL', 'Umbral mínimo aceptable', 'No', 'Sí'),
('DQM_Indicadores', 'umbral_maximo', 'REAL', 'Umbral máximo aceptable', 'No', 'Sí'),
('DQM_Indicadores', 'resultado', 'TEXT', 'Resultado de la evaluación', 'No', 'No'),
('DQM_Indicadores', 'descripcion', 'TEXT', 'Descripción del indicador', 'No', 'Sí'),
('DQM_Indicadores', 'fecha_verificacion', 'DATETIME', 'Fecha de verificación', 'No', 'No');

-- ========================================
-- CAMPOS ENR_CUSTOMER_ANALYTICS
-- ========================================

INSERT INTO MET_Campos VALUES
('ENR_Customer_Analytics', 'customerID', 'TEXT', 'Identificador del cliente', 'Sí', 'No'),
('ENR_Customer_Analytics', 'total_orders', 'INTEGER', 'Total de órdenes del cliente', 'No', 'No'),
('ENR_Customer_Analytics', 'total_spent', 'REAL', 'Total gastado por el cliente', 'No', 'No'),
('ENR_Customer_Analytics', 'avg_order_value', 'REAL', 'Valor promedio de orden', 'No', 'No'),
('ENR_Customer_Analytics', 'first_order_date', 'DATE', 'Fecha de primera orden', 'No', 'Sí'),
('ENR_Customer_Analytics', 'last_order_date', 'DATE', 'Fecha de última orden', 'No', 'Sí'),
('ENR_Customer_Analytics', 'days_since_last_order', 'INTEGER', 'Días desde última orden', 'No', 'Sí'),
('ENR_Customer_Analytics', 'customer_lifetime_days', 'INTEGER', 'Días de vida del cliente', 'No', 'Sí'),
('ENR_Customer_Analytics', 'customer_tier', 'TEXT', 'Tier del cliente', 'No', 'No'),
('ENR_Customer_Analytics', 'is_active', 'INTEGER', 'Indicador de cliente activo', 'No', 'No'),
('ENR_Customer_Analytics', 'country_gdp', 'REAL', 'GDP del país del cliente', 'No', 'Sí'),
('ENR_Customer_Analytics', 'country_life_expectancy', 'REAL', 'Expectativa de vida del país', 'No', 'Sí'),
('ENR_Customer_Analytics', 'fecha_calculo', 'DATE', 'Fecha de cálculo de métricas', 'No', 'No');

-- ========================================
-- CAMPOS ENR_PRODUCT_ANALYTICS
-- ========================================

INSERT INTO MET_Campos VALUES
('ENR_Product_Analytics', 'productID', 'INTEGER', 'Identificador del producto', 'Sí', 'No'),
('ENR_Product_Analytics', 'total_quantity_sold', 'INTEGER', 'Cantidad total vendida', 'No', 'No'),
('ENR_Product_Analytics', 'total_revenue', 'REAL', 'Revenue total del producto', 'No', 'No'),
('ENR_Product_Analytics', 'avg_selling_price', 'REAL', 'Precio promedio de venta', 'No', 'No'),
('ENR_Product_Analytics', 'total_orders_containing_product', 'INTEGER', 'Órdenes que contienen el producto', 'No', 'No'),
('ENR_Product_Analytics', 'first_sale_date', 'DATE', 'Fecha de primera venta', 'No', 'Sí'),
('ENR_Product_Analytics', 'last_sale_date', 'DATE', 'Fecha de última venta', 'No', 'Sí'),
('ENR_Product_Analytics', 'days_since_last_sale', 'INTEGER', 'Días desde última venta', 'No', 'Sí'),
('ENR_Product_Analytics', 'product_popularity_rank', 'INTEGER', 'Ranking de popularidad', 'No', 'Sí'),
('ENR_Product_Analytics', 'category_revenue_share_pct', 'REAL', 'Participación en revenue de categoría', 'No', 'Sí'),
('ENR_Product_Analytics', 'product_status', 'TEXT', 'Estado del producto', 'No', 'No'),
('ENR_Product_Analytics', 'fecha_calculo', 'DATE', 'Fecha de cálculo de métricas', 'No', 'No'); 