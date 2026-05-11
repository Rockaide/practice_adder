import re

design_name = "somador"
frequency = 10
library = "best"
design_name = "somador"
reports_base_dir = "backend/synthesis/reports"
output_csv = "extract_test.csv"

#Valores de base caso n ache nada
cell_count = "N/A"
net_area = "N/A"
total_area = "N/A"
norm_area = "N/A"


# Formato do texto no report
line = "u_somador_01        somador             34    125.514     43.733      169.247"

# regex
#re_area = re.compile(rf"^{design_name}\s+(?:\S+\s+)?(\d+)\s+([\d\.]+)\s+([\d\.]+)\s+([\d\.]+)")
re_area = re.compile(rf"^(?:\S+\s+)?{design_name}\s+(\d+)\s+([\d\.]+)\s+([\d\.]+)\s+([\d\.]+)")

# Pra procurar a linha que tem oq eu coloquei no regex
match = re_area.search(line)

# Verifica se deu match
if match:
    # Split the extracted data into separate variables
    cell_count = match.group(1)
    cell_area  = match.group(2)
    net_area   = match.group(3)
    total_area = match.group(4)
    
    # Example output
    print(f"Count: {cell_count}")
    print(f"Cell: {cell_area}")
    print(f"Net: {net_area}")
    print(f"Total: {total_area}")
else:
    print("No match found in this line.")
