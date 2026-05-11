import random
#01 03
#05 05
#02 FF

def dec2hex(num_dec):
	if num_dec < 10:
		return num_dec
	elif num_dec >= 10:
		if num_dec == 10:
			return 'A'
		elif num_dec == 11:
			return 'B'
		elif num_dec == 12:
			return 'C'
		elif num_dec == 13:
			return 'D'
		elif num_dec == 14:
			return 'E'
		elif num_dec == 15:
			return 'F'
			
output_vect_path = "../frontend/vetor.txt"
'''
with open(output_vect_path, 'w') as f:
	for i in range (1000):
		i_1 = dec2hex(random.randint(0, 15))
		i_2 = dec2hex(random.randint(0, 15))
		o_1 = dec2hex(random.randint(0, 15))
		o_2 = dec2hex(random.randint(0, 15))
		f.write(f"{i_1}{i_2} {o_1}{o_2}\n")
	
	f.write(f"FF FF\n")
	f.write(f"FF 00\n")
	f.write(f"00 FF\n")
	f.write(f"00 00\n")
'''

with open(output_vect_path, 'w') as f:
	for i in range (16):
		for j in range (16):
			for k in range (16):
				for l in range (16):
					i_1 = dec2hex(i)
					i_2 = dec2hex(j)
					o_1 = dec2hex(k)
					o_2 = dec2hex(l)
					f.write(f"{i_1}{i_2} {o_1}{o_2}\n")
	
	#f.write(f"FF FF\n")
	#f.write(f"FF 00\n")
	#f.write(f"00 FF\n")
	#f.write(f"00 00\n")

	
