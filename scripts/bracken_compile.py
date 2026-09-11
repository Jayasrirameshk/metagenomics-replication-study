import os

# Having all Kraken logs, make a joint log with total, classified and unclassified reads
def write_log(logs, log_filename):
    with open(log_filename, "w") as fh:
        fh.write("sampleID\ttotal\tclass\tunclass\n")
        for n in logs:
            fh.write("\t".join(n) + "\n")

def parse_bracken_out(sampleID, filename):
    out = []
    with open(filename, "r") as fh:
        next(fh)
        for line in fh:
            parsed = line.strip().split("\t")
            # ignore empty records
            if len(parsed) < 7 or parsed[5] == "0":
                continue
            indices = [0, 1, 5, 6]  # These are the columns we care about
            parsed = [parsed[n] for n in indices]
            parsed = sampleID + "\t" + "\t".join(parsed)
            out.append(parsed)
    # In 16S databases, we expect species reports to be empty. Code should be able to handle that
    if len(out) == 0:
        return None
    else:
        return out

# Having all Bracken runs, generate a single file with all samples
def merge_bracken_reports(samples, input_path):
    taxonomies = ("phylum", "class", "order", "family", "genus", "species")
    for tax in taxonomies:
        report_filename = tax + ".txt"
        # Open final report write-mode
        with open(report_filename, "w") as fh:
            fh.write("sampleID\tname\ttaxid\tcounts\trelabundance\n")
            for sample in samples:
                # Files are in subdirectories: input_path/taxonomy/sample.txt
                filename = os.path.join(input_path, tax, sample + ".txt")
                out = parse_bracken_out(sample, filename)
                if out is None:
                    pass
                else:
                    fh.write("\n".join(out) + "\n")
        print(f"Created {report_filename}")

if __name__ == "__main__":
    samples = [
        "ERR3450203",
        "ERR3450229", 
        "ERR3450296",
        "ERR3450606",
        "ERR3451635",
        "ERR3452318",
        "ERR3452529",
        "ERR3452574",
        "ERR3452699"
    ]
    
    input_path = input("Enter folder path with Bracken files: ").strip()
    merge_bracken_reports(samples, input_path)