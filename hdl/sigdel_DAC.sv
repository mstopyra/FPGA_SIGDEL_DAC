//This module is an implementation of a simple, first order sigma-delta D/A converter

module sigdel_dac #(parameter int BITLEN = 16)
    (clk, rst, in_DAC, out); 

    input wire [sig_len-1:0] in_DAC;
    input logic clk, rst;
    output bit out; 
    //Output is a 1 bit bitstream of pulses that makes up an analog signal
    logic [sig_len:0] add_sig=0;

    always_ff @(posedge clk) begin : sigdel_mod

        //Pulse-driven FF logic to construct analog signal
        add_sig <= add_sig[sig_len-1:0] + in_DAC;
        /*Signal is integrated and looped through a flipflop to find pulse voltage levels for analog signal from 
            digital, discrete pulse voltage values*/
        out <= add_sig[sig_len]; //One bit output of the most significant bit of the signed DAC signal

        if(rst) begin
            // DAC reset
            out <=0; 
            add_sig <=0;
        end 
        
    end

endmodule