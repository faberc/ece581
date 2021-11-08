// Problem 4
// 
// Chuck Faber
// 
// Given a 9 bit boolean vector M, write an SV model for the following:
// If the number of high bits in M equals the first digit of the PSU ID number
// of one member of your group, the detector output 1, else 0.
// 
// inputs: 
// logic[8:0] M
// int ID1, ID2;
// 
// if $countones(M) == (ID1 % 10) or $countones(M) == (ID2 % 10): out = 1, else out = 0
// 

// a. algorithmic model (always_comb) with detector having 10ns delay
// b. dataflow model (assign) with 10ns delay
// 
// Assumptions: all PSU IDs are 9 digits long. The first digit is the digit in the ones place

`timescale 1ns/1ns

// Algorithmic Model

module detector_alg (
    input [8:0] M,
    input unsigned [31:0] ID1, ID2,
    output logic out
);

    int ones=0;
    logic out_tmp;

    always_comb begin
        ones = 0;
        for (int i = 0; i < 9; i++) begin
            ones += M[i];
        end
        out_tmp = ((ones==ID1%10) || (ones==ID2%10)) ? 1'b1 : 1'b0;
    end

    assign #10 out = out_tmp;
endmodule

// Dataflow Model

module detector_df (
    input [8:0] M,
    input unsigned [31:0] ID1, ID2,
    output logic out
);

    logic [4:0] ones;
    logic [2:0] ms3, mid3, ls3;
    logic [1:0] ms3_cnt, mid3_cnt, ls3_cnt;

    assign ms3 = M[8:6];
    assign mid3 = M[5:3];
    assign ls3 = M[2:0];

    assign ms3_cnt[1] = (ms3[1]&ms3[0]) | (ms3[2]&!ms3[1]&ms3[0]) | (ms3[2]&ms3[1]&!ms3[0]);
    assign ms3_cnt[0] = (ms3[2]&!ms3[1]&!ms3[0]) | (!ms3[2]&!ms3[1]&ms3[0]) | (ms3[2]&ms3[1]&ms3[0]) | (!ms3[2]&ms3[1]&!ms3[0]);

    assign mid3_cnt[1] = (mid3[1]&mid3[0]) | (mid3[2]&!mid3[1]&mid3[0]) | (mid3[2]&mid3[1]&!mid3[0]);
    assign mid3_cnt[0] = (mid3[2]&!mid3[1]&!mid3[0]) | (!mid3[2]&!mid3[1]&mid3[0]) | (mid3[2]&mid3[1]&mid3[0]) | (!mid3[2]&mid3[1]&!mid3[0]);

    assign ls3_cnt[1] = (ls3[1]&ls3[0]) | (ls3[2]&!ls3[1]&ls3[0]) | (ls3[2]&ls3[1]&!ls3[0]);
    assign ls3_cnt[0] = (ls3[2]&!ls3[1]&!ls3[0]) | (!ls3[2]&!ls3[1]&ls3[0]) | (ls3[2]&ls3[1]&ls3[0]) | (!ls3[2]&ls3[1]&!ls3[0]);

    assign ones = ms3_cnt + mid3_cnt + ls3_cnt;
    assign #10 out = (ones == (ID1 % 10)) || (ones == (ID2 % 10));
endmodule

// Randomized Testbench (just for testing during development)

module top_rand();
    parameter nTESTS = 20;

    logic [8:0] M;
    int ID1, ID2;
    logic out_da, out_df;
    int failure=0;

    detector_alg da (
        .out(out_da),
        .*
    );
    detector_df dd (
        .out(out_df),
        .*
    );

    initial begin
        for (int i = 0; i < nTESTS; i++) begin
            M = $random() & 9'h1FF;
            ID1 = $urandom() % 1000000000;
            ID2 = $urandom() % 1000000000;
            #20;
            `ifdef VERBOSE
            $display("M: %09b\tID1: %09d\tID2: %09d\tExpected: %01b\tOUT_DA: %01b\tOUT_DF: %01b", M, ID1, ID2, ($countones(M)==ID1%10 || $countones(M)==ID2%10), out_da, out_df);
            `endif
            alg: assert ((out_da == ($countones(M)==ID1%10)) || (out_da == ($countones(M)==ID2%10))) else begin
                failure++;
                $display("ERROR: M: %09b\tID1: %09d\tID2: %09d\tExpected: %01b\tOUT_DA: %01b", M, ID1, ID2, ($countones(M)==ID1%10 || $countones(M)==ID2%10), out_da);
            end
            df: assert ((out_df == ($countones(M)==ID1%10)) || (out_df == ($countones(M)==ID2%10))) else begin
                failure++;
                $display("ERROR: M: %09b\tID1: %09d\tID2: %09d\tExpected: %01b\tOUT_DF: %01b", M, ID1, ID2, ($countones(M)==ID1%10 || $countones(M)==ID2%10), out_df);
            end
        end
    end

endmodule

// Project Specified Testbench

module top();
    logic [8:0] M;
    int ID1, ID2;
    logic out_da, out_df;
    int failure=0;
    int fd;

    detector_alg da (
        .out(out_da),
        .*
    );
    detector_df dd (
        .out(out_df),
        .*
    );

    initial begin
        // Open file in append mode
        fd = $fopen("./p1_4.log", "a");
        if (fd) 
            $display("File opened successfully.");
        else begin
            $display("File was not opened successfully.");
            $stop;
        end
    end

    initial begin
        ID1 = 985740900;                // Chuck's ID
        ID2 = $urandom() % 1000000000;  // Random ID
        $fdisplay(fd, "T(ns):\tID1: %09d\tID2: %09d", ID1, ID2);
        for (int i = 0; i < (2**9); i++) begin
            M = i & 9'h1FF;
            #15;
            $fdisplay(fd, "@%04t\tM: %09b\tOUT_ALG: %01b\tOUT_DF: %01b", $time, M, out_da, out_df);
            `ifdef VERBOSE
            $display("@%04t\tM: %09b\tID1: %09d\tID2: %09d\tExpected: %01b\tOUT_DA: %01b\tOUT_DF: %01b", $time, M, ID1, ID2, ($countones(M)==ID1%10 || $countones(M)==ID2%10), out_da, out_df);
            `endif
            alg: assert ((out_da == ($countones(M)==ID1%10)) || (out_da == ($countones(M)==ID2%10))) else begin
                failure++;
                $display("ERROR: M: %09b\tID1: %09d\tID2: %09d\tExpected: %01b\tOUT_DA: %01b", M, ID1, ID2, ($countones(M)==ID1%10 || $countones(M)==ID2%10), out_da);
            end
            df: assert ((out_df == ($countones(M)==ID1%10)) || (out_df == ($countones(M)==ID2%10))) else begin
                failure++;
                $display("ERROR: M: %09b\tID1: %09d\tID2: %09d\tExpected: %01b\tOUT_DF: %01b", M, ID1, ID2, ($countones(M)==ID1%10 || $countones(M)==ID2%10), out_df);
            end
        end
        $fclose(fd);
    end

endmodule