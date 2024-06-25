regress: vlib vlog sim cover delete
vlib:
	vlib work
vlog:
	vlog -coveropt 3 +acc +cover ../RTL/design.v ../TEST/package.sv ../TOP/top.sv +incdir+../ENV +incdir+../TEST

sim:
	vsim -vopt -coverage top +SANITY_TEST -c -do "coverage save -onexit -directive -cvg -codeall test1.ucdb; run -all; exit"
	vsim -vopt -coverage top +FULL_TEST -c -do "coverage save -onexit -directive -cvg -codeall test2.ucdb; run -all; exit"
	vsim -vopt -coverage top +HALF_TEST -c -do "coverage save -onexit -directive -cvg -codeall test3.ucdb; run -all; exit"
	vsim -vopt -coverage top +OVERFLOW_UNDERFLOW_TEST -c -do "coverage save -onexit -directive -cvg -codeall test4.ucdb; run -all; exit"
	vsim -vopt -coverage top +BACK_TO_BACK_WRITE_READ_TEST -c -do "coverage save -onexit -directive -cvg -codeall test5.ucdb; run -all; exit"
	vsim -vopt -coverage top +FULL_EMPTY_FULL_EMPTY_TEST -c -do "coverage save -onexit -directive -cvg -codeall test6.ucdb; run -all; exit"
	vsim -vopt -coverage top +FULLW_HALFR_HALFW_FULLR_TEST -c -do "coverage save -onexit -directive -cvg -codeall test7.ucdb; run -all; exit"
	vsim -vopt -coverage top +SIMUL_WRITE_READ_TEST -c -do "coverage save -onexit -directive -cvg -codeall test8.ucdb; run -all; exit"

cover:	
	vcover merge fifo.ucdb test1.ucdb test2.ucdb test3.ucdb test4.ucdb test5.ucdb test6.ucdb test7.ucdb test8.ucdb

delete:	 
	del test1.ucdb test2.ucdb test3.ucdb test4.ucdb test5.ucdb test6.ucdb test7.ucdb test8.ucdb
	vcover report -html -details fifo.ucdb -htmldir FIFO_TESTs


