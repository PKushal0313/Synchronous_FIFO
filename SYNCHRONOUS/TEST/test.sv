`ifndef FIFO_TEST_SV
`define FIFO_TEST_SV

class test;
	
	virtual intf int_f; //handle of interface 
	
	env env_h = new(); //object of environment class 
	
	//testcases 
	sanity_test st_h;
	full_empty_test fet_h;
	half_test ht_h;
	overflow_underflow_test of_uf_h;
	full_empty_full_empty_test ft_et_h;
	fullw_halfr_halfw_fullr_test handle_h;
	Simul_write_read_test simul_wr_h;

	//method to build object 
	function void build();
		env_h.build(); //call build method of environment class to connect all components 
	endfunction 

	//connect interface with virtual interface 
	virtual function void connect(virtual intf int_f);
		$display("-----------------------------------------------------------------------------------------------------------------------");
		$display("                                            SANITY TEST                                                                ");
		$display("-----------------------------------------------------------------------------------------------------------------------");
		if($test$plusargs("SANITY_TEST")) begin
			no_transaction = 1;
			st_h = new();
			env_h.gen = st_h;
		end

		$display("-----------------------------------------------------------------------------------------------------------------------");
		$display("                                            	FULL TEST                                                                ");
		$display("-----------------------------------------------------------------------------------------------------------------------");
		if($test$plusargs("FULL_TEST")) begin
			no_transaction = 18;
			fet_h = new();
			env_h.gen = fet_h;
		end

		$display("-----------------------------------------------------------------------------------------------------------------------");
		$display("                                            	HALF TEST                                                                ");
		$display("-----------------------------------------------------------------------------------------------------------------------");
		if($test$plusargs("HALF_TEST")) begin
			no_transaction = 16;
			ht_h = new();
			env_h.gen = ht_h;
		end
		
		$display("-----------------------------------------------------------------------------------------------------------------------");
		$display("                                       OVERFLOW UNDERFLOW TEST                                                         ");
		$display("-----------------------------------------------------------------------------------------------------------------------");
		if($test$plusargs("OVERFLOW_UNDERFLOW_TEST")) begin
			no_transaction = 20;
			of_uf_h = new();
			env_h.gen = of_uf_h;
		end

		$display("-----------------------------------------------------------------------------------------------------------------------");
		$display("                                     BACK TO BACK WRITE READ TEST                                                      ");
		$display("-----------------------------------------------------------------------------------------------------------------------");
		if($test$plusargs("BACK_TO_BACK_WRITE_READ_TEST")) begin
			no_transaction = 15;
			st_h = new();
			env_h.gen = st_h;
		end
	
		$display("-----------------------------------------------------------------------------------------------------------------------");
		$display("                                     FULL EMPTY FULL EMPTY TEST                                                      ");
		$display("-----------------------------------------------------------------------------------------------------------------------");
		if($test$plusargs("FULL_EMPTY_FULL_EMPTY_TEST")) begin
			no_transaction = 16;
			ft_et_h = new();
			env_h.gen = ft_et_h;
		end

		$display("-----------------------------------------------------------------------------------------------------------------------");
		$display("                                     FULLW HALFR HALFW FULLR TEST                                                      ");
		$display("-----------------------------------------------------------------------------------------------------------------------");
		if($test$plusargs("FULLW_HALFR_HALFW_FULLR_TEST")) begin
			no_transaction = 16;
			handle_h = new();
			env_h.gen = handle_h;
		end
		
	
		$display("-----------------------------------------------------------------------------------------------------------------------");
		$display("                                            SIMUL WRITE READ TEST                                                      ");
		$display("-----------------------------------------------------------------------------------------------------------------------");
		if($test$plusargs("SIMUL_WRITE_READ_TEST")) begin
			no_transaction = 10;
			simul_wr_h = new();
			env_h.gen = simul_wr_h;
		end

		env_h.connect(int_f);
	endfunction 

	//env h1 = new(); //object of environment class 

	task run();
		//h1.connect(int_f); //call connect method from environment 
		env_h.run(); //call run method from environment 
	endtask 

endclass

`endif
