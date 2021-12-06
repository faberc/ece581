

// Testbench
module top ();
    `timescale 1ns/10ps

    logic clk, rst, out_0;

    initial begin
        clk = 1'b1;
        forever #50 clk = ~clk;
    end

    S1_FSM s1_0 (
        .out(out_0),
        .*);

    initial begin
        rst = 1'b1;
        repeat (1) @(negedge clk);
        rst = 1'b0;
        $display("Bool FSM Q: %04b  Out: %01b", s1_0.cs, out_0);
        repeat (1) @(negedge clk);
        repeat (50) @(negedge clk) begin
            $display("Bool FSM Q: %04b  Out: %01b", s1_0.cs, out_0);
        end
        $finish();

    end

endmodule