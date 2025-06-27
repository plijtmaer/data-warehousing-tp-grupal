# Trabajo Práctico - Data Warehousing

## Descripción
Data Warehouse implementado en SQLite con datos de Northwind y archivo de países.

## Estructura del Proyecto

### Datos
- `Data/ingesta1/`: Archivos CSV iniciales del sistema transaccional
- `Data/ingesta2/`: Archivos CSV con novedades para actualización

### Scripts SQL

#### 1. Adquisición
- `tmp_area_ddl_script.sql`: Creación de 12 tablas temporales con FK
- `tmp_area_employees_fix.sql`: Corrección de datos de empleados
- `controles_ingesta_inicial.sql`: Verificación post-carga de CSV

#### 2. Metadata
- `01_metadata_esquema.sql`: Creación de tablas de metadata
- `02_metadata_carga_tablas.sql`: Documentación de tablas del DWH
- `03_metadata_carga_campos.sql`: Documentación de campos
- `04_dqm_esquema.sql`: Sistema de control de calidad (DQM)
- `05_metadata_dqm_capas.sql`: Metadata de nuevas capas

#### 3. Dimensiones DWH
Cada dimensión tiene dos archivos:
- `01_create.sql`: Creación de la tabla
- `02_load.sql`: Carga de datos desde staging

Dimensiones implementadas:
- Customers, Employees, Products, Suppliers, Categories
- Regions, Territories, Countries, Time, Shippers

#### 4. Hechos DWH
- `Orders/`: Tabla de hechos a nivel pedido
- `OrderDetails/`: Tabla de hechos a nivel producto por pedido

#### 5. Controles de Calidad
- `01_calidad_ingesta.sql`: Completitud, formatos, outliers, unicidad
- `02_calidad_integracion.sql`: Integridad referencial, consistencia de datos

#### 6. Capas Avanzadas  
- `01_capa_memoria.sql`: Versionado histórico con fechas de vigencia
- `02_capa_enriquecimiento.sql`: Analytics de clientes y productos, vistas consolidadas

#### 7. Validaciones y Consultas
- `01_check_integridad_referencial.sql`: Verificación de consistencia
- `02_analisis_total_ingresos_por_pais_y_mes.sql`: Consulta analítica ejemplo

## Componentes

### Metadata
- Documentación de tablas y campos
- Tipos: TMP_, DWH_, DQM_, MEM_, ENR_

### DQM (Control de Calidad)
- 4 tablas: Procesos, Indicadores, Descriptivos, Reglas
- Umbrales configurables (95-100% completitud, 98% formatos)
- Decisiones automaticas de procesamiento

### Memoria
- Historial con fechas de vigencia para Customers, Products, Employees
- Versionado temporal de cambios

### Enriquecimiento
- Customer Analytics: tiers, actividad, métricas por país
- Product Analytics: popularidad, ventas, estado
- Vistas: Customer_360, Top_Products_By_Category

## Base de Datos
- `dw-tp-grupo10.db`: Base de datos principal del DWH
- `bkg1_dw-tp-grupo10.db`: Respaldo

## Puntos de Consigna Completados
- **1-4:** Análisis CSV, área temporal, FK, vinculación países
- **5:** Sistema completo de metadata
- **6:** Modelo dimensional + capas memoria y enriquecimiento  
- **7:** DQM con 4 tablas y controles automatizados
- **8a-8c:** Controles de calidad + carga incremental al DWH

## Orden de Ejecución
1. Crear tablas DQM, memoria, enriquecimiento
2. Actualizar metadata completa
3. Ejecutar controles de calidad (verificar umbrales)
4. Cargar dimensiones en orden de dependencias
5. Cargar tablas de hechos
6. Materializar capas de enriquecimiento
7. Ejecutar validaciones finales

## Tecnología
- DBMS: SQLite
- Herramienta: SQLite Studio
- Lenguaje: SQL estándar