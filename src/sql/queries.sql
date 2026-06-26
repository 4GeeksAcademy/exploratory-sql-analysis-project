-- PLEASE READ THIS BEFORE RUNNING THE EXERCISE

-- ⚠️ IMPORTANT: This SQL file may crash due to two common issues: comments and missing semicolons.

-- ✅ Suggestions:
-- 1) Always end each SQL query with a semicolon `;`
-- 2) Ensure comments are well-formed:
--    - Use `--` for single-line comments only
--    - Avoid inline comments after queries
--    - Do not use `/* */` multi-line comments, as they may break execution

-- -----------------------------------------------
-- queries.sql
-- Complete each mission by writing your SQL query
-- directly below the corresponding instruction
-- -----------------------------------------------

--SELECT * FROM regions;
--SELECT * FROM species;
--SELECT * FROM climate;
--SELECT * FROM observations;


--MISSION 1
--¿Cuáles son las primeras 10 observaciones registradas?
--Utiliza LIMIT para mostrar solo una parte de la tabla.
select * 
from observations
limit 10;

-- MISSION 2
--¿Qué identificadores de región (region_id) aparecen en los datos?
--Usa SELECT DISTINCT para evitar repeticiones.
select distinct region_id 
from observations;


-- MISSION 3
--¿Cuántas especies distintas (species_id) se han observado?
--Combina COUNT con DISTINCT para no contar duplicados.
select count (distinct species_id) 
from observations;


-- MISSION 4
--¿Cuántas observaciones hay para la región con region_id = 2?
--Aplica una condición con WHERE.
select count (region_id) 
from observations
where region_id=2;


-- MISSION 5
--¿Cuántas observaciones se registraron el día 1998-08-08?
--Filtra por fecha exacta usando igualdad.
select count (observation_date) 
from observations
where observation_date = '1998-08-08';


-- MISSION 6
-- ¿Cuál es el region_id con más observaciones?
--Agrupa por región y cuenta cuántas veces aparece cada una.
select region_id,count(id)
from observations
group by region_id
order by count(id) desc;


-- MISSION 7
-- ¿Cuáles son los 5 species_id más frecuentes?
--Agrupa, ordena por cantidad descendente y limita el resultado.
select species_id,count(id)
from observations
group by species_id
order by count(id) desc
limit 5;


-- MISSION 8
-- ¿Qué especies (species_id) tienen menos de 5 registros?
--Agrupa por especie y usa HAVING para aplicar una condición.
select species_id,count(id)
from observations
group by species_id
having count(id) < 5
order by count(id) desc;

-- MISSION 9
--¿Qué observadores (observer) registraron más observaciones?
--Agrupa por el nombre del observador y cuenta los registros.
select observer,count(id) 
from observations
group by observer
order by count(id) desc
limit 10;

-- MISSION 10
--Muestra el nombre de la región (regions.name) para cada observación.
--Relaciona observations con regions usando region_id.

select observations.id, regions.name  
from observations
inner join regions
on observations.region_id = regions.id;

-- MISSION 11
--Muestra el nombre científico de cada especie registrada (species.scientific_name).
--Relaciona observations con species usando species_id.

select observations.id, species.scientific_name 
from observations
inner join species
on observations.species_id = species.id;

-- MISSION 12
--¿Cuál es la especie más observada por cada región?
--Agrupa por región y especie, y ordena por cantidad.
SELECT regions.name as region, species.scientific_name, COUNT(*) as total
FROM observations
JOIN species ON observations.species_id = species.id
JOIN regions ON observations.region_id = regions.id
GROUP BY region, species.scientific_name
ORDER BY region, total DESC;

