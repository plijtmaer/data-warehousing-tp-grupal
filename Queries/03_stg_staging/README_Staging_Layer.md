# CAPA DE STAGING (STG_)

## Concepto

La capa de staging (STG_) representa la versión limpia y estandarizada de los datos de la capa raw (TMP_). 

### Arquitectura de Capas

```
RAW (TMP_) → STAGING (STG_) → DATA WAREHOUSE (DWH_)
```

- **TMP_**: Datos tal como vienen de los archivos CSV (raw)
- **STG_**: Datos limpios, estandarizados y validados
- **DWH_**: Modelo dimensional final

## Transformaciones por Tabla

### Tablas que no requieren transformación
Las siguientes tablas están limpias y se copian directamente:
- STG_Customers (desde TMP_Customers)
- STG_Products (desde TMP_Products) 
- STG_Orders (desde TMP_Orders)
- STG_OrderDetails (desde TMP_OrderDetails)
- STG_Employees (desde TMP_Employees - ya corregida)
- STG_Categories (desde TMP_Categories)
- STG_Suppliers (desde TMP_Suppliers)
- STG_Shippers (desde TMP_Shippers)
- STG_Regions (desde TMP_Regions)
- STG_Territories (desde TMP_Territories)
- STG_EmployeeTerritories (desde TMP_EmployeeTerritories)

### Tablas que requieren limpieza

#### STG_WorldData2023
**Problemas identificados en TMP_WorldData2023:**
- Población con comas: `38,041,754` → `38041754`
- GDP con símbolos: `$19,101,353,833 ` → `19101353833`
- Otros campos numéricos como texto con formato problemático

**Transformaciones aplicadas:**
- Conversión de campos numéricos de texto a REAL
- Eliminación de símbolos ($, comas, espacios)
- Validación de rangos válidos
- Manejo de valores nulos/vacíos

## Estructura de Scripts

Cada tabla STG_ tiene su directorio con:
- `01_create.sql`: Crear tabla STG_
- `02_load.sql`: Cargar datos desde TMP_ con transformaciones
- `03_validate.sql`: Controles de calidad post-carga

## Orden de Ejecución

1. Ejecutar todos los `01_create.sql` 
2. Ejecutar todos los `02_load.sql`
3. Ejecutar todos los `03_validate.sql`
4. Modificar scripts DWH para leer desde STG_ en lugar de TMP_

## Beneficios

- **Separación de responsabilidades**: Raw vs Clean data
- **Reutilización**: STG_ se puede usar para múltiples procesos
- **Auditabilidad**: Trazabilidad de transformaciones
- **Calidad**: Datos certificados antes del DWH
- **Mantenibilidad**: Cambios en limpieza sin afectar ingesta 