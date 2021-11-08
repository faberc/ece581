module bubble_sort (clk, reset, l_in, s_out);
parameter in = 4; //Number of inputs
parameter size = 3; //Size of the register
input clk;
input reset;
input [size-1:0] l_in;
output [size-1:0] s_out;

reg [size-1:0] s_out;

reg [size-1:0] reg_in [in-1:0]; //Input registers 
reg [size-1:0] reg_out [in-1:0]; // Output registers

always @(posedge clk) begin // if reset do not sort
  if(reset) begin
    for(i=0; i<in; i=i+1) reg_out[i] <= 32'd0;
    s_out <= 32'd0;
    s_sort <= 1'b0;
    sort_count <= 6'd0;
  end
  else if begin // two for loops to sort every swap condition
  for (j=in-1; j>=1; j=j-1) begin
    for (i=0; i<= in-2; i=i+1) begin
      if(reg_in[i] > reg_in[i+1]) begin //compare
        reg_in[i] <= reg_in[i+1]; // Swap
      end
      reg_out[i] <= reg_in[i]; //Transfering input reg value to output registers.
    end
  end
end
endmodule