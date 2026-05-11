import os
import re
import csv

# --- Configuration ---
frequencies = [10, 100, 500, 1000]
libraries = ["worst", "best"]
design_name = "somador"
reports_base_dir = "../backend/synthesis/reports"
output_csv = "../CSVs/lab6_results.csv"

# Regexes
#Probabilities file
#a_i[7] : 0.38000
#sum_o[7] : 0.16000 
re_probs = re.compile(r"([\w\[\]]+)\s+:\s+([\d\.]+)")

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
    

    power = ["N/A"] * 4
    probs = ["N/A"] * 2

    # POWER
    power_file = os.path.join(rpt_dir, f"{design_name}_power.rpt")
    if os.path.isfile(power_file):
        with open(power_file, 'r') as f:
            for line in f:
                match = re_power.search(line.strip())
                if match:
                    power[0] = match.group(1) # Leakage
                    power[1] = match.group(2) # Internal
                    power[2] = match.group(3) # Switching
                    power[3] = match.group(4) # Total
                    break

    # PROBABILITIES
    probabilities_file = os.path.join(rpt_dir, f"{design_name}_probabilities.rpt")
    if os.path.isfile(probabilities_file):
        with open(probabilities_file, 'r') as f:
            for line in f:
                match = re_probs.search(line.strip())
                if match:
                    signal_name = match.group(1)
                    prob_value = match.group(2)
                    
                    if "a_i" in signal_name:
                        probs[0] = prob_value
                    elif "sum_o" in signal_name:
                        probs[1] = prob_value

    # Concatenate the lists using the + operator
    return [freq, lib] + power + probs

# --- Main Execution ---
def main():
    print(f"Extracting data to {output_csv}...")
    
    with open(output_csv, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        
        # Updated header to match the 8 variables being returned
        writer.writerow(["freq MHz", "library", "leakage", "internal", "switching", "total", "a_i[1] prob", "sum_o[7] prob"])
        
        # Iterate through combinations
        for freq in frequencies:
            for lib in libraries:
                row_data = extract_metrics(freq, lib)
                writer.writerow(row_data)
                
    print("Extraction complete.")

if __name__ == "__main__":
    main()
