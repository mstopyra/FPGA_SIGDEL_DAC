import numpy as np
import matplotlib.pyplot as plot

len = 1024

f = 440
fs = 44100

t = np.arange(0, len, 1)
sinus = np.sin((2*np.pi*f/fs)*t)

sinus_mem = ',\n'.join(map(str, sinus)) 
#Put these files in rom to read from and make discrete on FPGA

#Plot to show generated values
plot.plot(t, sinus)
plot.title('Generated Sine wave')
plot.xlabel('Time')
plot.ylabel('Amplitude = sin(time)')
plot.grid(True, which='both')
plot.axhline(y=0)
plot.show()

