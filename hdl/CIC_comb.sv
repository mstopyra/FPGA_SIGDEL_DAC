// Implementation of a single comb stage of a CIC interpolation filter
`timescale 1ns/1ps

module CIC_comb #(parameter int BITWIDTH = 32)(
    clk, rst, ena, in, out);

    input clk, rst, ena; 
    input logic [BITWIDTH-1:0] in; 
    output logic [BITWIDTH-1:0] out; 
    logic [BITWIDTH-1:0] R; //Interpolation ratio data

    always_ff @(posedge clk) begin : comb_block

        if(rst) begin out <= 0; R <= 0; end

        if(ena) begin
            
            R <= in;
            out <= R - in;
             
        end

    end
endmodule

