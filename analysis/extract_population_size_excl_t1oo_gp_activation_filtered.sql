-- Count patients, excluding those with T1OOs, and filtering by GP activations
-- Note: this is equivalent to the `activated` table in ehrQL (plus T1OO filtering)
-- https://github.com/opensafely-core/ehrql/blob/f6a496db4d6063d2ea0519793482b917273d6753/ehrql/backends/tpp.py#L306
-- It counts the patients who have EVER been registered at an activated practice,
-- irrespective of their current activation status. ehrQL additionally filters
-- relevant GP data based on the end date of the last activated registration.
SELECT
    -- note we divide by a float because dividing int by int in SQL server
    -- uses integer division, which will always round down. This rounds to the nearest 5,
    -- which replicates ehrQL's rounding in measures disclosure control
    CAST(ROUND(COUNT(patient_data.patient_id) / 5.0, 0) * 5 AS INT) AS population_size,
    CONVERT(date, GETUTCDATE()) as date
FROM (
    SELECT
        acked.Patient_ID as patient_id,
        CAST(
            (
                CASE
                    WHEN unacked.MaxUnackEndDate IS NOT NULL
                        AND unacked.MaxUnackEndDate > acked.AckEndDate
                        THEN acked.AckEndDate
                    ELSE '99991231'
                END
            ) AS date) AS end_date
    FROM (
        -- Latest acknowledged registration per patient, excluding T100
        SELECT
            rh.Patient_ID,
            MAX(rh.EndDate) AS AckEndDate
        FROM RegistrationHistory rh
        INNER JOIN DirectionsAcknowledged da
            ON rh.Organisation_ID = da.Organisation_ID
        WHERE rh.Patient_ID NOT IN (SELECT Patient_ID FROM PatientsWithTypeOneDissent)
        GROUP BY rh.Patient_ID
    ) acked
    LEFT JOIN (
        -- Latest unacknowledged registration for the same patient
        SELECT
            rh2.Patient_ID,
            MAX(rh2.EndDate) AS MaxUnackEndDate
        FROM RegistrationHistory rh2
        LEFT JOIN DirectionsAcknowledged da2
            ON rh2.Organisation_ID = da2.Organisation_ID
        WHERE da2.Organisation_ID IS NULL
        GROUP BY rh2.Patient_ID
    ) unacked
        ON acked.Patient_ID = unacked.Patient_ID
    ) patient_data
