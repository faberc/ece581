module prob2 (
    input D, E,
    output logic Q, nQ
);

    logic N;

    always_ff @(negedge E) begin
        N <= D;
    end

    always_ff @(posedge E) begin
        Q <= N;
    end

    assign nQ = !Q;

endmodule