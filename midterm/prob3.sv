module moore_fsm (
    input in, rst, clk,
    output logic out
);

    typedef enum logic [2:0] {S0, S11, S12, S21, S22} states_t;
    states_t cs, ns;

    // sequential
    always_ff @(posedge clk, posedge rst) begin: sequential
        if (rst) cs <= S0;
        else cs <= ns;
    end: sequential

    // next state
    always_comb begin: next_state
        ns = cs;
        unique case (cs)
            S0: begin
                if (in) ns = S11;
                if (!in) ns = S21;
            end
            S11: begin
                if (in) ns = S12;
                if (!in) ns = S22;
            end
            S12: begin
                if (in) ns = S12;
                if (!in) ns = S22;
            end
            S21: begin
                if (in) ns = S11;
                if (!in) ns = S21;
            end
            S22: begin
                if (in) ns = S11;
                if (!in) ns = S21;
            end
            default: ns = cs;
        endcase
    end: next_state

    // output
    always_comb begin: output_logic
        ns = cs;
        unique case (cs)
            S0:  out = 'x;
            S11: out = 1'b0;
            S12: out = 1'b1;
            S21: out = 1'b0;
            S22: out = 1'b1;
            default: out = 'x;
        endcase
    end: output_logic

endmodule