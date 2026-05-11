import os
import re
import csv

# --- Configuration ---
# Match the frequencies and libraries from your Makefile sweep
frequencies = [10, 100, 500, 1000]
libraries = ["worst", "best"]
design_name = "somador"
output_csv = "CSVs/lab5_results.csv"

# --- Regular Expressions ---
# Output for the monitor.tcl after simulation:
#0 FS : 1'hx
#900 PS : 1'h1
#----------------------------
#O que eu tava tentando: re_Tnotx = re.compile(rf"^(\d+)\s+[PS]\s+[:]\s+([\d\'\h\d])")
#O correto:
# Matches lines like "900 PS : 1'h1" and ignores "0 FS : 1'hx"
re_Tnotx = re.compile(r"^(\d+)\s+([A-Za-z]+)\s+:\s+1'h([01])")

def extract_metrics(freq, lib):
    """Gets the info from the dump file"""
    
    # Initialize default values
    Tnotx = "N/A"

    # Ensure your Makefile saves the dump file with a dynamic name so they don't overwrite
    # Example: dump_file = f"frontend/signal_dump_{lib}_{freq}.txt"
    dump_file = f"frontend/dump_files/signal_dump_{lib}_{freq}.txt" 
    
    if os.path.isfile(dump_file):
        with open(dump_file, 'r') as f:
            for line in f:
                match = re_Tnotx.search(line.strip())
                if match:
                    time_val = match.group(1)
                    time_unit = match.group(2)
                    if(time_unit=="PS"):
                      time_unit="ps"
                    Tnotx = f"{time_val} {time_unit}" # Results in "900 PS"
                    break # Stop searching on the FIRST stable transition
                    
    return [freq, lib, Tnotx]

def main():
    with open(output_csv, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["freq MHz", "library", "Stabilization Time"])
        for freq in frequencies:
            for lib in libraries:
                row_data = extract_metrics(freq, lib)
                writer.writerow(row_data)

if __name__ == "__main__":
    main()
