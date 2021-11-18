# Fill with your directory path and library 
lappend search_path "/u/cfaber/Documents/ECE581/ece581/proj3/"
set target_library "osu05_stdcells.db"
set link_library "osu05_stdcells.db"


link

read_file -format sverilog prob2.sv
current_design FSM_B
compile
report_area
report_cell
report_power
write -format Verilog -hierarchy -output FSM_B.netlist
link
