import os
import re
import csv

# --- Configuration ---
# Match the frequencies and libraries from your Makefile sweep
frequencies = [10, 100, 500, 1000]
libraries = ["worst", "best"]
design_name = "somador"
reports_base_dir = "backend/synthesis/reports"
output_csv = "CSVs/lab3_results.csv"
output_csv2 = "CSVs/lab6_results.csv"

# --- Regular Expressions ---
# Genus area reports usually have a row for the top module starting with its name

#Instance Module  		Cell Count  Cell Area  Net Area   Total Area 
#-----------------------------------------------------------------------------
#somador                 		 34    125.514    43.733      169.247
#{design_name}  \s+(?:\S+\s+)?          (\d+)...
re_area = re.compile(rf"^{design_name}\s+(?:\S+\s+)?(\d+)\s+([\d\.]+)\s+([\d\.]+)\s+([\d\.]+)")

# Genus timing reports usually display slack near the end
# Ex: Slack:=   99222 
re_slack = re.compile(r"(?i)slack\s*[:=]+\s*([-\d\.]+)")

#Probabilities file
#a_i[7] : 0.38000
#sum_o[7] : 0.16000
re_probs = re.compile(r"([\w\[\]]+)\s+:\s+([\d\.]+)")

#Power file
'''
  -------------------------------------------------------------------------
    Category         Leakage     Internal    Switching        Total    Row%
  -------------------------------------------------------------------------
      memory     0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00   0.00%
    register     7.41127e-03  3.44181e-01  6.68942e-01  1.02053e+00  72.62%
       latch     0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00   0.00%
       logic     9.59730e-03  1.27135e-01  2.25066e-01  3.61798e-01  25.74%
        bbox     0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00   0.00%
       clock     0.00000e+00  0.00000e+00  2.30520e-02  2.30520e-02   1.64%
         pad     0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00   0.00%
          pm     0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00   0.00%
  -------------------------------------------------------------------------
    Subtotal     1.70086e-02  4.71316e-01  9.17060e-01  1.40538e+00 100.00%
  Percentage           1.21%       33.54%       65.25%      100.00% 100.00%
  -------------------------------------------------------------------------
                        ^                        ^             ^
'''
#                                      leakage         Internal          Switching         Total
re_power = re.compile(r"(?i)Subtotal\s+([\d\.e\-\+]+)\s+([\d\.e\-\+]+)\s+([\d\.e\-\+]+)\s+([\d\.e\-\+]+)")

def extract_metrics(freq, lib):
    """Parses the specific reports for a given frequency and library combination."""
    folder_name = f"{design_name}_{lib}_{freq}"
    rpt_dir = os.path.join(reports_base_dir, folder_name)
    
    # Initialize default values in case files/data are missing
    cell_count = "N/A"
    net_area = "N/A"
    total_area = "N/A"
    norm_area = "N/A"
    slack = "N/A"
	power = "N/A"
	probs = ["N/A", "N/A"]


    # AREA
    area_file = os.path.join(rpt_dir, f"{design_name}_area.rpt")
    if os.path.isfile(area_file):
        with open(area_file, 'r') as f:
            for line in f:
                match = re_area.search(line.strip())
                if match:
                    cell_count = match.group(1)
                    net_area = match.group(3)
                    total_area = match.group(4)
                    break # Stop searching once top module is found

    # 2. Parse normalized area report
    norm_file = os.path.join(rpt_dir, f"{design_name}_normalized_area.rpt")
    if os.path.isfile(norm_file):
        with open(norm_file, 'r') as f:
            for line in f:
                match = re_area.search(line.strip())
                if match:
                    norm_area = match.group(4)
                    break

    # 3. Parse timing slack report
    slack_file = os.path.join(rpt_dir, f"{design_name}_slack.rpt")
    if os.path.isfile(slack_file):
        with open(slack_file, 'r') as f:
            for line in f:
                match = re_slack.search(line)
                if match:
                    slack = match.group(1)

    return [freq, lib, cell_count, net_area, total_area, norm_area, slack]

# --- Main Execution ---
def main():
    print(f"Extracting data to {output_csv}...")
    
    with open(output_csv, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        # Write CSV Header exactly matching the Lab 03 table columns
        writer.writerow(["freq MHz (clk)", "library", "cell count", "net um2", "total um2", "normalized total um2", "timing slack ps"])

        
        # Iterate through combinations
        for freq in frequencies:
            for lib in libraries:
                row_data = extract_metrics(freq, lib)
                writer.writerow(row_data)

	with open(output_csv2, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        # Write CSV Header exactly matching the Lab 06 table columns
        writer.writerow(["freq MHz (clk)", "library", "cell count", "net um2", "total um2", "normalized total um2", "timing slack ps"])

        
        # Iterate through combinations
        for freq in frequencies:
            for lib in libraries:
                row_data = extract_metrics(freq, lib)
                writer.writerow(row_data)
                
    print("Extraction complete.")

if __name__ == "__main__":
    main()
