// Problem 2 
// 
// Chuck Faber
// 
// Write SV code for a 2^n to n priority encoder in
// 2a. dataflow model
// 2b. algorithmic model
// 
// inputs
// [2^n-1:0] in
// [n-1:0] out
// 
// set out = index of highest bit
// for i = 2**n to 0: if in[i], out= i. break;

// Part A - Dataflow Model

module priority_enc_df #(parameter N = 3) (
    input [2**N-1:0] in,
    output logic [N-1:0] out
    );

    function logic [N-1:0] pri(input logic [2**N-1:0] in);
        begin
            logic [N-1:0] out;
            for (int i = 0; i < 2**N; i++) begin
                out = in[i] ? i : out; 
            end
            return out;
        end
    endfunction

    assign out = pri(in);
endmodule

// Part B - Algorithmic Model

module priority_enc_alg #(parameter N = 3) (
    input [2**N-1:0] in,
    output logic [N-1:0] out
    );

    logic [N-1:0] mask = '1;

    always_comb begin
        for (int i = 0; i < 2**N; i++) begin
            if (in[i]) out = i & mask;
        end
    end

endmodule

// Testbench

module top();
    parameter N = 3;
    parameter nTESTS = 20;
    logic [2**N-1:0] in;
    logic [N-1:0] out_df, out_alg;

    priority_enc_df #(N) df (
        .out(out_df),
        .*
    );
    priority_enc_alg #(N) alg (
        .out(out_alg),
        .*
    );

    initial begin
        $display("2N+1 Sequential Tests");
        for (int i=0; i <= 2**N; i++) begin
            in = i;
            #10;
            $display("in: %08b\tout_df: %03b\tout_alg: %03b", in, out_df, out_alg);
        end

        $display("Randomized Tests");
        for (int i=0; i < nTESTS; i++) begin
            in = $random() & {2**N{1'b1}};
            #10;
            $display("in: %08b\tout_df: %03b\tout_alg: %03b", in, out_df, out_alg);
        end
    end
endmodule