DROP VIEW IF EXISTS VW_CustomerGeo;

CREATE VIEW VW_CustomerGeo AS
SELECT
  cu.customerID,
  cu.city,
  cu.region,
  cu.country,
  co.population,
  co.gdp,
  co.life_expectancy,
  co.latitude,
  co.longitude,
  r.regionDescription AS nombre_region
FROM DWH_Dim_Customers cu
LEFT JOIN DWH_Dim_Countries co ON cu.country = co.country
LEFT JOIN DWH_Dim_Regions r ON CAST(cu.region AS INTEGER) = r.regionID;
