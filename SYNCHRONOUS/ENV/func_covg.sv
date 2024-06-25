`ifndef FIFO_FUNCTIONAL_COVERAGE_SV 
`define FIFO_FUNCTIONAL_COVERAGE_SV

class func_covg;

	transaction trans;

	virtual intf vintf;

	mailbox #(transaction) mon_funcov;

	function void connect(virtual intf vintf, mailbox #(transaction) mon_funcov);
		this.mon_funcov = mon_funcov;
		this.vintf = vintf;
	endfunction 

	covergroup cvg_grp;
		
		//coverpoint for write enable : Transition 
		coverpoint_wr_enb : coverpoint trans.wr_enb {
			
																									bins wr_toggle_0to1 = (0 => 1);
																									bins wr_toggle_1to0 = (1 => 0);

																								}

		//coveroint for read enable : Transition  
		coverpoint_rd_enb : coverpoint trans.rd_enb {
																									bins rd_toggle_0to1 = (0 => 1);
																									bins rd_toggle_1to0 = (1 => 0);
																								}
		//coverpoint for write data : in ranges : Low range, Mid range and High range  
		coverpoint_wr_data : coverpoint trans.wr_data {
																										bins range[3] = {[1:$]};
																									}
		
		//coverpoint for read data : in ranges : Low range, Mid range and High range 
		coverpoint_rd_data : coverpoint trans.rd_data {
																										bins range[3] = {[1:$]};
																									}

		//coverpoint full : Transition bin 
		coverpoint_full : coverpoint trans.full {
																							bins full_toggle[] = (0 => 1, 1 => 0);
																						}
		
		//coverpoint empty : Transition bin 
		coverpoint_empty : coverpoint trans.empty {	
																								bins empty_toggle[] = (0 => 1, 1 => 0);
																							}
		//coverpoint half : Transition bin 
		coverpoint_half : coverpoint trans.half {
																							bins half_toggle[] = (0 => 1, 1 => 0);
																						}
		
		//coverpoint overflow : Transition bin 
		coverpoint_overflow : coverpoint trans.overflow {
																											bins overflow_toggle[] = (0 => 1, 1 => 0);
																										}
		//coverpoint underflow : Trasition bin 	
		coverpoint_underflow : coverpoint trans.underflow {	
																												bins underflow_toggle[] = (0 => 1, 1 => 0);
																											}
		
		//coverpoint for enum : Implicit bin 
		//coverpoint_ctrl_e : coverpoint trans.ctrl_e;

		//coverpoint for reset 
		coverpoint_reset_check : coverpoint trans.rd_data iff(vintf.rstn == 0)
																	{	
																		bins rst_bin = {0};
																	}

		
		//coverpoint for back to back write read, back to back write(multiple write) and back to back read(multiple read)
		coverpoint_back2back : coverpoint {trans.wr_enb,trans.rd_enb} {
																											bins bck2bck_wr = (2'b10 => 2'b01);
																											bins bck2bck_w = (2'b10 => 2'b10);
																											bins bck2bck_r = (2'b01 => 2'b01);
																									 }
	
	endgroup 

	function new();
		cvg_grp = new();
	endfunction

	task run();
		forever begin 
			mon_funcov.get(trans);
			cvg_grp.sample();
		end
	endtask 

endclass 

`endif 
