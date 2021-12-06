// Model A - Regular Case Statements and Binary State Encoding
module FSM_A (
    input in, rst, clk,
    output logic out
);
    typedef enum logic[2:0] {SA, SB, SC, SD, SE, SF, SG} states_t;
    states_t cs, ns;

    always_ff @(posedge clk or posedge rst) begin: seq_logic
        if (rst) cs <= SA;
        else cs <= ns;
    end: seq_logic

    always_comb begin: ns_logic
        unique case (cs)
            SA: ns = in ? SC : SD;
            SB: ns = in ? SF : SC;
            SC: ns = in ? SE : SG;
            SD: ns = in ? SF : SB;
            SE: ns = in ? SA : SD;
            SF: ns = in ? SG : SE;
            SG: ns = in ? SA : SD;
            default: ns = cs;
        endcase
    end: ns_logic

    always_comb begin: out_logic
        unique case (cs)
            SA: out = 1'b0;
            SB: out = 1'b1;
            SC: out = 1'b0;
            SD: out = 1'b1;
            SE: out = 1'b0;
            SF: out = 1'b1;
            SG: out = 1'b0;
            default: out = 1'bx;
        endcase
    end: out_logic

endmodule

// Model B - Regular Case Statements and One Hot Encoding
module FSM_B (
    input in, rst, clk,
    output logic out
);
    typedef enum logic[6:0] {
        SA = 7'b0000001, 
        SB = 7'b0000010, 
        SC = 7'b0000100, 
        SD = 7'b0001000, 
        SE = 7'b0010000, 
        SF = 7'b0100000, 
        SG = 7'b1000000
        } states_t;
    states_t cs, ns;

    always_ff @(posedge clk or posedge rst) begin: seq_logic
        if (rst) cs <= SA;
        else cs <= ns;
    end: seq_logic

    always_comb begin: ns_logic
        unique case (cs)
            SA: ns = in ? SC : SD;
            SB: ns = in ? SF : SC;
            SC: ns = in ? SE : SG;
            SD: ns = in ? SF : SB;
            SE: ns = in ? SA : SD;
            SF: ns = in ? SG : SE;
            SG: ns = in ? SA : SD;
            default: ns = cs;
        endcase
    end: ns_logic

    always_comb begin: out_logic
        unique case (cs)
            SA: out = 1'b0;
            SB: out = 1'b1;
            SC: out = 1'b0;
            SD: out = 1'b1;
            SE: out = 1'b0;
            SF: out = 1'b1;
            SG: out = 1'b0;
            default: out = 1'bx;
        endcase
    end: out_logic

endmodule

// Model C - Reversed Case Statement with One Hot Encoding
module FSM_C (
    input in, rst, clk,
    output logic out
);
    enum {A=0, B=1, C=2, D=3, E=4, F=5, G=6} states_idx;
    typedef enum logic [6:0] {
        SA = 7'b0000001 << A,
        SB = 7'b0000001 << B,
        SC = 7'b0000001 << C,
        SD = 7'b0000001 << D,
        SE = 7'b0000001 << E,
        SF = 7'b0000001 << F,
        SG = 7'b0000001 << G
    } states_t;
    states_t cs, ns;

    always_ff @(posedge clk or posedge rst) begin: seq_logic
        if (rst) cs <= SA;
        else cs <= ns;
    end: seq_logic

    always_comb begin: ns_logic
        unique case (1'b1)
            cs[A]: ns = in ? SC : SD;
            cs[B]: ns = in ? SF : SC;
            cs[C]: ns = in ? SE : SG;
            cs[D]: ns = in ? SF : SB;
            cs[E]: ns = in ? SA : SD;
            cs[F]: ns = in ? SG : SE;
            cs[G]: ns = in ? SA : SD;
            default: ns = cs;
        endcase
    end: ns_logic

    always_comb begin: out_logic
        unique case (1'b1)
            cs[A]: out = 1'b0;
            cs[B]: out = 1'b1;
            cs[C]: out = 1'b0;
            cs[D]: out = 1'b1;
            cs[E]: out = 1'b0;
            cs[F]: out = 1'b1;
            cs[G]: out = 1'b0;
            default: out = 1'bx;
        endcase
    end: out_logic

endmodule
