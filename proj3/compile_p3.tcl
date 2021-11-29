# Fill with your directory path and library 
lappend search_path "/u/cfaber/Documents/ECE581/ece581/proj3/"
set target_library "osu05_stdcells.db"
set link_library [concat "*" $target_library]
# set link_library "osu05_stdcells.db"


link

analyze -format sverilog prob3.sv
current_design gray_adder
elaborate gray_adder
# read_file -format sverilog prob3.sv
# current_design gray_adder
compile
report_area
report_cell
report_power
write -format Verilog -hierarchy -output prob3.netlist
link
