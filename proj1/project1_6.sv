// Problem 6

// Chuck Faber

// Write a comparator compares the magnitude of two n-bit binary operands
// 

/////////////////////////////////////////////////////////////////////////////////
// Problem 6a. Write the SV code for a 16-bit comparator in the dataflow model //
/////////////////////////////////////////////////////////////////////////////////

module comparator_df #(parameter N = 16) (
    output logic out,
    input [N-1:0] a, b
    );

    assign out = &(~(a^b));

endmodule

////////////////////////////////////////////////////////////////////////////////////
// Problem 6b. Write the SV code for a 16-bit comparator in the algorithmic model //
////////////////////////////////////////////////////////////////////////////////////

module comparator_alg #(parameter N = 16) (
    output logic out,
    input [N-1:0] a, b
    );


    always_comb begin
        out = 1'b1;
        for (int i = 0; i < N; i++) begin
            if (a[i] != b[i]) out = 1'b0;
        end
    end

endmodule

///////////////
// Testbench //
///////////////

module top();
    parameter N = 16;
    parameter nTESTS = 20;
    logic [N-1:0] a,b, mask={N{1'b1}};
    logic out_df, out_alg;
    int failure = 0;
    string s, s1;
    
    comparator_df #(N) cd (
        .out(out_df),
        .*
    );

    comparator_alg #(N) ca (
        .out(out_alg),
        .*
    );

    initial begin
        for(int i=0; i < nTESTS; i++) begin
            a = $random() & mask;
            b = $random() & mask;
            // randomly make some of the cases equal
            if ($random() & 1'b1) b = a;
            #10;
            a_df: assert(out_df == (a==b)) else begin
                failure++;
                $error("ERROR - a_df: a: %016b\tb: %016b\tExpected: %0b\tReceived: %0b", a, b, (a==b), out_df);
            end
            a_alg: assert(out_alg == (a==b)) else begin
                failure++;
                $error("ERROR - a_alg: a: %016b\tb: %016b\tExpected: %0b\tReceived: %0b", a, b, (a==b), out_alg);
            end
            `ifdef VERBOSE
            $display("%3d:\ta: %016b\tb: %016b\tExpected: %0b\tout_df: %0b\tout_alg: %0b", i, a, b, (a==b), out_df, out_alg);
            `endif
        end
        if (!failure) $display("SUCCESS: No failures were logged!");
        else $display("FAILURE: %0d errors were logged.", failure);
    end

endmodule