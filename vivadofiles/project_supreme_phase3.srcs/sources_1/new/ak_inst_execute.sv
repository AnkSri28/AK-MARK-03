`define add 1 //000001
`define mov 2 //000010
`define movi 33 //100001
`define sub 3 //000011
`define mul 4 //000100
`define div 5 //000101
`define jmp 6 //000110
`define bjnz 14 //001110
`define addi 34
`define subi 35


module akie(
		input clk,
		input rst,
		input [31:0]inst,
		input valid_inst,
		output reg ready_inst,
		output reg inst_done,
		output reg [5:0]jmp_addr_pc,
		output reg jmp_addr_pc_valid);
////////////////////////////////////
reg [3:0] pipe_next;
reg [15:0] inst_reg;
reg [5:0] opcode;
reg [5:0] operation;
reg [31:0] opregs1,opregs2,opregout,opregout2;
////////////registers///////////////
reg [31:0]rg0;//nzcv flags
reg [31:0]rg1;
reg [31:0]rg2;
reg [31:0]rg3;
reg [31:0]rg4;
reg [31:0]rg5;
reg [31:0]rg6;
reg [31:0]rg7;
reg [31:0]rg8;
reg [31:0]rg9;
reg [31:0]rg10;
reg [31:0]rg11;
reg [31:0]rg12;
reg [31:0]rg13;
reg [31:0]rg14;
reg [31:0]rg15;
////////////////////////////////////
reg [31:0]imm_val;
reg regload;
////////////////////////////////////
////////divider regs////////////////
reg [31:0]divident;//a
reg [31:0]divisor;//b
wire [31:0]div_out;
wire div_out_valid;
reg [31:0]rem;
reg div_en;
////////////////////////////////////
/////////branch pred////////////////
reg branch_pred_en;
////////////////////////////////////

localparam FETCH = 4'd0;
localparam DECODE1 = 4'd1;
localparam DECODE_EXTRA = 4'd2;
localparam DECODE2 = 4'd3;
localparam DECODE3 = 4'd4;
localparam EXECUTE = 4'd5;
localparam MEM_WRITE_MISC = 4'd6;
localparam MEM_WRITE = 4'd9;
localparam DONE = 4'd10;
/////////////////////////////////////
/////////////DIV PARAMETERS//////////
localparam DIVIDENT_OP = 2'd0;
localparam DIVISOR_OP = 2'd1;
localparam DIV_OUT_OP = 2'd2;
/////////////////////////////////////

