`timescale 1ns/1ps
`default_nettype none

module main_dac #(

    parameter CLK_HZ = 10_000_000,
    parameter SYS_CLK_PERIOD_NS = (1_000_000_000/CLK_HZ),
    parameter int OSR = 256, // OSR - oversampling rate
    parameter int CIC = 2, //CIC comb and integrator stages
    parameter int BITLEN = 16
    )

    (sysclk, in, out, buttons);

    input wire [1:0] buttons;
    input logic [BITLEN-1:0] in; 
    logic clk;
    input logic sysclk;
    output out;
    logic rst; 
    wire [BITLEN-1:0] in_DAC;

    //Setting reset button on fpga - designated in main.xdc
    always_comb rst = buttons[0];

    `ifdef SIMULATION
    assign clk = sysclk;
    `else 
    // This project wants a faster clock. The MMCME2 module is built in to the FPGA can can generate higher clock frequencies from a base clock. Check out [UG953](https://docs.xilinx.com/r/2021.2-English/ug953-vivado-7series-libraries/MMCME2_BASE) if you want to learn more about how this works.
    wire clk_feedback;
    MMCME2_BASE #(
      .BANDWIDTH("OPTIMIZED"),
      .CLKFBOUT_MULT_F(64.0), //2.0 to 64.0 in increments of 0.125
      .CLKIN1_PERIOD(SYS_CLK_PERIOD_NS),
      .CLKOUT0_DIVIDE_F(20), // Divide amount for CLKOUT0 (1.000-128.000).
      .DIVCLK_DIVIDE(1), // Master division value (1-106)
      .CLKOUT0_DUTY_CYCLE(0.5),.CLKOUT0_PHASE(0.0),
      .STARTUP_WAIT("FALSE") // Delays DONE until MMCM is locked (FALSE, TRUE)
    )
    MMCME2_BASE_inst (
        .CLKOUT0(clk),
        .CLKIN1(sysclk),
        .PWRDWN(0),
        .RST(buttons[1]),
        .CLKFBOUT(clk_feedback),
        .CLKFBIN(clk_feedback)
    );

    `endif // SIMULATION

    wire pulse_40kHz;
    pulse_generator #(.N($clog2(CLK_HZ/1500))) PULSE_40kHz (
        .clk(clk), .rst(rst), .ena(1'b1), .out(pulse_40kHz),
        .ticks(CLK_HZ/1500)
    );
    

    localparam int CIC_LEN = 1 + 1 + int'((CIC * $clog2(OSR)));

    wire [CIC_LEN-1:0] CIC_comb_sig_0;
    wire [CIC_LEN-1:0] CIC_int_sig_0;
    wire [CIC_LEN-1:0] CIC_comb_sig_1;
    wire [CIC_LEN-1:0] CIC_int_sig_1;   
    wire [CIC_LEN-1:0] CIC_comb_sig_2;
    wire [CIC_LEN-1:0] CIC_int_sig_2;

    triangle_generator #(.N(BITLEN))wavsample(.clk(clk), .rst(rst), .ena(1'b1), .out(in));

    fir fircompensator(
        .clk(clk), 
        .rst(rst), 
        .ena(pulse_40kHz), 
        .sample(in), 
        .out(CIC_comb_sig_0)
        );

//CIC INTERPLATOR
    CIC_comb #(.BITWIDTH(CIC_LEN))
        comb_inst_1(
            .clk(clk),
            .rst(rst),
            .ena(pulse_40kHz), 
            .in(CIC_comb_sig_0), 
            .out(CIC_comb_sig_1)
        );

    CIC_comb #(.BITWIDTH(CIC_LEN))
        comb_inst_2(
            .clk(clk),
            .rst(rst),
            .ena(pulse_40kHz), 
            .in(CIC_comb_sig_1), 
            .out(CIC_comb_sig_2)
        );
    CIC_comb #(.BITWIDTH(CIC_LEN))
        comb_inst_3(
            .clk(clk),
            .rst(rst),
            .ena(pulse_40kHz), 
            .in(CIC_comb_sig_2), 
            .out(CIC_int_sig_0)
        );

    CIC_int #(.BITWIDTH(CIC_LEN))
        int_inst_1(
            .clk(clk),
            .rst(rst),
            .ena(pulse_40kHz), 
            .in(CIC_int_sig_0), 
            .out(CIC_int_sig_1)
        );

    CIC_int #(.BITWIDTH(CIC_LEN))
        int_inst_2(
            .clk(clk),
            .rst(rst),
            .ena(pulse_40kHz), 
            .in(CIC_int_sig_1), 
            .out(CIC_int_sig_2)
        );

    CIC_int #(.BITWIDTH(CIC_LEN))
        int_inst_3(
            .clk(clk),
            .rst(rst),
            .ena(pulse_40kHz), 
            .in(CIC_int_sig_2), 
            .out(in_DAC)
        );
    //END CIC INTERPOLATOR

    sigdel_dac #(.BITLEN(BITLEN)) 
        dac_main(
        .clk(clk),
        .rst(rst),
        .in_DAC(in_DAC), 
        .out(out)
    );

endmodule