module aim(
	input clk,
	input rst,
	input ready_inst,
	input [5:0]pc,
	input pc_valid,
	output reg pc_ready,
	output reg valid_inst1,
	output reg [31:0] inst
);

localparam MEM_READ = 3'd0;
localparam MEM_WAIT = 3'd1;
localparam INST_SEND = 3'd2;
localparam STORE_MODE = 3'd3;

reg [1:0]drive_next;
reg [2:0]outreg_present;
reg [2:0]outreg_next;
wire eof;
reg [7:0]the_fake_val;
reg [31:0]mem;
reg ena;
reg rsta_buzy;
reg [31:0]inst_reg;
reg valid_inst;

blk_mem_gen_0 mem1(.clka(clk), 
                 .rsta(rst),
                 .ena(ena),
                 .addra(pc),
                 .douta(mem)
                 //.rsta_buzy(rsta_buzy)
                 );

always @(posedge clk)begin
	if(rst)begin
		inst <= 32'd0;
		valid_inst <= 1'b0;
		ena <= 0;
		pc_ready <= 0;
	end
	else begin
		   ena <= 1;
	case(outreg_next)
	   MEM_READ:begin
	       pc_ready <= 'd1;
	       if(pc_valid && pc_ready && mem[31:26] != 6'b111111)begin
	               outreg_next <= MEM_WAIT;
	               inst_reg <= mem;
	           end
	       else begin
	               outreg_next <= MEM_READ;
	       end
	   end
	   MEM_WAIT:begin
	       pc_ready <= 'd0;
	       valid_inst <= 'd1;
	       if(valid_inst && ready_inst)begin
	           inst <= inst_reg;
	           valid_inst <= 'd0;
	           outreg_next <= MEM_READ;
	       end
	       else begin
	           outreg_next <= MEM_WAIT;
	       end
	   end
	   default:begin
	       outreg_next <= MEM_READ;
	   end
	endcase
	end
end

always @(posedge clk)begin
    outreg_present <= outreg_next;
end
always @(posedge clk)begin
    valid_inst1 <= valid_inst;
end
endmodule