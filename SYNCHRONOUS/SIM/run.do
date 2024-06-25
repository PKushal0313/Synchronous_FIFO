vlib work
vlog ../RTL/design.v ../TEST/package.sv ../TOP/top.sv +incdir+../ENV +incdir+../TEST
vsim -voptargs=+acc  -coverage  work.top +FULL_EMPTY_FULL_EMPTY_TEST 
add wave -r /*
run -all 
