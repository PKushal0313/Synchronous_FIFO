`ifndef FIFO_PACKAGE_SV 
`define FIFO_PACKAGE_SV

package pkg;
	parameter int DELAY = 20;
	event item_done;
	event reset_item_done;
	int no_transaction;
	static int counter;
	static int reset_flag;
	
	`include "transaction.sv"
	`include "generator.sv"
	`include "driver.sv"
	`include "monitor.sv"
	`include "func_covg.sv"
	`include "ref_mod.sv"
	`include "scoreboard.sv"
	`include "env.sv"

	//Testcases 
	`include "sanity_test.sv"
	`include "full_test.sv"
	`include "half_check.sv"
	`include "overflow_underflow_test.sv"
	`include "full_empty_full_empty_test.sv"
	`include "fullw_halfr_halfw_fullr_test.sv"
	`include "Simul_write_read_test.sv"

	`include "test.sv"


	//---------------------------------------------------------------------------------------------------------------------//
	//--------------- Raise objection and Drop objection method to avoid the hardcoded delay before $finish ---------------//
	//---------------------------------------------------------------------------------------------------------------------//


	//raise objection method which will increase the counter by 1 
	function void raise_objection(string name);
		counter++;
		$display("counter is incresed through raise objection from : %s : %0d",name,counter);
	endfunction

	//drop objection method which will decrease the counter by 1 
	function void drop_objection(string name);
		counter--;
		$display("counter is decread through drop objection from : %s : %0d",name,counter);
	endfunction 




endpackage

`endif 
