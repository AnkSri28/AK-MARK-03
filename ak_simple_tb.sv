`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2022 11:19:55 AM
// Design Name: 
// Module Name: simple_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module simple_tb();
reg clk;
reg rst;
reg start;
//reg [31:0] mem [63:0];
//reg en;

top_file dut(
    .clk(clk),
    .rst(rst),
    .start(start)
    );         
    
always #5 clk = ~clk;

initial begin
    clk = 0;
    start = 0;
   /* #5  dut.d1.mem[0] = 32'b10000100111110000111100011001110;
        dut.d1.mem[1] = 32'b10000101001110000111100011001110;
        dut.d1.mem[2] = 32'b10000100101110000111100011001110;
        dut.d1.mem[3] = 32'b00000101110000000000000000110010;
        dut.d1.mem[4] = 32'b00000000000000000111111110000000; */
    #10 rst = 1;
    #15 rst = 0;
        dut.pc_beg <= 'd0;
    #20 start = 1;
    #10 start = 0;

     
     #1000 $finish; 
end      

endmodule