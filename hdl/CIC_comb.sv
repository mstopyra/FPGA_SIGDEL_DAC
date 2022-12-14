// Implementation of a single comb stage of a CIC interpolation filter

module CIC_comb #(parameter int BITWIDTH = 32)(
    clk, rst, ena, in, out);

    input logic clk, rst, ena; 
    input wire [data_wide-1:0] in; 
    output wire [data_wide-1:0] out; 
    wire [data_wide-1:0] R; //Interpolation ratio data

    always_ff @(posedge clk) begin : comb_block

        if(rst) begin out <= 0; R <= 0; end

        if(ena) begin
            
            out <= R - in;
            R <= in;
             
        end

    end
endmodule

