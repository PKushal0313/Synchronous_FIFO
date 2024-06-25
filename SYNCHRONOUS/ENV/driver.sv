
`ifndef FIFO_DRIVER_SV
`define FIFO_DRIVER_SV

///////////////////////////////////////////////////////////////
//TODO :
//In every task first line should be display and last line should be display which will make debugging easy and get more clarification 
//then at which time particular task/function starts and at which time that task/function ends 
//Unnecessary spaces should not be there : remove all unnecessary spaces 
///////////////////////////////////////////////////////////////

class driver;

	virtual intf vintf; //handle of interface 
	
	transaction trans; //object of transaction class 

	mailbox #(transaction) gen2drv; //mailbox declaration 

	//method to connect mailbox 
	function void connect (virtual intf vintf,mailbox #(transaction) gen2drv);
		this.gen2drv = gen2drv;
		this.vintf = vintf;
	endfunction

	//method to get the information from the generator class 
//	task run();
//	 forever begin
//	 	$display("Run method from DRIVER started at : %0t",$time);
//		//trans = new(); //object of transaction class  : NO NEED OF THIS
//		gen2drv.get(trans); //get information from the mailbox 
//		raise_objection("Driver");
//		if(!vintf.rstn) begin 
//			initialization();
//		end 
//		wait (vintf.rstn)
//		drive_to_dut();
//		trans.disp("driver");
//		drop_objection("Driver");
//		$display("Run method from DRIVER completed at : %0t",$time);
//		-> item_done;
//	end 
//	endtask

	task run();
		forever begin
	 	$display("Run method from DRIVER started at : %0t",$time);
		gen2drv.get(trans); //get information from the mailbox 
		raise_objection("Driver");
			fork
				begin
						drive_to_dut();
				end
				begin
					wait(!vintf.rstn)
					initialization();
				end
			join_any
			disable fork;
			wait(vintf.rstn);
			trans.disp("driver");
			drop_objection("Driver");
			$display("Run method from DRIVER completed at : %0t",$time);
			-> item_done;
		end

	endtask

	task initialization();
		$display("Reset started at %0t",$time);
		vintf.drv_cb.wr_enb <= 1'b0;
		vintf.drv_cb.rd_enb <= 1'b0;
		vintf.drv_cb.wr_data <= 'd0;
		wait(vintf.rstn);
		$display("Reset completed at %0t",$time);
	endtask 

	//method to drive the input signals to DUT through interface 
	task drive_to_dut();
		@(vintf.drv_cb); 
		$display("Start driving to DUT at : %0t",$time);
		if(!vintf.drv_cb.full) begin
			vintf.drv_cb.wr_enb <= trans.wr_enb;
			vintf.drv_cb.wr_data <= trans.wr_data;
		end 
		if(!vintf.drv_cb.empty) begin 
			vintf.drv_cb.rd_enb <= trans.rd_enb;
		end 
		$display("Completed driving to DUT at : %0t",$time);
	endtask

endclass 

`endif 
