import csv

# Helper function to format numbers to 3 decimal places and wrap in LaTeX inline math
def format_val(val, is_int=False):
    if not val or val == "N/A":
        return ""
    try:
        num = float(val)
        if is_int:
            return f"${int(num)}$"
        return f"${num:.3f}$"
    except ValueError:
        return f"${val}$"

def generate_latex_table(csv_path, output_tex_path):
    data = {}

    with open(csv_path, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            freq = row.get('freq MHz (clk)')
            runtime = row.get('Simulation Time (ns)')
            
            if freq not in data:
                data[freq] = {}
            data[freq][runtime] = row

    # NEW: Map each frequency to its specific simulation times (0, X, 2X)
    runtime_map = {
        '100': ['0', '500', '1000'],
        '500': ['0', '100', '200'],
        '1000': ['0', '50', '100']
    }

    target_freqs = ['100', '500', '1000']
    latex_rows = []

    for freq in target_freqs:
        freq_data = data.get(freq, {})
        
        # Get the correct list of runtimes for this specific frequency
        runtimes = runtime_map.get(freq, ['0', '0', '0'])
        
        # Base row is always the '0' runtime
        base_row = freq_data.get(runtimes[0], {})
        
        # Apply formatting to area and timing data
        cell_count = format_val(base_row.get('cell count', ''), is_int=True)
        net_area = format_val(base_row.get('net um2', ''))
        total_area = format_val(base_row.get('total um2', '')) 
        equiv_gates = format_val(base_row.get('gates total um2 equivalent', ''))
        slack = format_val(base_row.get('timing slack ps', ''))
        
        start_point = base_row.get('Start point', '')
        end_point = base_row.get('End point', '')
        
        # Remove underscores to prevent LaTeX math mode subscript errors
        start_point_clean = start_point.replace('_', '\\_') if start_point else ""
        end_point_clean = end_point.replace('_', '\\_') if end_point else ""
        
        def get_power_metrics(rt):
            row = freq_data.get(rt, {})
            if not row:
                return [""] * 7
            
            leakage = format_val(row.get('leakage (W)', ''))
            dynamic = format_val(row.get('dynamic (W)', ''))
            total = format_val(row.get('total (W)', ''))
            prob_a = format_val(row.get('lp_computed_probability a_i[1]', ''))
            prob_sum = format_val(row.get('lp_computed_probability sum_o[7]', ''))
            tr_a = format_val(row.get('lp_computed_toggle_rate a_i[1]', ''))
            tr_sum = format_val(row.get('lp_computed_toggle_rate sum_o[7]', ''))
            
            return [leakage, dynamic, total, prob_a, prob_sum, tr_a, tr_sum]

        # Fetch metrics using the dynamically mapped runtimes
        m0 = get_power_metrics(runtimes[0]) # The '0' runtime
        m1 = get_power_metrics(runtimes[1]) # The 'X' runtime
        m2 = get_power_metrics(runtimes[2]) # The '2X' runtime

        # 16-column layout
        block = f"""        \\multirow{{3}}{{*}}{{${freq}$}} & \\multirow{{3}}{{*}}{{{cell_count}}} & \\multirow{{3}}{{*}}{{{net_area}}} & \\multirow{{3}}{{*}}{{{total_area}}} & \\multirow{{3}}{{*}}{{{equiv_gates}}} & \\multirow{{3}}{{*}}{{{slack}}} & \\multirow{{3}}{{*}}{{{start_point_clean}}} & \\multirow{{3}}{{*}}{{{end_point_clean}}} & - & {m0[0]} & {m0[1]} & {m0[2]} & {m0[3]} & {m0[4]} & {m0[5]} & {m0[6]} \\\\
        \\cline{{9-16}}
        & & & & & & & & X & {m1[0]} & {m1[1]} & {m1[2]} & {m1[3]} & {m1[4]} & {m1[5]} & {m1[6]} \\\\
        \\cline{{9-16}}
        & & & & & & & & 2X & {m2[0]} & {m2[1]} & {m2[2]} & {m2[3]} & {m2[4]} & {m2[5]} & {m2[6]} \\\\"""
        
        latex_rows.append(block)

    table_body = "\n        \\Xhline{1.5pt}\n".join(latex_rows) + "\n        \\Xhline{1.5pt}"

    with open(output_tex_path, 'w') as f:
        f.write(table_body)

    print(f"File saved to {output_tex_path}")

# Run the function
generate_latex_table('CSVs/TL_results.csv', 'table_data.tex')
