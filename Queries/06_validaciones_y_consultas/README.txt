# Validaciones y Consultas Complementarias

Esta carpeta contiene dos consultas SQL adicionales orientadas a validar la integridad del Data Warehouse y comenzar a explorar analíticamente los datos cargados. Si bien no fueron requeridas explícitamente en la consigna, se incluyen como buenas prácticas para fortalecer el trabajo presentado.

---

## 1. Integridad Referencial: Hechos vs. Staging

**Archivo:** "01_check_integridad_referencial.sql"  
**Descripción:** Consulta para verificar que todos los registros presentes en la tabla de hechos "DWH_Fact_Orders" también existan en la tabla de staging "TMP_Orders".  
**Propósito:** Asegurar la consistencia entre las fuentes de staging y los hechos cargados.

---

## 2. Consulta Analítica: Ingresos por país y mes

**Archivo:** "02_analisis_total_ingresos_por_pais_y_mes.sql"  
**Descripción:** Consulta que devuelve el total de ingresos por país y mes, combinando la tabla de hechos con las dimensiones de cliente.  
**Propósito:** Ejemplo de explotación analítica sobre el Data Warehouse implementado.

---

## Consideraciones Finales

Estas consultas fueron incorporadas como evidencia de validación del modelo y demostración de su potencial analítico. Su inclusión aporta valor agregado al trabajo y refleja un enfoque riguroso en el diseño e implementación del Data Warehouse.
