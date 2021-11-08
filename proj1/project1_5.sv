// Problem 5

// Chuck Faber

// Binary to Gray Code
// for g[0] to g[n-1]
// and b[0] to b[n-1]
// g[n-1] = b[n-1]
// g[i] = b[i+1]^b[i], where i = n-2, n-3, ..., 0

module bin2gray #(parameter N = 8) (
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

////////////////////////////////////////////////////////
// Problem 5b. Write gray to binary code converter in //
// algorithmic model.                                 //
////////////////////////////////////////////////////////

// Gray code to Binary
// b[n-1] = g[n-1]
// b[i] = b[i+1] ^ g[i] where i = n-2, n-3, ..., 0

module gray2bin #(parameter N = 8) (
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

// Test

module top ();
    parameter N = 8;

    int failure=0;
    logic [N-1:0] bin_in, gray_out, bin_out;
    logic [N-1:0] mask = {N{1'b1}};
    string s, s1, s2;

    bin2gray #(N) b2g(
        .bin(bin_in),
        .gray(gray_out)
    );

    gray2bin #(N) g2b(
        .gray(gray_out),
        .bin(bin_out)
    );
    initial begin
        $display("\tBINARY\t\tGRAY CODE");
        for (int i=0; i < 2**N; i++) begin
            bin_in = i & mask;
            #10
            $display("%0d:\t%b\t%b", i, bin_in, gray_out);
            assert(bin_out == bin_in) else failure++;
        end
        if (!failure) $display("SUCCESS: No failures were logged!");
        else $display("FAILURE: %0d/%0d errors were logged.", failure, 2**N);
    end

endmodule

