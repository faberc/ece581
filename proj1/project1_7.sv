// Project 1 Problem 7

// Chuck Faber

// Hamming Code Encoder and Decoder

// This implements an extended hamming code encoder
module hamming_enc #(
    parameter r = 4,            // Defines hamming(n,k) code
                                // r = 3: hamming(7,4); r = 4: hamming(15,11), etc.
    localparam n = 2**r-1,      // Block length including payload and parity bits
    localparam k = n-r          // Payload length
    ) (
    output logic [n:0] out,
    input  [k-1:0] in
);

    logic [k-1:0] in_tmp;
    logic [n:0] bit_vec = '0;   // Bit vector
    logic [r-1:0] ohv [r];      // One-hot Vector
    int ohv_idx = 0;
    logic parity, b;

    always_comb begin
        in_tmp = in;
        bit_vec = '0;
        ohv_idx = 0;

        // Create array of all possible onehot vectors in an R-bit value
        for (int i = 0; i < r; i++) ohv[i] = 1'b1 << i;
        // Populate the output vector
        for (int i = 1; i <= n; i++) begin
            if (i != ohv[ohv_idx]) begin
                // if the index isn't one of the parity spot
                // fill it with bit from payload 
                b = in_tmp[0];
                in_tmp = in_tmp >> 1;
                bit_vec[i] = b;
            end else begin
                // if it is a parity spot, skip it for now
                if (ohv_idx < (r-1)) ohv_idx++;
            end
        end

        // for each onehot vector find all indices which share a bit with this vector
        // and xor the values at these indices to calculate the parity of this collection
        // of bits from the payload
        foreach(ohv[i]) begin
            parity = 1'b0;
            for (int j = 1; j <= n; j++) begin
                if (j & ohv[i]) begin
                    parity = bit_vec[j] ^ parity;
                end
            end
            // store the parity bit in the correct parity location
            bit_vec[ohv[i]] = parity;
        end

        // Calculate overall parity bit and store in 0th location
        bit_vec[0] = ^bit_vec[n:1];
        out = bit_vec;
    end
endmodule

module hamming_dec #(
    parameter r = 3,            // Integer >= 2 that defines hamming code architecture
    localparam n = 2**r-1,      // Block length including payload and parity bits
    localparam k = n-r          // Payload length
    ) (
    output logic [k-1:0] out,
    input  [n:0] in
);

    logic [n:0] in_tmp;
    logic [k-1:0] out_tmp;
    logic [r-1:0] v = '0;
    logic [r-1:0] ohv [r];
    logic [r-1:0] ohv_idx, out_idx;

    always_comb begin
        in_tmp = in;
        out_tmp = '0;
        v = '0;

        // collect index of all bits whose value is 1 and xor them together
        for (int i = 0; i <= n; i++) if (in_tmp[i]) v = v ^ i;
        // if v is non-zero (error exists), flip in[v]. (error correction)
        if (v) in_tmp[v] = !in_tmp[v];
        // create onehot array of hamming index elements. ohv = (1, 2, 4, 8, etc.)
        for (int i = 0; i < r; i++) ohv[i] = 4'b0001 << i;
        // construct new vector removing the parity bits
        ohv_idx = 0;
        out_idx = 0;
        for (int i = 1; i <=n; i++) begin
            if (i == ohv[ohv_idx]) begin
                if (ohv_idx < r-1) ohv_idx++;
                continue;
            end else begin
                out_tmp[out_idx] = in_tmp[i];
                out_idx++;
            end
        end
        out = out_tmp;
    end
endmodule


// Test

module top ();
    parameter R = 4;
    parameter NTESTS = 20;
    localparam N = 2**R-1;
    localparam K = N - R;

    logic [K-1:0] in_e, out_d;
    logic [N:0] out_e, chk_out, out_e_orig;
    logic [K-1:0] in_mask = {K{1'b1}};
    int rand_idx, failure=0;
    string sN, sK, s1, s2;

    hamming_enc #(R) he (
        .in(in_e),
        .out(out_e)
    );

    hamming_dec #(R) hd (
        .in(out_e),
        .out(out_d)
    );

    hamming_enc #(R) he_chk (
        .in(out_d),
        .out(chk_out)
    );


    initial begin
        sN = $sformatf("%%0%0db", N+1);
        sK = $sformatf("%%0%0db", K);
        s1 = $sformatf("ENC: Payload\t: %s\t\tEncoded\t: %s", sK, sN);
        s2 = $sformatf("DEC: Encoded\t: %s\tPayload\t: %s", sN, sK);
        // in_e = 11'b1001110111;
        // #10;
        // $display(s1, in_e, out_e);
        // $display(s2, out_e, out_d);
        for (int i=0; i < NTESTS; i++) begin
            // generate input
            in_e = $random() & in_mask;
            #20;
            `ifdef VERBOSE
                $display(s1, in_e, out_e);
                $display(s2, out_e, out_d);
            `endif
            assert(out_d == in_e) else begin 
                $error("Encoding/Decoding Error"); 
                failure++;
            end
            assert(out_e == chk_out) else begin 
                $error("Decoding/Encoding Error"); 
                failure++;
            end

            // error injection
            out_e_orig = out_e;
            rand_idx = $urandom_range(K-1);
            out_e[rand_idx] = !out_e[rand_idx];
            #20;
            `ifdef VERBOSE
                $display("--Error Injection into Encoded Message--");
                $display(s2, out_e, out_d);
                $display(s1, out_d, chk_out);
                $display("\n");
            `endif
            assert(out_d == in_e) else begin 
                $error("Payload Error Correction Failure"); 
                failure++;
            end
            assert(out_e_orig == chk_out) else begin 
                $error("Encoded Message Correction Mismatch"); 
                failure++;
            end
        end

        if (!failure) $display("SUCCESS: No failures were logged!");
        else $display("FAILURE: %0d errors were logged.", failure);
    end
endmodule

