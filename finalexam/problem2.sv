module prob4(s_in, clk, rst, d_out);
input clk; // clk signal
input rst; // rst input
input s_in; // binary input
output logic [1:0] d_out; // output of the sequence detector

enum logic [1:0] {A=3'b001, B=3'b010, C=3'b100} cs, ns;

always_ff @(posedge clk, posedge rst) begin // handle reset
  if(rst==1)
    cs <= A;
  else
    cs <= ns;
  end

    always_comb @(cs, s_in) begin // go to next state
        unique case(cs)
            A: begin
                if(s_in==0) begin 
                    ns = A;
                    out = 2'b00;
                end else begin 
                    ns = B;
                    out = 2'b01;
                end
            end
            B: begin
                if(s_in==0) begin
                    ns = A;
                    out = 2'b01;
                end else begin 
                    ns = C;
                    out = 2'b10;
                end
            end
            C:begin
                if(s_in==0) begin 
                    ns = A;
                    out = 2'b01;
                end else begin
                    ns = C;
                    out = 2'b10;
                end
            end
            default:ns = A;
        endcase
    end
endmodule