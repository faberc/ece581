// 4 bit binary gray code adder
// Component 1: 2 4-bit Gray 2 Binary Code Converters
// Component 2: 1 4-bit binary adder
// Component 3: 1 5-bit binary 2 gray code converter

// The G2B will convert both operands to binary
// It will feed them to the 4-bit binary adder
// The B2G converter will take the result and the CO and convert to gray code

module gray2bin #(parameter N = 4) (
    output logic [N-1:0] bin,
    input [N-1:0] gray
);

    always_comb begin
        bin[N-1] = gray[N-1];
        for (int i=N-2; i >= 0; i--) begin
            bin[i] = bin[i+1] ^ gray[i];
        end
    end
endmodule

module bin2gray #(parameter N = 4) (
    output logic [N-1:0] gray,
    input [N-1:0] bin
);

    genvar i;
    assign gray[N-1] = bin[N-1];
    generate
        for (i=N-2; i >= 0; i--) begin
            assign gray[i] = bin[i+1]^bin[i];
        end
    endgenerate

endmodule

module CLA_adder #(parameter nBITS = 4) (
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

module gray_adder #(parameter N=4) (
    output [N:0] result,
    input [N-1:0] in_A, 
    input [N-1:0] in_B
    );

    logic [N-1:0] A_bin;
    logic [N-1:0] B_bin;
    logic [N-1:0] sum;
    logic co;

    gray2bin #(N) g2b_A (
        .gray(in_A),
        .bin(A_bin)
    );
    gray2bin #(N) g2b_B (
        .gray(in_B),
        .bin(B_bin)
    );

    CLA_adder #(N) adder (
        .ain(A_bin),
        .bin(B_bin),
        .cin(1'b0),
        .sum(sum),
        .co(co)
    );

    bin2gray #(N+1) b2g (
        .bin({sum,co}),
        .gray(result)
    );

endmodule