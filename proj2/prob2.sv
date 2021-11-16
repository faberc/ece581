// Project 2 problem 2 sequence dectector
// this code designs a FSM designed to find the sequence "60" in BCD
// which is  0110 0000, it tests one bit at a time if a bit is not a match
// the output will be zero and the FSM will reset, stating not mathced.
// if the input matches the correct sequince the output will be a match.
// By chris Mersman and Chuck Faber

module Sequence_Detector(s_in, clk, rst, d_out);
input clk; // clk signal
input rst; // rst input
input s_in; // binary input
output logic d_out; // output of the sequence detector

enum logic [7:0] {s1='h00, s2='h01, s3='h03, s4='h06, s5='h0c, s6='h18, s7='h30, s8='h60} cs, ns;

always_ff @(posedge clk, posedge rst) begin // handle reset
  if(rst==1)
    cs <= s1;
  else
    cs <= ns;
  end

    always_ff @(cs, s_in) begin // go to next state
        case(cs)
            s1: begin
                if(s_in==1) ns <= s2;
                else ns <= s1;
            end
            s2: begin
                if(s_in==1) ns <= s3;
                else ns <= s1;
            end
            s3:begin
                if(s_in==0) ns <= s4;
                else ns <= s1;
            end
            s4:begin
                if(s_in==0) ns <= s5;
                else ns <= s1;
            end
            s5:begin
                if(s_in==0) ns <= s6;
                else ns <= s1;
            end
            s6:begin
                if(s_in==0) ns <= s7;
                else ns <= s1;
            end
            s7:begin
                if(s_in==0) ns <= s8;
                else ns <= s1;
            end
            s8:begin
                ns <= s1;
            end
            default:ns <= s1;
        endcase
    end

    always @(cs) begin
        case(cs)
        s1:       d_out = 0;
        s2:       d_out = 0;
        s3:       d_out = 0;
        s4:       d_out = 0;
        s5:       d_out = 0;
        s6:       d_out = 0;
        s7:       d_out = 0;
        s8:       d_out = 1;
        endcase
    end
endmodule

module top();

    parameter N = 10;

    logic s_in, clk, rst, d_out;
    logic [7:0] test_val;
    logic [N-1:0][7:0] test_stream;

    Sequence_Detector uut (.*);

    initial begin
        clk = 1'b0;
        forever #50 clk = ~clk;
    end

    initial begin

        for (int i = 0; i < N; i++) begin
            test_stream[i] = $random() & 8'hFF;
        end
        test_stream[4] = 8'b0110_0000;

        s_in = 1'b0;
        rst = 1'b1;
        repeat (2) @(negedge clk);
        rst = 1'b0;
        repeat (2) @(negedge clk);

        test_val = 8'b0110_0000;

        foreach(test_val[i]) begin
            s_in = test_val[i];
            repeat (1) @(negedge clk);
            $display("%0t\ts_in:%0b\td_out:%0b\t%0s", $time, s_in, d_out, d_out ? "Matched" : "Unmatched");
        end

        rst = 1'b1;
        repeat (2) @(negedge clk);
        rst = 1'b0;
        repeat (2) @(negedge clk);

        $display("\n\nTesting with stream of bits %0b", test_stream);

        foreach(test_stream[j]) begin
            for (int k=7; k >= 0; k--) begin
                s_in = test_stream[j][k];
                repeat (1) @(negedge clk);
                $display("%0t\ts_in:%0b\td_out:%0b\t%0s", $time, s_in, d_out, d_out ? "Matched" : "Unmatched");
            end
        end


        $finish();
    end
endmodule