//Implementation of a compensation filter used in our interpolation architecture
//We were having trouble with a good for this so this methood has been pulled from here: 
//https://dsp.stackexchange.com/questions/19584/how-to-make-cic-compensation-filter
//https://github.com/davemuscle/sigma_delta_converters/blob/master/rtl/fir_compensator.sv

module FIR_filter #(
    parameter int BITWIDTH = 32,
    //ALPHA is some value over 8 that represents the shift amount of the 7-tap, 7th order filter
    //Can be changed to fine tune the filter, setting this now to avoid spending
        // too much time calculating an alpha value for the filter.
    // H = (-alpha/2)*(n'' + n) + (1 - alpha) + (1-alpha) * n'
    parameter int ALPHA = 2)
    (clk, rst, ena, in, out);

    input wire [BITWIDTH -1:0] in; 
    input wire [BITWIDTH -1:0] out; elay;
    wire signed [BITWIDTH -1:0] delay_

    wire signed [BITWIDTH -1:0] d1, d2;
    wire signed [BITWIDTH -1:0] sum, delay;
    wire signed [BITWIDTH -1:0] delay_delay;
    wire signed [BITWIDTH -1:0] delay_mult;
    wire signed [BITWIDTH -1:0] sum_mult;

    always_comb begin : shift_mult

        int; i
        wire signed [BITWIDTH -1:0] a[2];
        wire signed [BITWIDTH -1:0] b[2];
        wire signed [BITWIDTH -1:0] c[2];
        wire signed [BITWIDTH -1:0] d[2];
        wire signed [BITWIDTH -1:0] e[2];

        d[0] = sum;
        d[1] = delay;

        //Filter shifts
        for(i=0; i<2; i = i+1) begin : FIR_shifts

            b[i] = 0;
            c[i] = 0;
            d[i] = 0;



        end
    end