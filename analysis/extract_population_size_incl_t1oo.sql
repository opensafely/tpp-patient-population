-- Count patients, including those with T1OOs
-- This query is for data development purposes and so doesn't reference the PatientsWithTypeOneDissent table.
SELECT ROUND(COUNT(Patient_ID) / 5, 1) * 5 AS population_size, CONVERT(date, GETUTCDATE()) as date
FROM Patient
