`ifndef INCLUDE_REGISTER
`define INCLUDE_REGISTER

`timescale 1ns/1ps
`default_nettype none

//From Ian and Lauren 
//Project link: https://github.com/Laurenx618/Simple-DSP/blob/main/hdl/register.sv
/*
A synchronous register (batch of flip flops) with rst > ena.
*/

module register(clk, ena, rst, d, q);
parameter N = 1;
parameter RESET = 0; // Value to reset to.

input wire clk, ena, rst;
input wire [N-1:0] d;
output logic [N-1:0] q;

always_ff @(posedge clk) begin
  if (rst) begin
    q <= RESET;
  end
  else begin
    if (ena) begin
      q <= d;
    end
  end
end

endmodule

`endif // INCLUDE_REGISTER