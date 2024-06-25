//writing data to every location in fifo and checking full flag 
//Then read data to check empty flag 
//Again writing data to every location in fifo again check ull flag 
//Then read data to check empty flag

class full_empty_full_empty_test extends generator;
	
	int num_trans = no_transaction;

	virtual task run();
		$display("Testcase for full write and then full read again full write and full read started at : %0t",$time);
		repeat(2) begin 
			
			repeat(num_trans) begin 
				trans = new();
				if(!trans.randomize() with {trans.wr_enb == 1;}) begin 
					$error("Randomization Failed");
				end 
				super.put_and_wait();
			end 

			repeat(num_trans) begin 
				trans = new();
				if(!trans.randomize() with {trans.rd_enb == 1;}) begin 
					$error("Randomization Failed");
				end 
				super.put_and_wait();
			end 
		->reset_item_done;
		end
		$display("Testcase for full write and then full read again full write and full read completed at : %0t",$time);
	endtask 

endclass 
