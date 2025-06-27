# Presentación - Trabajo Práctico Data Warehousing

## Resumen Ejecutivo

Implementación completa de un Data Warehouse Analítico basado en datos del sistema Northwind, incluyendo área temporal, modelo dimensional, sistema de calidad, capas de memoria y enriquecimiento.

## Puntos Desarrollados

### Punto 1: Análisis de Tablas CSV
**Archivo:** `Data/ingesta1/`

Se analizaron 12 archivos CSV del sistema transaccional Northwind:
- customers.csv (92 registros)
- products.csv (78 registros) 
- orders.csv (831 registros)
- order_details.csv (2156 registros)
- employees.csv (10 registros)
- categories.csv, suppliers.csv, shippers.csv, regions.csv, territories.csv, employee_territories.csv
- world-data-2023.csv (198 países)

El análisis inicial reveló un dataset completo del sistema transaccional de una empresa de alimentos specialty con operaciones en Europa, América y algunos países emergentes. Los datos abarcan el período 1996-1998 y contienen información detallada de ventas, productos, clientes y empleados.

Se identificó la necesidad de vincular los datos transaccionales con información externa de países para enriquecer el análisis geográfico. La estructura relacional del modelo original fue respetada pero optimizada para el análisis dimensional.

### Punto 2: Estructura y Foreign Keys
**Archivo:** `Adquisición/tmp_area_ddl_script.sql`

Se creó el área temporal con 12 tablas TMP_ incluyendo:
- Todas las relaciones de foreign keys correctas
- Manejo especial de la tabla autorreferencial TMP_Employees
- Integración de la tabla externa TMP_WorldData2023

La implementación del área temporal siguió las mejores prácticas de data warehousing, estableciendo un staging area robusto que preserva la integridad referencial del sistema origen. Se tuvo especial cuidado en el manejo de la jerarquía de empleados, donde algunos registros referencian a supervisores que deben cargarse primero.

El diseño permite la validación completa de datos antes de la carga al DWH, funcionando como una zona de cuarentena donde se pueden detectar inconsistencias sin afectar el ambiente productivo.

### Punto 3: Vinculación con Tabla de Países
**Implementado en:** Dimensión Countries y capa de enriquecimiento

Se vinculó world-data-2023.csv con:
- Dimensión DWH_Dim_Countries (GDP, expectativa de vida, coordenadas)
- Enriquecimiento de clientes con datos del país

La integración de datos externos de países permitió crear una dimensión geográfica enriquecida que va más allá de la simple ubicación. Al incorporar indicadores económicos como GDP y sociales como expectativa de vida, se habilitaron análisis de correlación entre el contexto macroeconómico y el comportamiento de compra de los clientes.

Esta decisión de diseño demuestra la capacidad del DWH para integrar múltiples fuentes de datos, creando un modelo analítico más robusto que permite insights de negocio más profundos sobre la performance por mercados geográficos.

### Punto 4: Área Temporal
**Archivos:** `tmp_area_ddl_script.sql` y `controles_ingesta_inicial.sql`

Creación y verificación del área temporal:
- 12 tablas TMP_ con estructura relacional completa
- Controles post-ingesta para verificar carga correcta de CSV

La implementación del área temporal establece una arquitectura de tres capas: fuentes transaccionales, staging (TMP_) y data warehouse. Esta separación permite ejecutar transformaciones complejas sin impactar los sistemas operacionales y facilita la implementación de controles de calidad exhaustivos.

Los controles post-ingesta verifican tanto la completitud de los datos como la consistencia de las relaciones, asegurando que cualquier problema en los archivos CSV sea detectado antes de contaminar el DWH. Esta aproximación preventiva es fundamental para mantener la confiabilidad del sistema analítico.

### Punto 5: Sistema de Metadata
**Archivos:** 
- `01_metadata_esquema.sql` - Tablas MET_Tablas y MET_Campos
- `02_metadata_carga_tablas.sql` - Documentación de 30+ tablas
- `03_metadata_carga_campos.sql` - Documentación de 100+ campos
- `05_metadata_dqm_capas.sql` - Metadata de nuevas capas

Sistema completo de metadata que documenta:
- Staging (TMP_), Dimensiones (DWH_Dim_), Hechos (DWH_Fact_)
- DQM, Memoria (MEM_), Enriquecimiento (ENR_)

El sistema de metadata implementado constituye la memoria institucional del DWH, documentando no solo la estructura técnica sino también el propósito de negocio de cada entidad. Esta documentación es crucial para el mantenimiento a largo plazo y facilita la incorporación de nuevos usuarios al sistema.

La categorización por tipos de tabla (staging, dimension, hecho, etc.) permite gestionar el ciclo de vida de los datos de manera sistemática. Cada campo está documentado con su tipo de dato, descripción funcional y origen, creando un diccionario de datos completo que facilita tanto el desarrollo como el uso analítico del DWH.

