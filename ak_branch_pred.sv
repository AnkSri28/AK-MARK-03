`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2022 05:35:44 PM
// Design Name: 
// Module Name: ak_branch_pred
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


module ak_branch_pred(
                    input clk,
                    input rst,
                    input branch_pred_en,
                    input [1:0] taken,
                    output reg prediction
                    );
////////////////////////////////////////
    reg pred_state;
////////////////////////////////////////
localparam WILL_NOT_HAPPEN = 2'd0;
localparam WILL_HAPPEN = 2'd1;
////////////////////////////////////////
    always @(posedge clk)begin
        if(rst)begin
            prediction <= 0;
        end
        else if(branch_pred_en)begin
            case(pred_state)
            WILL_NOT_HAPPEN:begin
                if(taken)begin
                    pred_state <= WILL_HAPPEN;
                end
                else begin
                    pred_state <= WILL_NOT_HAPPEN;
                end
            end
            WILL_HAPPEN:begin
                if(taken)begin
                    pred_state <= WILL_HAPPEN;
                end
                else begin
                    pred_state <= WILL_NOT_HAPPEN;
                end
            end
            endcase
        end
    end
endmodule
