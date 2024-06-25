`ifndef FIFO_TOP_SV 
`define FIFO_TOP_SV 

`include "interface.sv"
`include "package.sv"
`include "../RTL/design.v"
import pkg::*;

module top;


	//clock and reset : global signals 
	bit clk = 1'b0;
  bit rstn;

	initial begin 
	forever #5 clk = ~clk;
	end 
	
	task reset_done();
		fork 
			forever@(reset_item_done) begin 
				reset();
			end 
		join_none 
	endtask 

	intf int_f(clk,rstn); //handle of interface 


	task reset();
		//@(posedge clk);
		rstn = 1'b0;
		reset_flag = 1;
		#DELAY;
		rstn = 1'b1;
		reset_flag = 0;
	endtask 


	test test_h; //handle of test class 

	synchronous_fifo DUT (.clk(clk),
						.rstn(int_f.rstn),
						.wr_enb(int_f.wr_enb),
						.wr_data(int_f.wr_data),
						.rd_enb(int_f.rd_enb),
						.rd_data(int_f.rd_data),
						.full(int_f.full),
						.empty(int_f.empty),
						.half(int_f.half),
						.overflow(int_f.overflow),
						.underflow(int_f.underflow)
						); //instanciate design code 
	
	task run_test();
		test_h.build();
		test_h.connect(int_f);
		test_h.run();
	endtask 
		
	initial begin
		test_h = new(); //object of test class 
		//test_h.connect(int_f); //call connect method from test class
			
			reset_done();
			-> reset_item_done;
			fork
				reset();	
				run_test(); //call run method from test class 
			join
		
		wait(counter == 0);
		#10;
		$finish;


	end 

	
endmodule 

`endif 

//
///////////////////////////////////////////////////////////////////////
//TODO CHANGES : 
// Add reset event for in between reset 
//
//////////////////////////////////////////////////////////////////////
