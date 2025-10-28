-- Count patients, excluding those with T1OOs
SELECT COUNT(Patient_ID) AS population_size, CONVERT(date, GETUTCDATE()) as date
FROM Patient
WHERE Patient_ID NOT IN (SELECT Patient_ID FROM PatientsWithTypeOneDissent)
