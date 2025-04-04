-- This SQL script contains the solution to the missions for the Wildlife Conservation Database.
-- Please use this solution just in case you need to verify your own queries or if you get stuck.

SELECT * FROM regions;
SELECT * FROM species;
SELECT * FROM climate;
SELECT * FROM observations;


-- MISSION 1
-- This query retrieves the total number of distinct species in each region,
SELECT regions.name, COUNT(DISTINCT species.id) AS total_species
FROM species
JOIN regions ON species.region_id = regions.id
GROUP BY regions.name
ORDER BY total_species DESC;


-- MISSION 2
-- This query retrieves the regions with extreme climate conditions
SELECT regions.name, climate.avg_temperature, climate.precipitation_mm
FROM climate
JOIN regions ON climate.region_id = regions.id
WHERE avg_temperature > 40 OR avg_temperature < -10 OR precipitation_mm < 100;


-- MISSION 3
-- This query retrieves species with a population estimate less than 20% of their maximum historic population
SELECT name, scientific_name, population_estimate, population_max_historic
FROM species
WHERE population_estimate < 0.2 * population_max_historic;


-- MISSION 4
-- This query retrieves the regions with the highest number of distinct species observed
SELECT regions.name, COUNT(DISTINCT observations.species_id) AS observed_species
FROM observations
JOIN regions ON observations.region_id = regions.id
GROUP BY regions.name
ORDER BY observed_species DESC;


-- MISSION 5
-- This query retrieves the species with the most observations, showing their name and total count
SELECT species.name, COUNT(*) AS total_observations
FROM observations
JOIN species ON observations.species_id = species.id
GROUP BY species.name
ORDER BY total_observations DESC;


-- MISSION 6
-- This query retrieves the observers with the most observations, showing their name and total count
SELECT observer_name, COUNT(*) AS total_observations
FROM observations
GROUP BY observer_name
ORDER BY total_observations DESC;


-- MISSION 7
-- This query retrieves species that have never been observed, showing their name and scientific name
SELECT name, scientific_name
FROM species
LEFT JOIN observations ON species.id = observations.species_id
WHERE observations.species_id IS NULL;


-- MISSION 8
-- This query retrieves the average temperature for each region based on observations
SELECT regions.name, AVG(climate.avg_temperature) AS avg_temp
FROM observations
JOIN regions ON observations.region_id = regions.id
JOIN climate ON regions.id = climate.region_id
GROUP BY regions.name
ORDER BY avg_temp DESC;

-- End of queries.sql