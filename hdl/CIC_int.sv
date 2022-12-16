// Implementation of a single integrator stage of a CIC interpolation filter
`timescale 1ns/1ps

module CIC_int#(parameter int BITWIDTH = 32)(
    clk, rst, ena, in, out);

    input clk, rst, ena; 
    input logic [BITWIDTH-1:0] in; 
    output logic [BITWIDTH-1:0] out; 

    always_ff @(posedge clk) begin : integrator

        if(rst) begin out <= 0; end

        if(ena) begin
            out <= out + in; 
        end

    end
endmodule