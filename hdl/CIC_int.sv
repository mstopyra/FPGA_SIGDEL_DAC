// Implementation of a single integrator stage of a CIC interpolation filter

module CIC_int#(parameter int BITWIDTH = 32)(
    clk, rst, ena, in, out);

    input logic clk, rst, ena; 
    input wire [data_wide-1:0] in; 
    output wire [data_wide-1:0] out; 

    always_ff @(posedge clk) begin : integrator

        if(rst) begin out <= 0; end

        if(ena) begin
            out <= out + in; 
        end

    end
endmodule