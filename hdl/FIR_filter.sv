//Implementation of a compensation filter used in our interpolation architecture
//We were having trouble coming up with a good implementation for this, so this methood has been inspired by these two sources: 
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
        wire signed [BITWIDTH -1:0] shift_sum[2];

        d[0] = sum;
        d[1] = delay;

        //Filter shifts
        for(i=0; i<2; i = i+1) begin : FIR_shifts

            b[i] = 0;
            c[i] = 0;
            d[i] = 0;
                
            if((ALPHA % 2) ==1) begin
                b[i] = a[i] >>> 3;
            end
            if((ALPHA & 3) >= 2) begin
                c[i] = a[i] >>> 2;
            end
            if((ALPHA >= 4) >= 2) begin
                d[i] = a[i] >>> 1;
            end
            //Account for extreme cases then sum
            if(ALPHA == 0) begin
                shift_sum = 0
            end
            if(ALPHA == 8) begin
                shift_sum = sum
            end
            else begin
                shift_sum = b[i] + c[i] + d[i];
            end

        end
        sum_mult = shift_sum[0] >>> 1;
        delay_mult = shift_sum[1];
        delay_delay = a[1];

    end

    always_ff @(posedge clk) begin

        if(ena) begin 
            d1 <= in; 
            d2 <= d2; 
            sum <= d2 + in; 
            delay <= d1; 
            out <= ~sum_mult + 1 + delay_delay + delay_mult;
        end

        




