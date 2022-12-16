from math import sin, pi

NUM_SECS = 5
SAMPLE_RATE = 40000
SINE_FREQUENCY = 440
AMPLITUDE = 6500

def sine_wave(A, f, t):
    
    return A*sin(2*pi*f*t)

def gen_values(amplitude, secs, sampleRate, frequency):

    with open('sinewave.memh', 'w') as memfile:
        for i in range(0, secs * sampleRate):
            val = int(sine_wave(amplitude, frequency, (i/sampleRate)))
            if val >= 0:
                bits = f'{val:016b}'
            else:
                reversed_val = ((2**16)+val)
                bits = f'{reversed_val:016b}'
            memfile.write(f'{bits},\n')


if __name__ == "__main__":
    gen_values(AMPLITUDE, NUM_SECS, SAMPLE_RATE, SINE_FREQUENCY)
