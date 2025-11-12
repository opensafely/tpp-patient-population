-- Count patients, excluding those with T1OOs
SELECT ROUND(COUNT(Patient_ID) / 5, 1) * 5 AS population_size, CONVERT(date, GETUTCDATE()) as date
FROM Patient
WHERE Patient_ID NOT IN (SELECT Patient_ID FROM PatientsWithTypeOneDissent)
