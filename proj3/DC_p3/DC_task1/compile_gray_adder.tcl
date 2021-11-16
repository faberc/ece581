# Fill with your directory path and library 
lappend search_path "/u/cfaber/Documents/ECE581/ece581/proj3/DC_p3/DC_task1"
set target_library "osu05_stdcells.db"
set link_library "osu05_stdcells.db"


link

read_file -format sverilog gray_adder.sv
current_design gray_adder
compile
report_area
report_cell
report_power
write -format Verilog -hierarchy -output gray_adder.netlist
link
