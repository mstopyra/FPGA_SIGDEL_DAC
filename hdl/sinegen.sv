module sinegen (clk, sin);

    parameter SIZE = 1024; 
    parameter int BITLEN = 16;
    input clk; 
    output wire [BITLEN-1:0] sin;

    wire [BITLEN-1:0] rom_memory [SIZE-1:0];

    int i; 

    initial begin
        $readmemh("sine.mem", rom_memory);
        i=0;
    end

    always @(posedge clk) begin
        sin = rom_memory[i]; 
        i = i+1;

        if (i==SIZE) begin i = 0 end;
        
    end
   
endmodule