module sinegen(clk, sin, rst);

    parameter SIZE = 200000; 
    parameter int BITLEN = 16;
    input clk;
    input rst;
    output logic [BITLEN-1:0] sin;

    logic [BITLEN-1:0] rom_sample [SIZE-1:0];

    logic [63:0] i; 

    initial begin
        $readmemb("sinewave.memb", rom_sample);
        i=0;
    end

    always_ff @(posedge clk) begin

        sin <= rom_sample[i]; 
        i <= i+1;

    if(i == SIZE) begin 
            i <= 0;
        end
        
    end

endmodule