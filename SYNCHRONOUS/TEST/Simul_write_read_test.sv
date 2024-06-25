//writing into entire fifo and then reading from fifo
//full check 
//empty check 
//underflow check 
class Simul_write_read_test extends generator;
	
	int num_trans = no_transaction;

	virtual task run();
		$display("Testcase for simultaneous write read started at : %0t",$time);
		repeat(1) begin 
			
			repeat(4) begin 
				trans = new();
				if(!trans.randomize() with {trans.wr_enb == 1;}) begin 
					$error("Randomization Failed");
				end 
				super.put_and_wait();
			end 

		
			repeat(num_trans) begin 
					trans = new();
					if(!trans.randomize() with {trans.wr_enb == 1; trans.rd_enb == 1;}) begin 
						$error("Randomization Failed");
				end 
				super.put_and_wait();
			end

		end 
		$display("Testcase for simultaneous write read completed at : %0t",$time);
	endtask 

endclass 
