//writing into entire fifo : check Full flag 
//Reading from fifo till fifo is half : check Half flag
//Write into fifo : as fifo is already Half so it will write into half fifo : 
//read from fifo : full read 
//full check 
//half check 
//overflow check 
//empty check 
//underflow check

class fullw_halfr_halfw_fullr_test extends generator;
	
	int num_trans = no_transaction;

	virtual task run();
		$display("Test case for full write then half read then half write then full read started at : %0t",$time);
		repeat(1) begin 
		
			//writing into entire fifo 
			repeat(num_trans) begin 
				trans = new();
				if(!trans.randomize() with {trans.wr_enb == 1;}) begin 
					$error("Randomization Failed");
				end 
				super.put_and_wait();
			end 

			//read from fifo till half of fifo 
			repeat(num_trans/2) begin 
				trans = new();
				if(!trans.randomize() with {trans.rd_enb == 1;}) begin 
					$error("Randomization Failed");
				end 
				super.put_and_wait();
			end 

			//write into fifo till half of fifo which has been read earlier 
			//so after this fifo will be full again 
			repeat(num_trans/2) begin 
				trans = new();
				if(!trans.randomize() with {trans.wr_enb == 1;}) begin
					$error("Randomization Failed");
				end 
				super.put_and_wait();
			end 
			
			//reading from entire fifo 
			repeat(num_trans) begin 
				trans = new();
				if(!trans.randomize() with {trans.rd_enb == 1;}) begin
					$error("Randomization Failed");
				end 
				super.put_and_wait();
			end 

		$display("Testcase for full write then half read then half write
		then full read completed at : %0t",$time);
		end 
	endtask 

endclass 
