from ehrql import create_dataset
from ehrql.tables.core import patients

dataset = create_dataset()
dataset.define_population(patients.exists_for_patient())
