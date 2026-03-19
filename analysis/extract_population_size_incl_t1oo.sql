-- Count patients, including those with T1OOs
-- This query is for data development purposes and so doesn't reference the PatientsWithTypeOneDissent table.
SELECT 
    -- note we divide by a float because dividing int by int in SQL server
    -- uses integer division, which will always round down. This rounds to the nearest 5,
    -- which replicates ehrQL's rounding in measures disclosure control
    CAST(ROUND(COUNT(Patient_ID) / 5.0, 0) * 5 AS INT) AS population_size, 
    CONVERT(date, GETUTCDATE()) as date
FROM Patient
