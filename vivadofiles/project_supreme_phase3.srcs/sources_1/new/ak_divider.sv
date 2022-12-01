`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2022 04:03:24 PM
// Design Name: 
// Module Name: ak_divider
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


module ak_divider(
                input clk,
                input rst,
                input div_en,
                input [31:0]a,
                input [31:0]b,
                output reg [31:0]res,
                output reg res_valid,
                output reg [31:0]rem
                );
    reg [31:0]a1,b1,q1,n1,count_reg;
    integer i;
    always @(posedge clk)begin
         if(rst)begin
            n1 <= 'd0;
         end
         else begin
            if(a >= b)begin
                n1 <= a;
            end
            else begin
                n1 <= b;
            end
         end
    end
    always @(posedge clk)
    begin
        if(rst || ~div_en)begin
           res <= 'd0;
           rem <= 'd0;
           res_valid <= 'd0;
           count_reg <= 'd0;
           a1 <= 0;
           b1 <= 0;
           q1 <= 0;
        end
        else if(div_en) begin
            //a1 <= a;
            b1 <= b;
            q1 <= a;
            res_valid <= 0;
           if(b != 0)begin
              for(i=0;i<n1;i=i+1)begin
                 if(q1 >= 'd0)begin
                    q1 <= q1 - b1;
                    count_reg <= count_reg + 'd1; 
                 end
                 else
                    res <= count_reg;
                    res_valid <= 'd1;
                    rem <= q1;
                 end
           end 
        end
    end

endmodule
