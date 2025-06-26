# Trabajo Práctico - Data Warehousing

## Descripción
Data Warehouse implementado en SQLite con datos de Northwind y archivo de países.

## Estructura del Proyecto

### Datos
- `Data/ingesta1/`: Archivos CSV iniciales del sistema transaccional
- `Data/ingesta2/`: Archivos CSV con novedades para actualización

### Scripts SQL

#### 1. Adquisición
- `tmp_area_ddl_script.sql`: Creación de tablas temporales (staging)
- `tmp_area_employees_fix.sql`: Corrección de datos de empleados

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
- `01_calidad_ingesta.sql`: Validaciones de datos individuales
- `02_calidad_integracion.sql`: Validaciones de integridad referencial

#### 6. Capas Avanzadas
- `01_capa_memoria.sql`: Tablas para versionado histórico
- `02_capa_enriquecimiento.sql`: Métricas calculadas y datos derivados

#### 7. Validaciones y Consultas
- `01_check_integridad_referencial.sql`: Verificación de consistencia
- `02_analisis_total_ingresos_por_pais_y_mes.sql`: Consulta analítica ejemplo

## Componentes

### Metadata
- Documentación de tablas y campos
- Tipos: TMP_, DWH_, DQM_, MEM_, ENR_

### DQM (Control de Calidad)
- Registro de procesos
- Indicadores con umbrales
- Estadisticas de datos

### Memoria
- Historial de cambios en datos

### Enriquecimiento
- Metricas calculadas de clientes y productos
- Vistas para analisis

## Base de Datos
- `dw-tp-grupo10.db`: Base de datos principal del DWH
- `bkg1_dw-tp-grupo10.db`: Respaldo

## Orden de Ejecución
1. Crear área temporal (Adquisición)
2. Cargar datos CSV en tablas temporales
3. Ejecutar metadata y DQM
4. Crear y cargar dimensiones
5. Crear y cargar hechos
6. Ejecutar controles de calidad
7. Implementar capas de memoria y enriquecimiento
8. Ejecutar validaciones finales

## Tecnología
- DBMS: SQLite
- Herramienta: SQLite Studio
- Lenguaje: SQL estándar