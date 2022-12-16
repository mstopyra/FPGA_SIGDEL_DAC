/*
  Outputs a pulse generator with a period of "ticks".
  out should go high for one cycle ever "ticks" clocks.
*/
module pulse_generator #(parameter N = 8)
(clk, rst, ena, ticks, out);


input wire clk, rst, ena;
input wire [N-1:0] ticks;
output logic out;
logic [N-1:0] counter;

logic local_reset;

always_comb out = counter == ticks;


always_ff @(posedge clk) begin
  if(rst) begin
    counter <= 0;
  end else if(ena) begin
    counter <= out ? 0 : counter + 1;

  end
end

endmodule