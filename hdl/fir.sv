`timescale 1ns/1ps
`default_nettype none
`include "hdl/register.sv"
// Used a python script to generate this code, written by Ian eykamp and Lauren Xiong. Two classmates of ours. 
// Github link to their project: https://github.com/Laurenx618/Simple-DSP
//////////////////////////////////////////////////////////////////////////////////////
// This is the main Verilog hdl file automatically generated from filter.py
// The block diagram of the FIR filter we build can be accessed HERE(INSERT LINK)
//////////////////////////////////////////////////////////////////////////////////////

module fir(clk, rst, ena, sample, out);

    input wire clk, rst, ena;
    input wire [15:0] sample;
    output logic [35:0] out;


    ////// TAP COEFFICIENTS //////
    logic signed [15:0] tap0, tap1, tap2, tap3, tap4, tap5, tap6, tap7, tap8, tap9, tap10, tap11, tap12, tap13, tap14, tap15;
    always_comb tap0 = 16'sd2178;
    always_comb tap1 = 16'sd2834;
    always_comb tap2 = 16'sd3471;
    always_comb tap3 = 16'sd4060;
    always_comb tap4 = 16'sd4571;
    always_comb tap5 = 16'sd4979;
    always_comb tap6 = 16'sd5263;
    always_comb tap7 = 16'sd5409;
    always_comb tap8 = 16'sd5409;
    always_comb tap9 = 16'sd5263;
    always_comb tap10 = 16'sd4979;
    always_comb tap11 = 16'sd4571;
    always_comb tap12 = 16'sd4060;
    always_comb tap13 = 16'sd3471;
    always_comb tap14 = 16'sd2834;
    always_comb tap15 = 16'sd2178;


    ////// SAMPLE SHIFT REGISTER //////
    logic signed [15:0] buf0, buf1, buf2, buf3, buf4, buf5, buf6, buf7, buf8, buf9, buf10, buf11, buf12, buf13, buf14, buf15;
    register #(.N(16)) buffer0(.clk(clk), .ena(ena), .rst(rst), .d(sample), .q(buf0));
    register #(.N(16)) buffer1(.clk(clk), .ena(ena), .rst(rst), .d(buf0), .q(buf1));
    register #(.N(16)) buffer2(.clk(clk), .ena(ena), .rst(rst), .d(buf1), .q(buf2));
    register #(.N(16)) buffer3(.clk(clk), .ena(ena), .rst(rst), .d(buf2), .q(buf3));
    register #(.N(16)) buffer4(.clk(clk), .ena(ena), .rst(rst), .d(buf3), .q(buf4));
    register #(.N(16)) buffer5(.clk(clk), .ena(ena), .rst(rst), .d(buf4), .q(buf5));
    register #(.N(16)) buffer6(.clk(clk), .ena(ena), .rst(rst), .d(buf5), .q(buf6));
    register #(.N(16)) buffer7(.clk(clk), .ena(ena), .rst(rst), .d(buf6), .q(buf7));
    register #(.N(16)) buffer8(.clk(clk), .ena(ena), .rst(rst), .d(buf7), .q(buf8));
    register #(.N(16)) buffer9(.clk(clk), .ena(ena), .rst(rst), .d(buf8), .q(buf9));
    register #(.N(16)) buffer10(.clk(clk), .ena(ena), .rst(rst), .d(buf9), .q(buf10));
    register #(.N(16)) buffer11(.clk(clk), .ena(ena), .rst(rst), .d(buf10), .q(buf11));
    register #(.N(16)) buffer12(.clk(clk), .ena(ena), .rst(rst), .d(buf11), .q(buf12));
    register #(.N(16)) buffer13(.clk(clk), .ena(ena), .rst(rst), .d(buf12), .q(buf13));
    register #(.N(16)) buffer14(.clk(clk), .ena(ena), .rst(rst), .d(buf13), .q(buf14));
    register #(.N(16)) buffer15(.clk(clk), .ena(ena), .rst(rst), .d(buf14), .q(buf15));


    ////// LINEAR COMBINATION SAMPLES WITH TAPS //////
    logic signed [31:0] multiplied0, multiplied1, multiplied2, multiplied3, multiplied4, multiplied5, multiplied6, multiplied7, multiplied8, multiplied9, multiplied10, multiplied11, multiplied12, multiplied13, multiplied14, multiplied15;
    always_comb multiplied0 = buf0 * tap0;
    always_comb multiplied1 = buf1 * tap1;
    always_comb multiplied2 = buf2 * tap2;
    always_comb multiplied3 = buf3 * tap3;
    always_comb multiplied4 = buf4 * tap4;
    always_comb multiplied5 = buf5 * tap5;
    always_comb multiplied6 = buf6 * tap6;
    always_comb multiplied7 = buf7 * tap7;
    always_comb multiplied8 = buf8 * tap8;
    always_comb multiplied9 = buf9 * tap9;
    always_comb multiplied10 = buf10 * tap10;
    always_comb multiplied11 = buf11 * tap11;
    always_comb multiplied12 = buf12 * tap12;
    always_comb multiplied13 = buf13 * tap13;
    always_comb multiplied14 = buf14 * tap14;
    always_comb multiplied15 = buf15 * tap15;

    always_comb out = multiplied0 + multiplied1 + multiplied2 + multiplied3 + multiplied4 + multiplied5 + multiplied6 + multiplied7 + multiplied8 + multiplied9 + multiplied10 + multiplied11 + multiplied12 + multiplied13 + multiplied14 + multiplied15;

endmodule