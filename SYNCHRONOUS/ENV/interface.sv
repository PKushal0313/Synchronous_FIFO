`ifndef FIFO_INTERFACE_SV
`define FIFO_INTERFACE_SV 

`include "define.sv"

interface intf(input bit clk,input bit rstn);
	
	//declaration of write signals 
	logic wr_enb; //write enable 
	logic [`WIDTH-1:0] wr_data; //write data 

	//declaration of read signals 
	logic rd_enb; //read enable 
	logic [`WIDTH-1:0] rd_data; //read data

	//declaration of flags 
	logic full;
	logic empty;
	logic half;
	logic overflow;
	logic underflow;

	//clocking block for driver 
	//write enable, rear enable and write data as an input because it will pass to DUT through interface 
	//so it will be output of driver and input of DUT 
	clocking drv_cb @(posedge clk);
		default input #0 output #1;
		output wr_enb;
		output wr_data;
		output rd_enb;
		input full;
		input empty;
	endclocking 

	//clocking block for monitor 
	//All signals as an input because everything will be sampled by monitor 
	clocking mon_cb @(posedge clk);
		default input #0 output #1;
		input wr_enb;
		input wr_data;
		input rd_enb;
		input rd_data;
		input full;
		input empty;
		input half;
		input overflow;
		input underflow;
	endclocking 

	//modport for RTL to provide the direction accroding to the RTL 
	modport DRIVER (clocking drv_cb);

	//modport for TB to provide the direction according to the Testbench 
	modport MONITOR (clocking mon_cb);

endinterface 

`endif 
