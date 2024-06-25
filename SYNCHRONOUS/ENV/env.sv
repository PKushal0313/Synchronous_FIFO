`ifndef FIFO_ENVIRONMENT_SV
`define FIFO_ENVIRONMENT_SV 

class env;

	//virtual interface 
	virtual intf vintf;
	
	driver drv; //handle of driver class 
	generator gen; //handle of generator class  
	monitor mon; //handle of monitor class 
	ref_model ref_mod; //handle of reference model class 
	scoreboard scr; //handle of scoreboard 
	func_covg funcov;

  //method to build objects of every component 
	function void build();
		this.drv = new(); //object of driver class 
		//this.gen = new(); //object of generator class 
		this.mon = new(); //object of monitor class 
		this.ref_mod = new(); //object of reference model class 
		this.scr = new(); //object of scoreboard 
		this.funcov = new();
	endfunction 

	//mailbox declaration : transfer information between generator and monitor  
	mailbox #(transaction) gen2drv = new();

	//mailbox declaration : transfer information between monitor and reference model 
	mailbox #(transaction) mon2ref = new();

	//mailobx declaration : transfer information between monitor and scoreboard	
	mailbox #(transaction) mon2scr = new();
	
	//mailbox declaration : transfer information between reference model and scoreboard 
	mailbox #(transaction) ref2scr = new();

	//mailbox declaration : transfer information from Monitor to functional coverage 
	mailbox #(transaction) mon2funcov = new();

	//connect all the mailbox and interface  
	function void connect (virtual intf int_f );
		this.vintf = int_f;
		gen.connect(gen2drv);
		drv.connect(vintf,gen2drv);
		mon.connect(vintf,mon2ref,mon2scr,mon2funcov);
		funcov.connect(vintf,mon2funcov);
		ref_mod.connect(mon2ref,ref2scr);
		scr.connect(mon2scr,ref2scr);
	endfunction 

	//method where all the run method are called from the components 
	task run();
		fork
			gen.run();
			drv.run();
			mon.run();
			funcov.run();
			ref_mod.run();
		  scr.run();
		join_any
	endtask 

endclass 

`endif 
