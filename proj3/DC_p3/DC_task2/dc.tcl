# Fill with your directory path and library 
lappend search_path "/u/cfaber/Documents/ECE581/ece581/proj3/DC_p3/DC_task1"
set target_library "osu05_stdcells.db"
set link_library "osu05_stdcells.db"

## Run Script

read_verilog MY_DESIGN.v
current_design MY_DESIGN 
link
check_design

#write your timing constraints here
create_clock -period 3.0 [get_ports clk]
set_clock_latency -source -max 0.7 [get_clocks clk]
set_clock_latency -max 0.3 [get_clocks clk]
set_clock_uncertainty -setup 0.15 [get_clocks clk]
set_clock_transition 0.12 [get_clocks clk]
set_input_delay -max 0.45 -clock clk [get_ports data*]
set_output_delay -max 0.5 -clock clk [get_ports out1]
set_output_delay -max 2.04 -clock clk [get_ports out2]
set_output_delay -max 0.4 -clock clk [get_ports out3]
set_input_delay -max 0.3 -clock clk [get_ports Cin*]
set_output_delay -max 0.1 -clock clk [get_ports Cout]

check_timing
report_clock
report_timing

write_script -out my_design.wscr

write -format ddc -hier -out unmapped_design.ddc
exit
