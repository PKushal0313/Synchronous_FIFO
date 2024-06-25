`ifndef FIFO_SCOREBOARD_SV
`define FIFO_SCOREBOARD_SV 

//Macro to compare all the outputs 
`define compare_output(OP_REF,OP_MON) \
	if(OP_REF == OP_MON) \
		$display(`"Matched : reference model : %0d | monitor : %0d`",OP_REF,OP_MON); \
	else $display(`"MISMatched : reference model : %0d | monitor : %0d`",OP_REF,OP_MON); 

class scoreboard;
	transaction trans_ref; //handle of transaction class : to get information from refrence model 
	transaction trans_mon; //handle of transaction class : to get information from monitor 

	//mailbox declaration :
	//for transfer information between monitor and scoreboard 
	mailbox #(transaction) mon_scr; 

	//mailbox declaration 
	//for transfer information between reference model and scoreboard 
	mailbox #(transaction) ref_scr;

	//method to coneect both mailbox 
	function void connect(mailbox #(transaction) mon_scr,mailbox #(transaction) ref_scr);
		this.mon_scr = mon_scr;
		this.ref_scr = ref_scr;
	endfunction 
	
	//TODO : Timeout should not be there 

	//method to compare the expected output receiving from reference model and actual output receiving from monitor 
	task compare(transaction trans_ref,transaction trans_mon);
		$display("Compare methos started at : %0t",$time);
		fork
			begin
					$display("--------------- rd_data_check ---------------");
					`compare_output(trans_ref.rd_data,trans_mon.rd_data);
					$display("--------------- full_check ---------------");
					`compare_output(trans_ref.full,trans_mon.full);
					$display("--------------- empty_check ---------------");
					`compare_output(trans_ref.empty,trans_mon.empty);
					$display("--------------- half_check ---------------");
					`compare_output(trans_ref.half,trans_mon.half);
					$display("--------------- overflow_check ---------------");
					`compare_output(trans_ref.overflow,trans_mon.overflow);
					$display("--------------- underflow_check ---------------");
					`compare_output(trans_ref.underflow,trans_mon.underflow);
			end 
			begin
				#30;
				$display("TIMEOUT");
			end 
		join_any
		disable fork;
		$display("Compare method completed at : %0t",$time);
	endtask 

	task run();
		forever begin
			$display("Run method from SCOREBOARD started at : %0t",$time);
			trans_ref = new();
			trans_mon = new();
			ref_scr.get(trans_ref);
			mon_scr.get(trans_mon);
			raise_objection("Scoreboard");
			compare(trans_ref,trans_mon);
			drop_objection("Scoreboard");
			$display("Run method from SCOREBOARD completed at : %0t",$time);
		end 
	endtask 
endclass 

`endif 
