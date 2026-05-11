import csv
import matplotlib.pyplot as plt

def generate_power_graph(csv_path, output_img_path):
    # Map the specific runtimes to their logical testbench scenarios
    runtime_map = {
        '100': {'0': 'Sem anotação (Base)', '5000': 'Cenário X', '10000': 'Cenário 2X'},
        '500': {'0': 'Sem anotação (Base)', '100': 'Cenário X', '200': 'Cenário 2X'},
        '1000': {'0': 'Sem anotação (Base)', '50': 'Cenário X', '100': 'Cenário 2X'}
    }

    # Data structure to hold power values: {scenario_name: {frequency: power_value}}
    scenarios_data = {
        'Sem anotação (Base)': {},
        'Cenário X': {},
        'Cenário 2X': {}
    }

    print(f"Reading data from {csv_path}...")
    
    with open(csv_path, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            freq = row.get('freq MHz (clk)')
            rt = row.get('Simulation Time (ns)')
            power_str = row.get('total (W)')
            
            # Group the power data into the correct scenario
            if freq in runtime_map and rt in runtime_map[freq]:
                scenario_name = runtime_map[freq][rt]
                try:
                    power_val = float(power_str)
                    scenarios_data[scenario_name][int(freq)] = power_val
                except ValueError:
                    # Skip rows where power is 'N/A' or missing
                    pass

    # Plotting the data
    frequencies = [100, 500, 1000]
    markers = ['o', 's', '^']
    colors = ['#1f77b4', '#ff7f0e', '#2ca02c']

    plt.figure(figsize=(10, 6))

    # Iterate through scenarios and plot a line for each
    for (scenario, data_dict), marker, color in zip(scenarios_data.items(), markers, colors):
        x_vals = []
        y_vals = []
        
        for f in frequencies:
            if f in data_dict:
                x_vals.append(f)
                y_vals.append(data_dict[f])
                
        if x_vals:
            plt.plot(x_vals, y_vals, marker=marker, color=color, label=scenario, linewidth=2, markersize=8)

    # Graph formatting
    plt.title('Evolução da Potência Total vs. Frequência', fontsize=14, fontweight='bold')
    plt.xlabel('Frequência (MHz)', fontsize=12)
    plt.ylabel('Potência Total (W)', fontsize=12)
    
    # Ensure the X-axis only shows our specific target frequencies
    plt.xticks(frequencies)
    
    # Add a grid for readability
    plt.grid(True, linestyle='--', alpha=0.7)
    plt.legend(fontsize=11)

    plt.tight_layout()
    
    # Save the graph as a PNG file
    plt.savefig(output_img_path, dpi=300)
    print(f"Graph successfully saved to {output_img_path}")

# Execute the function
if __name__ == "__main__":
    generate_power_graph('../CSVs/TL_results.csv', '../CSVs/grafico_potencia.png')
