// ECE 581 Project 1 Problem 3

// Chuck Faber

// Create carry look ahead adders in two different models
// P_i = A_i ^ B_i
// G_i = A_i*B_i
// C_i+1 = G_i + P_i*C_i
// S_i = P_i ^ C_i

//////////////////////////////////////////////////////////////////////
// Problem 3a. Write code for a 32 bit CLA adder in dataflow model. //
//////////////////////////////////////////////////////////////////////

module CLA_adder #(parameter nBITS = 32) (
    output logic [nBITS-1:0] sum,
    output logic co,
    input logic [nBITS-1:0] ain, bin,
    input cin
);
    genvar i;

    wire [nBITS-1:0] P, G;
    wire [nBITS:0] C;

    assign C[0] = cin;
    assign co = C[nBITS];

    generate
        for (i=0; i<nBITS; i++) begin
            assign P[i] = ain[i] ^ bin[i];
            assign G[i] = ain[i] & bin[i];
        end

        for (i=0; i<nBITS; i++) begin
            assign sum[i] = P[i] ^ C[i];
            assign C[i+1] = G[i] | P[i]&C[i];
        end
    endgenerate

endmodule

/////////////////////////////////////////////////////
// Problem 3b. Write the CLA in algorithmic model. //
/////////////////////////////////////////////////////

module CLA_adder_alg #(parameter nBITS = 32) (
    output logic [nBITS-1:0] sum,
    output logic co,
    input logic [nBITS-1:0] ain, bin,
    input cin
);
    logic [nBITS-1:0] P, G;
    logic [nBITS:0] C;

    always_comb begin
        P = ain ^ bin;
        G = ain & bin;
        C[0] = cin;
        for (int i=0; i < nBITS; i++) begin
            C[i+1] = G[i] | (P[i] & C[i]);
        end
        sum = P ^ C[nBITS-1:0];
        co = C[nBITS];
    end

endmodule


// Test
module top ();
    parameter NTESTS = 20;
    logic [31:0] sum, ain, bin;
    logic co, cin;
    int failure = 0;

    CLA_adder_alg CLA1(.*);

    initial begin
        cin = 0;
        for (int i = 0; i < NTESTS; i++) begin
            ain = $random() & 32'hFFFFFFFF;
            bin = $random() & 32'hFFFFFFFF;
            cin = $random() & 1'h1;
            #10;
            `ifdef VERBOSE
                $display("ain=0x%08h  bin=0x%08h  cin=%01b. Expected: 0x%08h  Received: 0x%08h", ain, bin, cin, ain+bin+cin, sum);
            `endif
            assert (sum == (ain+bin+cin)) else begin
                failure++;
                $display("ERROR: \nain=%032b  \nbin=%032b  \ncin=%01b. \nExpected: %032b  \nReceived: %032b", ain, bin, cin, ain+bin+cin, sum);
            end
        end
        if (!failure) $display("SUCCESS: No errors occured in testing!");
        else $display("FAILURE: %0d/%0d mismatches occurred in testbench.", failure, NTESTS);
    end

endmodule