module S1_BOOL_FSM (
    input clk, rst,
    output logic out
);

    logic [2:0] cs, ns;

    always_ff @(posedge clk, posedge rst) begin: seq_logic
        if (rst) cs <= 3'b111;
        else cs <= ns;
    end: seq_logic

    always_comb begin: next_state_logic
        // a1', a2', and a3' respectively
        ns[0] = !(cs[0]|cs[1]);
        ns[1] = !(cs[2]&(cs[2]|(cs[1]&cs[0])));
        ns[2] = cs[0] & (cs[1]|cs[2]);

    end: next_state_logic

    always_comb begin: output_logic
        out = !(cs[0]|cs[1]);
    end: output_logic

endmodule


module top ();
    logic clk, rst, out_0, out_1, out_2;

    initial begin
        clk = 1'b1;
        forever #50 clk = ~clk;
    end

    S1_BOOL_FSM s1_2 (
        .out(out_2),
        .*);

    initial begin
        rst = 1'b1;
        #100;
        rst = 1'b0;
        $display("Bool FSM Q: %03b  Out: %01b", s1_2.cs, out_2);
        #10

        repeat (50) @(negedge clk) begin
            $display("Bool FSM Q: %03b  Out: %01b", s1_2.cs, out_2);
        end
        $finish();

    end

endmodule





module S1_FSM (
    input clk, rst,
    output logic out
);

    logic [2:0] cs, ns;

    always_ff @(posedge clk, posedge rst) begin: seq_logic
        if (rst) cs <= 3'b000;
        else cs <= ns;
    end: seq_logic

    always_comb begin: next_state_logic
        case (cs)
            3'b000:  ns = 3'b011;
            3'b001:  ns = 3'b010;
            3'b010:  ns = 3'b010;
            3'b011:  ns = 3'b110;
            3'b100:  ns = 3'b001;
            3'b101:  ns = 3'b100;
            3'b110:  ns = 3'b000;
            3'b111:  ns = 3'b100;
            default: ns = 3'b000;
        endcase
    end: next_state_logic

    always_comb begin: output_logic
        if ((cs==3'b000) || (cs==3'b100)) out = 1'b1;
        else out = 1'b0;
    end: output_logic
endmodule