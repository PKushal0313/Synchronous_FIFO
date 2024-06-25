//writing into entire fifo and even more than size of FIFO to check overflow flag
//and then reading from fifo even more after FIFO is empty to check underflow 
//full check 
//half check 
//overflow check 
//empty check 
//underflow check

class overflow_underflow_test extends generator;
	
	int num_trans = no_transaction;

	virtual task run();
		$display("Testcase for underflow and overflow flag check started at : %0t",$time);
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
		$display("Testcase for underflow and overflow flag check completed at : %0t",$time);
		end 
	endtask 

endclass 
