module prob4 (
    input clk,
    output logic [0:7] out
);

    always_ff @(posedge clk) begin
        out <= {((out[7] ^ out[5]) ^ out[4]) ^ out[3], out[0:6]};
    end

endmodule