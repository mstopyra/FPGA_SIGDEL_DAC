`timescale 1ns/1ps
`default_nettype none

module main_dac #(

    parameter CLK_HZ = 60_000_000,
    parameter SYS_CLK_PERIOD_NS = (1_000_000_000/SYS_CLK_HZ),
    parameter int OSR = 1024, // OSR - oversampling rate
    parameter int CIC = 2, //CIC comb and integrator stages
    parameter int BITLEN = 16)

    (clk, sysclk rst, ena, in_DAC, in, out);

    //localparam CLK_CIC = ___;
    input wire in; 
    wire [BITLEN-1:0] in_DAC;
    input wire clk, rst;
    input sysclk;
    output bit out;

    `ifdef SIMULATION
    assign clk = sysclk;
    `else 
    // This project wants a faster clock. The MMCME2 module is built in to the FPGA can can generate higher clock frequencies from a base clock. Check out [UG953](https://docs.xilinx.com/r/2021.2-English/ug953-vivado-7series-libraries/MMCME2_BASE) if you want to learn more about how this works.
    wire clk_feedback;
    MMCME2_BASE #(
      .BANDWIDTH("OPTIMIZED"),
      .CLKFBOUT_MULT_F(64.0), //2.0 to 64.0 in increments of 0.125
      .CLKIN1_PERIOD(SYS_CLK_PERIOD_NS),
      .CLKOUT0_DIVIDE_F(12.5), // Divide amount for CLKOUT0 (1.000-128.000).
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
    wire [BITLEN-1:0] out_sin

    sinegen sinsample()

    fir fircompensator(
        .clk(clk), 
        .rst(rst), 
        .ena(pulse_40kHz), 
        .sample(out_sin), 
        .out(0_CIC_comb_sig)
        );
    
    wire [CIC_LEN-1: 0] 0_CIC_comb_sig [CIC:0];
    wire [CIC_LEN-1: 0] 0_CIC_int_sig [CIC:0];

    wire [CIC_LEN-1: 0] 1_CIC_comb_sig [CIC:0];
    wire [CIC_LEN-1: 0] 1_CIC_int_sig [CIC:0];    
    
    wire [CIC_LEN-1: 0] 2_CIC_comb_sig [CIC:0];
    wire [CIC_LEN-1: 0] 2_CIC_int_sig [CIC:0];


    CIC_comb #(.BITWIDTH(CIC_LEN))
        comb_inst_1(
            .clk(clk),
            .rst(rst),
            .ena(pulse_40kHz), 
            .in(0_CIC_comb_sig), 
            .out(1_CIC_comb_sig)
        );

    CIC_comb #(.BITWIDTH(CIC_LEN))
        comb_inst_2(
            .clk(clk),
            .rst(rst),
            .ena(pulse_40kHz), 
            .in(1_CIC_comb_sig), 
            .out(2_CIC_comb_sig)
        );
    CIC_comb #(.BITWIDTH(CIC_LEN))
        comb_inst_3(
            .clk(clk),
            .rst(rst),
            .ena(pulse_40kHz), 
            .in(2_CIC_comb_sig), 
            .out(0_CIC_int_sig)
        );

    CIC_int #(.BITWIDTH(CIC_LEN))
        int_inst_1(
            .clk(clk),
            .rst(rst),
            .ena(pulse_40kHz), 
            .in(0_CIC_int_sig), 
            .out(1_CIC_int_sig)
        );

    CIC_int #(.BITWIDTH(CIC_LEN))
        int_inst_2(
            .clk(clk),
            .rst(rst),
            .ena(pulse_40kHz), 
            .in(1_CIC_int_sig), 
            .out(2_CIC_int_sig)
        );

    CIC_int #(.BITWIDTH(CIC_LEN))
        int_inst_3(
            .clk(clk),
            .rst(rst),
            .ena(pulse_40kHz), 
            .in(2_CIC_int_sig), 
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

