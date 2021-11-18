// Proj 2 Prob 1 FSM Boolean Expression Design
module S1_BOOL_FSM (
    input clk, rst,
    output logic out
);

    logic [3:0] cs, ns;

    always_ff @(posedge clk, posedge rst) begin: seq_logic
        if (rst) cs <= 4'b0000;
        else cs <= ns;
    end: seq_logic

    always_comb begin: next_state_logic
        ns[3] = (!cs[3]&!cs[2]) | (!cs[3]&cs[2]&!(cs[1]^cs[0])) | (cs[3]&cs[2]&(cs[1]^cs[0]));
        ns[2] = cs[3];
        ns[1] = cs[2];
        ns[0] = cs[1];
    end: next_state_logic

    always_comb begin: output_logic
        out = !cs[2] | cs[2]&!(cs[1]^cs[0]);
    end: output_logic

endmodule



// Testbench
module top ();
    logic clk, rst, out_0, out_1;

    initial begin
        clk = 1'b1;
        forever #50 clk = ~clk;
    end

    S1_BOOL_FSM s1_2 (
        .out(out_0),
        .*);

    initial begin
        rst = 1'b1;
        #100;
        rst = 1'b0;
        $display("Q: %04b  Out: %01b\t\tFSM Q: %04b  Out: %01b\t\tBool FSM Q: %04b  Out: %01b", s1_0.Q, out_0, s1_1.cs, out_1, s1_2.cs, out_2);
        #10

        repeat (50) @(negedge clk) begin
            $display("Q: %04b  Out: %01b\t\tFSM Q: %04b  Out: %01b\t\tBool FSM Q: %04b  Out: %01b", s1_0.Q, out_0, s1_1.cs, out_1, s1_2.cs, out_2);
        end
        $finish();

    end

endmodule