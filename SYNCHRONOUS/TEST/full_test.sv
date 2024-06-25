//writing into entire fifo and then reading from fifo
//full check 
//empty check 
//underflow check 
class full_empty_test extends generator;
	
	int num_trans = no_transaction;

	virtual task run();
		$display("Testcase for full flag check is started at : %0t",$time);
		repeat(1) begin 
			
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
			$display("Testcase for full flag check completed at : %0t",$time);
		end 
	endtask 

endclass 
