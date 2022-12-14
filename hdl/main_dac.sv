module main_dac #(

    parameter CLK_HZ = 60_000_000,
    parameter int OSR = 1024, // OSR - oversampling rate
    parameter int CIC = 2, //CIC comb and integrator stages
    parameter int BITLEN = 16)

    (clk, rst, ena, in_DAC, in, out);

    //localparam CLK_CIC = ___;
    input wire in; 
    wire [BITLEN-1:0] in_DAC;
    input logic clk, rst;
    output bit out;

    wire pulse_40kHz;
    pulse_generator #(.N($clog2(CLK_HZ/1500))) PULSE_40kHz (
        .clk(clk), .rst(rst), .ena(1'b1), .out(pulse_40kHz),
        .ticks(CLK_HZ/1500)
    );
    
    //IP3 - research this 

    //FIR COMPENSATOR
    //ADD CODE HERE 

    //CIC INTERPOLATOR
    localparam int CIC_LEN = 1 + 1 + int((CIC * $clog2(OSR)));
    
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
        .clk(CLK_HZ),
        .rst(rst),
        .in_DAC(in_DAC), 
        .out(out)
    );