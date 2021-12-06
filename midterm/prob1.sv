module c1_a (
    input A, B, C, D,
    output logic out
);

    wire W1, W2, W3, W4, W5, W6, W7;

    assign W1 = A | B;
    assign W2 = C | D;
    assign W3 = W1 & W2;
    assign W4 = W2 & W1;
    assign W5 = W2 | W1;
    assign W6 = W3 | W4;
    assign W7 = W3 & W5;
    assign out = W6 | W7;

endmodule
// reduces down to this
module c1_b (
    input A, B, C, D,
    output logic out
);

    // logic W1, W2, W3, W4, W5, W6, W7;

    always_comb begin
        // W1 = A | B;
        // W2 = C | D;
        // W3 = (A|B) & (C|D)
        // W4 = (A|B) & (C|D)
        // W5 = (A|B) | (C|D)
        // W6 = (A|B) & (C|D)
        // W7 = ((A|B) & (C|D)) & ((A|B) | (C|D))
        out = (A|B) & (C|D)
    end

endmodule