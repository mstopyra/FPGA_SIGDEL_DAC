import numpy as np
import matplotlib.pyplot as plot

len = 1024

f = 440
fs = 44100

t = np.arange(0, len, 1)
sinus = np.sin((2*np.pi*f/fs)*t)*1000

sinus = map(int, sinus)

sinus_mem = ',\n'.join(map(str, sinus)) 

with open('sinwave.mem', 'w') as file: 
    file.write(sinus_mem)\
#Put these files in rom to read from and make discrete on FPGA



#Plot to show generated values
#plot.plot(t, sinus)
#plot.title('Generated Sine wave')
#plot.xlabel('Time')
#plot.ylabel('Amplitude = sin(time)')
#plot.grid(True, which='both')
#plot.axhline(y=0)
#plot.show()