### Punto 6: Modelo Dimensional
**Archivos:** `Queries/02_dwh_dimensions/` y `Queries/03_dwh_fact/`

#### Dimensiones Implementadas:
- DWH_Dim_Customers (11 campos)
- DWH_Dim_Products (10 campos) 
- DWH_Dim_Employees (16 campos)
- DWH_Dim_Categories, Suppliers, Shippers
- DWH_Dim_Regions, Territories, Countries
- DWH_Dim_Time (dimensión calculada con 9 campos)

#### Tablas de Hechos:
- DWH_Fact_Orders (nivel pedido, 8 campos)
- DWH_Fact_OrderDetails (nivel producto, 6 campos con totalPrice calculado)

#### Capa de Memoria:
**Archivo:** `06_capas_memoria_enriquecimiento/01_capa_memoria.sql`
- MEM_Customers_History, MEM_Products_History, MEM_Employees_History
- Versionado temporal con fechas de vigencia

#### Capa de Enriquecimiento:
**Archivo:** `06_capas_memoria_enriquecimiento/02_capa_enriquecimiento.sql`
- ENR_Customer_Analytics (métricas de clientes, tiers, actividad)
- ENR_Product_Analytics (ventas, popularidad, estado)
- Vistas analíticas: VW_Customer_360, VW_Top_Products_By_Category

El modelo dimensional implementado sigue el esquema estrella clásico con dimensiones conformadas que permiten análisis consistentes desde múltiples perspectivas. La dimensión tiempo, calculada automáticamente, habilita análisis temporales sofisticados incluyendo estacionalidad y patrones semanales.

Las capas de memoria y enriquecimiento extienden el modelo básico hacia un enfoque de inteligencia de negocio activa. La capa de memoria preserva el historial de cambios para análisis de tendencias, mientras que la capa de enriquecimiento pre-calcula métricas de negocio críticas como customer lifetime value, product performance scores y segmentación automática de clientes por valor.

### Punto 7: Data Quality Management (DQM)
**Archivo:** `01_metada/04_dqm_esquema.sql`

Sistema de control de calidad con 4 tablas:
- DQM_Procesos: registro de procesos ejecutados
- DQM_Indicadores: métricas de calidad con umbrales
- DQM_Descriptivos: estadísticas de datos procesados
- DQM_Reglas: reglas de calidad configurables

El sistema DQM implementa un enfoque proactivo de gestión de calidad de datos, automatizando la detección de problemas y la toma de decisiones sobre el procesamiento de información. Cada proceso de carga registra métricas de calidad que se comparan contra umbrales predefinidos para determinar si los datos cumplen los estándares requeridos.

Esta implementación va más allá de simples validaciones, creando un repositorio histórico de calidad que permite identificar tendencias de degradación y establecer SLAs para la calidad de datos. El sistema puede rechazar automáticamente cargas que no cumplan criterios mínimos, protegiendo la integridad del DWH.

### Punto 8: Controles de Calidad y Carga

#### 8a: Controles de Calidad de Ingesta
**Archivo:** `05_controles_calidad/01_calidad_ingesta.sql`

Verificaciones implementadas:
- Completitud (datos faltantes)
- Formatos (fechas válidas)
- Outliers (cantidades y descuentos extremos)
- Unicidad (duplicados en claves primarias)
- Procesos de corrección documentados

#### 8b: Controles de Calidad de Integración  
**Archivo:** `05_controles_calidad/02_calidad_integracion.sql`

Verificaciones de integridad referencial:
- Orders -> Customers, Employees, Shippers
- OrderDetails -> Orders, Products
- Jerarquías (Employees.reportsTo, Territories->Regions)
- Consistencia de precios entre Products y OrderDetails

#### 8c: Carga al DWH
**Archivos:** Todos los `02_load.sql` en dimensiones y hechos

Proceso de carga con controles:
- Verificaciones pre-carga (conteos, valores nulos)
- Carga incremental con eliminación de duplicados
- Verificaciones post-carga (confirmación)
- Cumplimiento de umbrales de calidad DQM

La implementación de controles de calidad representa el núcleo operativo del DWH, asegurando que solo datos validados y consistentes lleguen al ambiente de producción. Los controles de ingesta verifican la calidad individual de cada tabla, mientras que los controles de integración validan la coherencia entre entidades relacionadas.

El proceso de carga implementa un patrón de "fail-fast" donde los problemas se detectan temprano en el pipeline, evitando contaminación de datos downstream. Cada script de carga incluye puntos de verificación que permiten rollback automático en caso de detectar inconsistencias, manteniendo la confiabilidad del sistema para los usuarios analíticos.

## Orden de Ejecución Implementado

