`ifndef FIFO_MONITOR_SV 
`define FIFO_MONITOR_SV 

class monitor;

	virtual intf vintf; //handle of interface : virtual interface 
 
	transaction trans2; //handle of transaction class
	transaction trans_ref;

	//mailbox declaration
	//for transfer the information between monitor and reference model 
	mailbox #(transaction) mon_ref;

	//mailbox declaration 
	//for transfer the information between monitor and scoreboard
	mailbox #(transaction) mon_scr;

	//mailbox declaration 
	//for transfer the information from monitor to functional coverage 
	mailbox #(transaction) mon_funcov;

	//method to connect interface and both mailbox 
	function void connect(virtual intf vintf, mailbox #(transaction) mon_ref, mailbox #(transaction) mon_scr, mailbox #(transaction) mon_funcov);
		this.vintf = vintf;
		this.mon_ref = mon_ref;
		this.mon_scr = mon_scr;
		this.mon_funcov = mon_funcov;
	endfunction 
	
	task run();
		forever begin
			$display("Run method from MONITOR is started at : %0t",$time);
			trans2 = new(); //object of transaction class 
			@(vintf.mon_cb);
			
			//Passing the values which we get from the interface which is connected to the DUT
			if(vintf.mon_cb.wr_enb) begin 
				trans2.wr_enb = vintf.mon_cb.wr_enb;
				trans2.wr_data = vintf.mon_cb.wr_data;
				trans2.full = vintf.mon_cb.full;
				trans2.empty = vintf.mon_cb.empty;
				trans2.half = vintf.mon_cb.half;
				trans2.overflow = vintf.mon_cb.overflow;
				trans2.underflow = vintf.mon_cb.underflow;
			end 
			if(vintf.mon_cb.rd_enb) begin 
				trans2.rd_enb = vintf.mon_cb.rd_enb;
				trans2.rd_data = vintf.mon_cb.rd_data;
				trans2.full = vintf.mon_cb.full;
				trans2.empty = vintf.mon_cb.empty;
				trans2.half = vintf.mon_cb.half;
				trans2.overflow = vintf.mon_cb.overflow;
				trans2.underflow = vintf.mon_cb.underflow;
			end 

			//decoding enum ctrl_e based on the values of wr_enb and rd_enb
    	//$cast(trans2.ctrl_e,{trans2.rd_enb,trans2.wr_enb});
		
			trans2.disp("monitor");

			trans_ref = new trans2;

			mon_scr.put(trans_ref); //put the information into the mailbox between monitor and scoreboard 
			mon_ref.put(trans_ref); //put the information into the mailbox between monitor and reference model
			mon_funcov.put(trans_ref); //put the information into the mailbox between monitor and functional coverage class 
			$display("Run method from MONITOR is completed at : %0t",$time);
		end 
	endtask 

endclass 

`endif 
