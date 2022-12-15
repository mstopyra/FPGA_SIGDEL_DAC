//This module is an implementation of a simple, first order sigma-delta D/A converter

module sigdel_dac #(parameter int BITLEN = 16)
    (clk, rst, in_DAC, out); 

    input wire [BITLEN-1:0] in_DAC;
    input logic clk, rst;
    output bit out; 
    //Output is a 1 bit bitstream of pulses that makes up an analog signal
    logic [BITLEN:0] add_sig;

    always_ff @(posedge clk) begin : sigdel_mod

        if(rst) begin
            // DAC reset
            out <=0; 
            add_sig <=0;
        end 

        else begin

            //Pulse-driven FF logic to construct analog signal
            if (add_sig[BITLEN-1] == 1'b1) begin

                add_sig <= add_sig[BITLEN-1:0] + in_DAC - (2**15);
                out <= add_sig[BITLEN-1]; 

            else if(add_sig[BITLEN-1] == 1'b0) begin
                add_sig <= add_sig[BITLEN-1:0] + in_DAC + (2**15);
                /*Signal is integrated and looped through a flipflop to find pulse voltage levels for analog signal from 
                    digital, discrete pulse voltage values*/
                out <= add_sig[BITLEN-1]; //One bit output of pulse amplitude at 60MHz (most significant bit of the signed DAC output signal)
                
            end 
        end   
    end

endmodule