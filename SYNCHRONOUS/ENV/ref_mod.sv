`ifndef FIFO_REFERENCE_MODEL_SV
`define FIFO_REFERENCE_MODEL_SV

class ref_model;

 	//signals of reference model
	bit [7:0] array_q [$:15]; //queue array of size 16 : 0 to 15 
	bit [`WIDTH-1:0] exp_rd_data; //expected read data 
	bit exp_full; //expected full flag 
	bit exp_empty; //expected empty flag 
	bit exp_half; //expected half flag 
	bit exp_underflow; //expected underflow flag 
	bit exp_overflow; //expected overflow flag 
	
	transaction trans3; //to get from the monitor 
	transaction trans4; //to put into the scoreboard 
		
	//mailbox declaration : 
	//for transfer information between monitor and reference model 
	mailbox #(transaction) mon_ref;

	//mailbox declaration :
	//for transfer information between reference model and scoreboard 
	mailbox #(transaction) ref_scr;

	//method to connect both mailbox 
	function void connect(mailbox #(transaction) mon_ref,mailbox #(transaction) ref_scr);
		this.mon_ref = mon_ref;
		this.ref_scr = ref_scr;
	endfunction 	

	//method to mimic the behaviour of dut 
	//reference model 
	function void predictor(transaction trans3);
		$display("Predictor started at : %0t",$time);
		
		if(reset_flag == 1'b0) begin
			// write operation : writing into queue : through push_front method  
			$display("reset flag : %0d : Recieved from if",reset_flag);
			if(trans3.wr_enb == 1'b1 && !exp_full) begin
				array_q.push_front(trans3.wr_data);
				$display("------------------------------ array_q after writing-------------------------------------------------------------");
		  	$info($sformatf("%2t | array_q : %0p",$time,array_q));
			end 

			// read opeartion : read from queue : through pop_back method 
			if(trans3.rd_enb == 1'b1 && !exp_empty) begin
			 exp_rd_data = array_q.pop_back();
				$display("------------------------------ array_q after reading-------------------------------------------------------------");
		  	$info($sformatf("%2t | array_q : %0p",$time,array_q));
			end
		end
		else begin
			 exp_rd_data = 'd0;
			 array_q.delete();
			 $display("reset flag : %0d : Recieved from else",reset_flag);
		end
		
		//------------------------------------------CHECK FLAGS---------------------------------------//
		if(array_q.size()==`DEPTH ) begin 
			exp_full = 1'b1;
		end 
		else begin 
			exp_full = 1'b0;
		end

		if(array_q.size()==0) begin
			exp_empty = 1'b1;
		end 
		else begin 
			exp_empty = 1'b0;
		end 
		
		if(array_q.size() == (`DEPTH/2)) begin
				exp_half = 1'b1;
		end 
		else begin 
				exp_half = 1'b0;
		end 
		 
		if((array_q.size() == `DEPTH) && (trans3.wr_enb == 1)) begin
			exp_overflow = 1'b1;
		end 
		else begin 
			exp_overflow = 1'b0;
		end 

		if((array_q.size() == 0) && (trans3.rd_enb == 1)) begin 
			exp_underflow = 1'b1;
		end 
		else begin
			exp_underflow = 1'b0;
		end 
		$display("size : %0d",array_q.size());	
		$display("Predictor completed at : %0t",$time);
 	endfunction 

 	task run();
		forever begin 
 			$display("Run method from SCOREBOARD started at : %0t",$time);	
			trans3 = new(); //object of transaction class which will get values from monitor through mailbox 
		
			$display("BEFORE GET");
			//get values from monitor through mailbox 
			mon_ref.get(trans3);
			$display("AFTER GET");	
		
			trans4 = new trans3; //shallow copy 
			$display(" tran4 before predictor %p",trans4);
				
			//call predictor method to generate expected output 
			predictor(trans4);
		
			//passing the expected output values to the object of transaction class
			//we are just overriding the value of rd_data with exp_rd_data : we can check that by putting any value in place of exp_rd_data 
			trans4.rd_data = exp_rd_data;
			trans4.full = exp_full;
			trans4.empty = exp_empty;
			trans4.half = exp_half;
			trans4.overflow = exp_overflow;
			trans4.underflow = exp_underflow;
			$display(" tran4 after predictor %p",trans4);

			//put values of expected output into the mailbox to pass it to scoreboard 
			ref_scr.put(trans4);
		
			trans4.disp("ref model");
			$display("Run method from SCOREBOARD completed at : %0t",$time);
		end 
endtask 

endclass 

`endif 
