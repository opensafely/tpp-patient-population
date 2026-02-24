from ehrql import create_measures, years
from ehrql.tables.core import patients

"""
Extract the population size as the measure denominator. This applies all the default
filtering on T1OO, NDOO and GP activations for the OpenSAFELY Internal project, as
defined in https://github.com/opensafely-core/job-server/tree/428dddd0b1e177e5e754d363b0747406dd561c09/jobserver/permissions

2026-02-23: OpenSAFELY-Internal has permission to include NDOO and GP activations but
not T1OO. The denominator value is expected to match the result of extract_population_size_excl_t1oo.sql.
The numerator and intervals values are required for the measure definition but are irrelevant.
"""

measures = create_measures()
measures.define_measure(
    "female_vs_all_patients",
    numerator=patients.sex=="female",
    denominator=patients.exists_for_patient(),
    intervals=years(1).starting_on("2025-01-01"),
)
measures.configure_disclosure_control(enabled=True)