always @(posedge clk) begin
	if(rst)begin
		ready_inst <= 0;
		operation <= 'd0;
		rg0 <= 'd0;
		rg1 <= 'd0;
		rg2 <= 'd0;
		rg3 <= 'd0;
		rg4 <= 'd0;
		rg5 <= 'd0;
		rg6 <= 'd0;
		rg7 <= 'd0;
		rg8 <= 'd0;
		rg9 <= 'd0;
		rg10 <= 'd0;
		rg11 <= 'd0;
		rg12 <= 'd0;
		rg13 <= 'd0;
		rg14 <= 'd0;
		rg15 <= 'd0;
		opregs1 <= 'd0;
		opregs2 <= 'd0;
		opregout <= 'd0;
		opcode <= 'd0;
		imm_val <= 'd0;
		regload <= 'd0;
		divident <= 'd0;
		divisor <= 'd0;
		div_en <=0;
	end
	else begin
	  case(pipe_next)
		FETCH:begin
		    inst_done <= 0;
		    ready_inst <= 1;
            if(valid_inst && ready_inst)begin
                inst_reg <= inst;
                opcode = inst[31:26];
                //source_reg1 <= inst[3:0];
                ready_inst <= 0;
                pipe_next <= DECODE1;
            end
            else begin
                pipe_next <= FETCH;
            end
           end
         DECODE1:begin
            case(opcode)
               `add:begin 
                  operation <= 6'd1;
                  pipe_next <= DECODE2;    
               end
               `mov:begin 
                   operation <= 6'd2;
                   pipe_next <= DECODE2;    
               end
               `sub:begin 
                   operation <= 6'd3;
                   pipe_next <= DECODE2;    
               end
               `mul:begin
                    operation <= 6'd4;
                    pipe_next <= DECODE2;
               end
               `div:begin
                    operation <= 6'd5;
                    div_en <= 1;
                    pipe_next <= DECODE2;
               end
              `jmp:begin
                    operation <= 6'd6;
                    pipe_next <= EXECUTE;
               end
               `bjnz:begin
                     operation <= 6'd14;
                     branch_pred_en <= 1;
                     pipe_next <= DECODE_EXTRA;
                end
               `movi:begin
                   operation <= 6'd33;
                   imm_val = {10'd0,inst[21:0]};
                   pipe_next <= EXECUTE;    
               end
               `addi:begin
                   operation <= 6'd34;
                   imm_val = {10'd0,inst[21:0]};
                   pipe_next <= DECODE_EXTRA;    
               end
               `subi:begin
                   operation <= 6'd35;
                   imm_val = {10'd0,inst[21:0]};
                   pipe_next <= DECODE_EXTRA;    
               end
               default:  
                  pipe_next <= DONE;       
              endcase 
           end
        DECODE_EXTRA:begin
               ready_inst <= 0;
               case(inst[25:22]) //output reg
                 4'b0000:begin opregout <= rg0;
                          pipe_next <= EXECUTE;
                          end
                 4'b0001: begin opregout <= rg1;
                          pipe_next <= EXECUTE;
                          end
                 4'b0010: begin opregout <= rg2;
                          pipe_next <= EXECUTE;
                          end
                 4'b0011: begin opregout <= rg3;
                          pipe_next <= EXECUTE;
                          end
                 4'b0100: begin opregout <= rg4;
                          pipe_next <= EXECUTE;
                          end
                 4'b0101: begin opregout <= rg5;
                          pipe_next <= EXECUTE;
                          end      
                 4'b0110: begin opregout <= rg6;
                          pipe_next <= EXECUTE;
                          end
                 4'b0111: begin opregout <= rg7;
                          pipe_next <= EXECUTE;
                          end
                 4'b1000: begin opregout <= rg8;
                          pipe_next <= EXECUTE;
                          end
                 4'b1001: begin opregout <= rg9;
                          pipe_next <= EXECUTE;
                          end
                 4'b1010: begin opregout <= rg10;
                          pipe_next <= EXECUTE;
                          end
                 4'b1011: begin opregout <= rg11;
                          pipe_next <= EXECUTE;
                          end
                 4'b1100: begin opregout <= rg12;
                          pipe_next <= EXECUTE;
                          end
                 4'b1101: begin opregout <= rg13;
                          pipe_next <= EXECUTE;
                          end
                 4'b1110: begin opregout <= rg14;
                          pipe_next <= EXECUTE;
                          end
                 4'b1111: begin opregout <= rg15;
                          pipe_next <= EXECUTE;
                          end          
                endcase
             end        
        DECODE2:begin
            ready_inst <= 0;
            case(inst[3:0]) //source reg 1
             4'b0000:begin opregs1 <= rg0;
                      pipe_next <= DECODE3; 
                      end
             4'b0001: begin opregs1 <= rg1;
                      pipe_next <= DECODE3;
                      end
             4'b0010: begin opregs1 <= rg2;
                      pipe_next <= DECODE3;
                      end
             4'b0011: begin opregs1 <= rg3;
                      pipe_next <= DECODE3;
                      end
             4'b0100: begin opregs1 <= rg4;
                      pipe_next <= DECODE3;
                      end
             4'b0101: begin opregs1 <= rg5;
                      pipe_next <= DECODE3;
                      end
             4'b0110: begin opregs1 <= rg6;
                      pipe_next <= DECODE3;
                      end
             4'b0111: begin opregs1 <= rg7;
                      pipe_next <= DECODE3;
                      end
             4'b1000: begin opregs1 <= rg8;
                      pipe_next <= DECODE3;
                      end
             4'b1001: begin opregs1 <= rg9;
                      pipe_next <= DECODE3;
                      end
             4'b1010: begin opregs1 <= rg10;
                      pipe_next <= DECODE3;
                      end
             4'b1011: begin opregs1 <= rg11;
                      pipe_next <= DECODE3;
                      end
             4'b1100: begin opregs1 <= rg12;
                      pipe_next <= DECODE3;
                      end
             4'b1101: begin opregs1 <= rg13;
                      pipe_next <= DECODE3;
                      end
             4'b1110: begin opregs1 <= rg14;
                      pipe_next <= DECODE3;
                      end
             4'b1111: begin opregs1 <= rg15;
                      pipe_next <= DECODE3;        
                      end  
            endcase
          end
         DECODE3:begin
           case(inst[7:4]) //source reg 2
           4'b0000: begin opregs2 <= rg0;
                    pipe_next <= EXECUTE; 
                    end
           4'b0001: begin opregs2 <= rg1;
                    pipe_next <= EXECUTE;
                    end
           4'b0010: begin opregs2 <= rg2;
                    pipe_next <= EXECUTE;
                    end
           4'b0011: begin opregs2 <= rg3;
                    pipe_next <= EXECUTE;
                    end
           4'b0100: begin opregs2 <= rg4;
                    pipe_next <= EXECUTE;
                    end
           4'b0101: begin opregs2 <= rg5;
                    pipe_next <= EXECUTE;
                    end
           4'b0110: begin opregs2 <= rg6;
                    pipe_next <= EXECUTE;
                    end
           4'b0111: begin opregs2 <= rg7;
                    pipe_next <= EXECUTE;
                    end
           4'b1000: begin opregs2 <= rg8;
                    pipe_next <= EXECUTE;
                    end
           4'b1001: begin opregs2 <= rg9;
                    pipe_next <= EXECUTE;
                    end
           4'b1010: begin opregs2 <= rg10;
                    pipe_next <= EXECUTE;
                    end
           4'b1011: begin opregs2 <= rg11;
                    pipe_next <= EXECUTE;
                    end
           4'b1100: begin opregs2 <= rg12;
                    pipe_next <= EXECUTE;
                    end
           4'b1101: begin opregs2 <= rg13;
                    pipe_next <= EXECUTE;
                    end
           4'b1110: begin opregs2 <= rg14;
                    pipe_next <= EXECUTE;
                    end
           4'b1111: begin opregs2 <= rg15;
                    pipe_next <= EXECUTE;        
                    end  
          endcase
          end
    EXECUTE:begin
        case(operation)
         6'd1:begin //add
            {rg0[29],opregout} <= opregs1 + opregs2;
            pipe_next <= MEM_WRITE;
         end
         6'd2:begin //mov
            opregs2 <= opregs1;
            pipe_next <= DONE;
                  end
         6'd3:begin //sub
             {rg0[29],opregout} <= opregs1 - opregs2;
             pipe_next <= MEM_WRITE;
                  end
          6'd4:begin //mul
             {opregout,opregout2} <= opregs1 * opregs2;
             pipe_next <= MEM_WRITE_MISC;
                  end
          6'd5:begin
             divident <= opregs1;
             divisor <= opregs2;
             if(div_out_valid)begin
                 opregout <= div_out;
                 div_en <= 0;
                 opregout2 <= rem;
                 pipe_next <= MEM_WRITE_MISC;
              end
             end
          6'd6:begin
            jmp_addr_pc <= inst[5:0];
            jmp_addr_pc_valid <= 1;
            pipe_next <= DONE;
          end
          6'd14:begin
            if(~rg0[30])begin
               jmp_addr_pc <= inst[5:0];
               jmp_addr_pc_valid <= 1;
               pipe_next <= DONE;
            end
            else begin
               pipe_next <= DONE;
            end
          end
          6'd33:begin
             opregout <= imm_val;
             pipe_next <= MEM_WRITE;
          end
          6'd34:begin
             opregout <= opregout + imm_val;
             pipe_next <= MEM_WRITE;
          end
          6'd34:begin
             opregout <= opregout - imm_val;
             pipe_next <= MEM_WRITE;
          end
        endcase
    end
    MEM_WRITE_MISC:begin
    case(inst[21:18]) //output reg2
      4'b0000:begin rg0 <= opregout2;
               pipe_next <= MEM_WRITE;
               end
      4'b0001: begin rg1 <= opregout2;
               pipe_next <= MEM_WRITE;
               end
      4'b0010: begin rg2 <= opregout2;
               pipe_next <= MEM_WRITE;
               end
      4'b0011: begin rg3 <= opregout2;
               pipe_next <= MEM_WRITE;
               end
      4'b0100: begin rg4 <= opregout2;
               pipe_next <= MEM_WRITE;
               end
      4'b0101: begin rg5 <= opregout2;
               pipe_next <= MEM_WRITE;
               end      
      4'b0110: begin rg6 <= opregout2;
               pipe_next <= MEM_WRITE;
               end
      4'b0111: begin rg7 <= opregout2;
               pipe_next <= MEM_WRITE;
               end
      4'b1000: begin rg8 <= opregout2;
               pipe_next <= MEM_WRITE;
               end
      4'b1001: begin rg9 <= opregout2;
               pipe_next <= MEM_WRITE;
               end
      4'b1010: begin rg10 <= opregout2;
               pipe_next <= MEM_WRITE;
               end
      4'b1011: begin rg11 <= opregout2;
               pipe_next <= MEM_WRITE;
               end
      4'b1100: begin rg12 <= opregout2;
               pipe_next <= MEM_WRITE;
               end
      4'b1101: begin rg13 <= opregout2;
               pipe_next <= MEM_WRITE;
               end
      4'b1110: begin rg14 <= opregout2;
               pipe_next <= MEM_WRITE;
               end
      4'b1111: begin rg15 <= opregout2;
               pipe_next <= MEM_WRITE;
               end          
     endcase
    end
    MEM_WRITE:begin
    case(inst[25:22]) //output reg
      4'b0000:begin rg0 <= opregout;
               pipe_next <= DONE;
               end
      4'b0001: begin rg1 <= opregout;
               pipe_next <= DONE;
               end
      4'b0010: begin rg2 <= opregout;
               pipe_next <= DONE;
               end
      4'b0011: begin rg3 <= opregout;
               pipe_next <= DONE;
               end
      4'b0100: begin rg4 <= opregout;
               pipe_next <= DONE;
               end
      4'b0101: begin rg5 <= opregout;
               pipe_next <= DONE;
               end      
      4'b0110: begin rg6 <= opregout;
               pipe_next <= DONE;
               end
      4'b0111: begin rg7 <= opregout;
               pipe_next <= DONE;
               end
      4'b1000: begin rg8 <= opregout;
               pipe_next <= DONE;
               end
      4'b1001: begin rg9 <= opregout;
               pipe_next <= DONE;
               end
      4'b1010: begin rg10 <= opregout;
               pipe_next <= DONE;
               end
      4'b1011: begin rg11 <= opregout;
               pipe_next <= DONE;
               end
      4'b1100: begin rg12 <= opregout;
               pipe_next <= DONE;
               end
      4'b1101: begin rg13 <= opregout;
               pipe_next <= DONE;
               end
      4'b1110: begin rg14 <= opregout;
               pipe_next <= DONE;
               end
      4'b1111: begin rg15 <= opregout;
               pipe_next <= DONE;
               end          
     endcase
    end
    DONE:begin
        inst_done <= 1;
        jmp_addr_pc_valid <= 0;
        pipe_next <= FETCH;
    end
	default:begin
		pipe_next <= FETCH;
	end
   endcase
	end
end
///////////////internal module declaration/////////////////////////////////
ak_divider div1(
           .clk(clk),
           .rst(rst),
           .div_en(div_en),
           .a(divident),
           .b(divisor),
           .res(div_out),
           .rem(rem),
           .res_valid(div_out_valid)
                );
///////////////////////////////////////////////////////////////////////////
endmodule
		