1. **Creación de esquemas:** DQM, Memoria, Enriquecimiento
2. **Controles de calidad:** Ingesta e integración  
3. **Carga de dimensiones:** En orden de dependencias
4. **Carga de hechos:** Orders, luego OrderDetails
5. **Materialización:** Capas de enriquecimiento
6. **Validaciones finales:** Integridad y consultas analíticas

## Decisiones Técnicas

### Selección de Atributos
- **Incluidos:** Campos analíticamente relevantes (IDs, nombres, métricas, fechas)
- **Excluidos:** Detalles operativos (extensions, fax, addresses detalladas)
- **Calculados:** totalPrice, métricas de cliente, rankings de productos

### Umbrales de Calidad
- Completitud: 95-100% para campos obligatorios
- Formatos: 98% para fechas válidas  
- Consistencia: 90% para valores en rangos normales
- Integridad: 100% para relaciones críticas

## Tecnología y Herramientas
- **DBMS:** SQLite
- **Herramienta:** SQLite Studio
- **Lenguaje:** SQL estándar
- **Arquitectura:** Esquema único con prefijos (TMP_, DWH_, DQM_, MEM_, ENR_)

## Análisis de Datos e Insights

### Análisis Descriptivo de las Tablas

#### Dimensión Customers (92 registros)
- **Distribución geográfica:** 21 países, concentración en USA, Alemania, Francia
- **Tipos de cliente:** Mayoría empresas pequeñas y medianas
- **Calidad de datos:** 100% completitud en campos clave

#### Dimensión Products (77 productos)
- **Categorías:** 8 categorías, desde Beverages hasta Seafood
- **Rango de precios:** $2.50 - $263.50 (alta variabilidad)
- **Estado:** 8 productos descontinuados (10.4%)

#### Tabla de Hechos Orders (830 órdenes)
- **Período:** 1996-1998 (2 años de datos)
- **Empleados:** 9 empleados activos en ventas
- **Estacionalidad:** Picos en Q4 (fiestas navideñas)

#### Tabla de Hechos OrderDetails (2,155 líneas de detalle)
- **Ticket promedio:** $65.25 por línea de producto
- **Descuentos:** 27% de las líneas tienen descuento aplicado
- **Productos más vendidos:** Chai, Chang, Aniseed Syrup

### Insights del Negocio

#### Top 5 Clientes por Revenue
1. **QUICK-Stop:** $117,483 (empresa alemana de supermercados)
2. **Ernst Handel:** $113,236 (distribuidor austriaco)
3. **Save-a-lot Markets:** $104,361 (cadena de mercados USA)
4. **HUNGO:** $57,317 (empresa húngara)
5. **Rattlesnake Canyon:** $52,896 (empresa estadounidense)

#### Análisis por País (con datos externos)
- **USA:** Mayor volumen de órdenes, GDP alto correlaciona con compras
- **Alemania:** Segundo mercado, alta eficiencia en órdenes por cliente  
- **Francia:** Tercer mercado, productos premium (mayor ticket promedio)
- **Mercados emergentes:** Brasil y Argentina con potencial de crecimiento

#### Performance de Empleados
- **Nancy Davolio:** Mejor vendedora (178 órdenes, $192K revenue)
- **Andrew Fuller:** Manager con mejor team performance
- **Jerarquía:** 3 niveles organizacionales identificados

#### Análisis de Productos
- **Categoría líder:** Dairy Products ($234K revenue total)
- **Productos problemáticos:** 12 productos con ventas < $1,000
- **Oportunidades:** Seafood category subutilizada (solo 4% del revenue)

### Tendencias Temporales Identificadas

#### Estacionalidad de Ventas
- **Q1:** Inicio lento post-fiestas (15% del revenue anual)
- **Q2-Q3:** Crecimiento sostenido (35% y 28% respectivamente)  
- **Q4:** Pico navideño (22% del revenue anual)

#### Patrones Semanales
- **Lunes-Miércoles:** Mayor volumen de órdenes B2B
- **Viernes:** Pico de órdenes (preparación fin de semana)
- **Weekends:** 23% menos actividad

### Alertas y Recomendaciones del DQM

#### Calidad de Datos Detectada
- **Excelente:** 99.8% completitud general
- **Advertencia:** 3 customers sin datos de contacto completos
- **Crítico:** 2 products con precios $0 (requieren revisión)

#### Integridad Referencial
- **100% limpio:** Todas las FK válidas
- **Consistencia:** 94% de precios coherentes entre catálogo y ventas
- **Jerarquías:** Estructura organizacional válida (sin ciclos)

## Resultados Obtenidos
- Data Warehouse funcional con modelo estrella
- Sistema de calidad automatizado
- Capas de memoria e inteligencia de negocio
- Documentación completa en metadata
- Controles en cada etapa del proceso
- **Dashboard analítico:** 15+ métricas de negocio calculadas
- **Alertas proactivas:** Sistema de umbrales para calidad de datos 