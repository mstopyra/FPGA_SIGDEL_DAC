`timescale 1ns / 1ps
`define SIMULATION

module test_main;

parameter CLK_HZ = 60_000_000;
parameter SYS_CLK_PERIOD_NS = (1_000_000_000/CLK_HZ); // Approximation.
parameter NUM_SAMPLES = 44100;
parameter int BITLEN = 16;
logic clk;
logic [1:0] buttons;

logic [BITLEN-1:0] in;
wire out;

main UUT (
    clk, in, out, buttons
);

logic [63:0] cycles = 0;
logic [63:0] cycles_to_run = CLK_HZ/100;
real progress = 0.0;

always #(CLK_PERIOD_NS/2) clk = ~clk;

initial begin
    $readmemh("memories/sinwave.mem", rom_sample);

    $dumpfile("main.fst");
    $dumpvars;
    $display("Running test main...");

    clk = 0;
    buttons = 2'b11; //using button[0] as reset.

    repeat(2) @(negedge clk);
    buttons = 2'b00;
    $display("Running for %d clock cycles. ", cycles_to_run);
    for(cycles = 0; cycles < cycles_to_run; cycles = cycles + 1) begin
    @(posedge clk);
    progress = cycles/(1.0*cycles_to_run);
  end

  repeat (cycles_to_run) @(posedge clk); 

  UUT.VRAM.dump_memory("vram.out");
  $finish;

end

always #500_000 $display("Test progress: %3.f%%", 100*progress);

endmodule