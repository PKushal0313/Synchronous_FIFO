`define DEPTH 16 //Depth of FIFO 
`define ADDR 4 //Address width 
`define WIDTH 8 //Data width 
module synchronous_fifo(input clk,
												input rstn,
												input wr_enb,
												input [`WIDTH-1:0] wr_data,
												input rd_enb,
												output reg [`WIDTH-1:0] rd_data,

												output reg full,
												output reg empty,
												output wire half,
												output reg overflow,
												output reg underflow
												);

reg [`WIDTH-1:0] fifo [`DEPTH-1:0]; 

reg [`ADDR-1:0] wr_ptr,rd_ptr; //read pointer and write pointer
reg wr_ptr_bit,rd_ptr_bit;

integer i;

//------------------------------RESET logic : reset is active low-----------------------------------------//
always@(posedge clk or negedge rstn) begin
	if(!rstn) begin 
		wr_ptr <= 4'd0;
		rd_ptr <= 4'd0;
		full <= 1'b0;
		empty <= 1'b1;
		rd_data <= 4'd0;
		wr_ptr_bit <= 1'b0;
		rd_ptr_bit <= 1'b0;
		for(i = 0; i < `DEPTH; i=i+1) begin
			fifo[i] <= 8'd0;
		end // forloop  
	end //if 
end //always 

//--------------- OVERFLOW | UNDERFLOW | HALF flag ---------------------------------------------------// 
//assign overflow = (wr_enb && full) ? 1'b1 : 1'b0;
//assign undeflow = (rd_enb && empty) ? 1'b1 : 1'b0;
assign half = ((((wr_ptr - rd_ptr) == (`DEPTH/2))) || ((rd_ptr - wr_ptr) == (`DEPTH/2))) ? 1'b1 : 1'b0;

//----------------------------------WRITE LOGIC------------------------------------------------------//
always@(posedge clk) begin 
	if(rstn) begin 
		if(wr_enb && !full) begin
			fifo[wr_ptr] <= wr_data;
			if(wr_ptr == `DEPTH-1) begin 
				wr_ptr_bit <= ~wr_ptr_bit;
				wr_ptr <= 4'd0;
			end //if 
			else begin 
				wr_ptr <= wr_ptr + 1'b1;
			end //else 
		end //if && 
	end //if rstn 
end //always 

//-----------------------------------FULL flag logic------------------------------------------------------//
always@(wr_ptr or rd_ptr or wr_ptr_bit or rd_ptr_bit) begin
		if((wr_ptr == rd_ptr) && (wr_ptr_bit != rd_ptr_bit)) begin 
			full = 1'b1;
		end //if 
		else begin  
			full = 1'b0;
		end //else 
end //always 

//----------------------------------------READ LOGIC-----------------------------------------------------------//
always@(posedge clk) begin
	if(rstn) begin 
		if(rd_enb && !empty) begin
			rd_data <= fifo[rd_ptr];
			if((rd_ptr == `DEPTH-1)) begin
				rd_ptr_bit <= ~rd_ptr_bit;
				rd_ptr <= 4'd0;
			end //if  
			else begin 
				rd_ptr <= rd_ptr + 1'b1;
			end //else 
		end //if &&
	end //if rstn 
end //always 

//------------------------------------EMPTY flag logic----------------------------------------------------------//
always@(*)begin
		if((wr_ptr == rd_ptr) && (wr_ptr_bit == rd_ptr_bit)) begin
			empty = 1'b1;
		end //if 
		else begin 
			empty = 1'b0;
		end //else 
end //always 

always@(*) begin
		if(wr_enb && full) begin
			overflow = 1'b1;
		end 
		else begin 
			overflow = 1'b0;
		end 

		if(rd_enb && empty) begin
			underflow = 1'b1;
		end 
		else begin 
			underflow = 1'b0;
		end 

end 

endmodule 
