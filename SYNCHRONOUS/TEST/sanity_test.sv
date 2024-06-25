class sanity_test extends generator;
	
	int num_trans = no_transaction;

	virtual task run();
		$display("Testcase for sanity check strated at : %0t",$time);
		repeat(num_trans) begin 
			
				trans = new();
				if(!trans.randomize() with {trans.wr_enb == 1;}) begin 
					$error("Randomization Failed");
				end 
				super.put_and_wait();

				trans = new();
				if(!trans.randomize() with {trans.rd_enb == 1;}) begin 
					$error("Randomization Failed");
				end 
				super.put_and_wait();
		end 
		$display("Testcase for sanity check is completed at : %0t",$time);
	endtask 

endclass 
