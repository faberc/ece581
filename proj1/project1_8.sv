// Problem 8

// Chuck Faber

// Write an SV model for a combinational circuit with three inputs and one output.
// The output is 1 when the binary value of the inputs is less than 3. The outputs is 0 otherwise

// if !(|bits[N-1:2]) && !(bits[1]&&bits[0]) -> out = 1, else out = 0

module circuit (
    input [2:0] in,
    output logic out
    );

    always_comb begin
        out = in[2]|(in[1]&in[0]) ? 1'b0 : 1'b1;
    end

endmodule

module top();
    logic [2:0] in;
    logic out;

    circuit c(.*);

    initial begin
        for (int i = 0; i < 8; i++) begin
            in = i & 3'b111;
            #10;
            if (i < 3) assert(out == 1'b1);
            if (i >= 3) assert(out == 1'b0);
            `ifdef VERBOSE
            $display("in: %03b\tout: %01b", in, out);
            `endif
        end
    end

endmodule