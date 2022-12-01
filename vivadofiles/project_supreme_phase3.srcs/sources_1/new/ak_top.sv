`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2022 10:09:26 AM
// Design Name: 
// Module Name: top_file
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


module top_file(
        input clk,
        input rst,
        input start
    );
    
    wire [7:0]a,b;
    wire [5:0]jmp_addr_pc;
    wire jmp_addr_pc_valid;
    reg [7:0] a_regd,b_regd;
    wire ready_inst,valid_inst;
    wire [7:0]out_data;
    reg pc_valid,pc_ready;
    wire [31:0]inst;
    reg [5:0]pc_beg;
    reg [5:0]pc_top;
    wire inst_done;
    reg pc_valid0, pc_valid1;
    
    aim d1(
        .clk(clk),
        .rst(rst),
        .inst(inst),
        .valid_inst1(valid_inst),
        .ready_inst(ready_inst),
        .pc(pc_top),
        .pc_valid(pc_valid1),
        .pc_ready(pc_ready)
    );
    
    akie a1(
        .clk(clk),
        .rst(rst),
        .inst(inst),
        .valid_inst(valid_inst),
        .ready_inst(ready_inst),
        .inst_done(inst_done),
        .jmp_addr_pc(jmp_addr_pc),
        .jmp_addr_pc_valid(jmp_addr_pc_valid)
    );
    always @(posedge clk)begin
        if(rst)begin
            pc_top <= 'd0; 
            pc_valid <= 1'd0;
        end
        else begin
            pc_valid <= 1'd0;
        if(start && ~inst_done)begin
            pc_valid <= 1;
            pc_top <= pc_beg;
        end
        else if(jmp_addr_pc_valid)begin
            pc_top <= jmp_addr_pc;
        end
        else if(inst_done && ~start)begin
            pc_top <= pc_top + 1'd1;
            pc_valid <= 1;
            end
        end 
     end
     always @(posedge clk)begin
        pc_valid0 <= pc_valid;
     end
     always @(posedge clk)begin
        pc_valid1 <= pc_valid0;
     end
    
endmodule