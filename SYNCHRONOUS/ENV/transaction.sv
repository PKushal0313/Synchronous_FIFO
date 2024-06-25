`ifndef FIFO_TRANSACTION_SV
`define FIFO_TRANSACTION_SV 

//IMP POINT : there should be nothing feature specific in enum 

//typedef enum bit [1:0] {WRITE=1,READ} control; //functionality of FIFO 
//2'b01 : 'd1 : WRITE 
//2'b10 : 'd2 : READ

class transaction;

	//rand control ctrl_e;

	//Write port signals 
	rand bit wr_enb;
	rand bit [`WIDTH-1:0] wr_data;
	
	//Read port signals 
	rand bit rd_enb;
	bit [`WIDTH-1:0] rd_data;
	
	//output flags 
	bit full;
	bit empty;
	bit half;
	bit overflow;
	bit underflow;

	constraint functionality {soft wr_enb != rd_enb;}

	//overriding post_randomize method 
	/*function void post_randomize();
		$cast({rd_enb,wr_enb},ctrl_e);
	endfunction 
	*/

	function void disp(string name);
		$display("");
		$display("------------------------------------------");
		$display("                   %s                     ",name);
		$display("------------------------------------------");
    $display("|   Name    |     Data     |   Time   |" );
    $display("------------------------------------------");
    $display("| Wr_enb    |\t\t%3d\t\t|   %4t   |",this.wr_enb,$time);
    $display("| Rd_enb    |\t\t%3d\t\t|   %4t   |",this.rd_enb,$time);
    $display("| Wr_data   |\t\t%3d\t\t|   %4t   |",this.wr_data,$time);
    $display("| Rd_data   |\t\t%3d\t\t|   %4t   |",this.rd_data,$time);
    $display("| full      |\t\t%3d\t\t|   %4t   |",this.full,$time);
    $display("| empty     |\t\t%3d\t\t|   %4t   |",this.empty,$time);
    $display("| half      |\t\t%3d\t\t|   %4t   |",this.half,$time);
    $display("| overflow  |\t\t%3d\t\t|   %4t   |",this.overflow,$time);
    $display("| underflow |\t\t%3d\t\t|   %4t   |",this.underflow,$time);
    $display("------------------------------------------");
	endfunction 

endclass 

`endif 
