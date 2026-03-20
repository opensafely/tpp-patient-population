import csv
from pathlib import Path


def main():
    input_file = Path("debugging/ehrql_patients.csv")
    output_file = Path("debugging/ehrql_patients_count.csv")

    with open(input_file) as infile:
        reader = csv.reader(infile)
        headers = next(reader)
        patient_count = len(list(reader))

    with open(output_file, "wt") as outf:
        writer = csv.writer(outf)
        writer.writerows(
            [
                ["count"],
                [patient_count]
            ]
        )


if __name__ == "__main__":
    main()