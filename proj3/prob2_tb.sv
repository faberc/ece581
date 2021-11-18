
module top();

    logic in, rst, clk, outA, outB, outC;
    logic [6:0] trace;

    FSM_A modelA (
        .out(outA),
        .*
    );

    FSM_B modelB (
        .out(outB),
        .*
    );

    FSM_C modelC (
        .out(outC),
        .*
    );

    initial begin: clock
        clk = 1'b1;
        forever #50 clk = ~clk;
    end: clock


    task resetFSM();
        // in = 1'bx;
        @(negedge clk) rst = 1'b1;
        @(negedge clk) rst = 1'b0;
        $display("\nResetting FSM.");
    endtask

    initial begin: testbench
        for (int i = 0; i < 2**7; i++) begin
            resetFSM();
            trace = i & 4'hF;
            $display($time, " Trace: %07b\tInput: %01b\tModelA State: %s   OutA: %01b\tModelB State: %s   OutB: %01b\tModelC State: %s   OutC: %01b", trace, in, modelA.cs.name(), outA, modelB.cs.name(), outB, modelC.cs.name(), outC);
            for (int j = 0; j < 7; j++) begin
                repeat (1) @(negedge clk);
                in = trace[j];
                repeat (1) @(negedge clk);
                    $display($time, " Trace: %07b\tInput: %01b\tModelA State: %s   OutA: %01b\tModelB State: %s   OutB: %01b\tModelC State: %s   OutC: %01b", trace, in, modelA.cs.name(), outA, modelB.cs.name(), outB, modelC.cs.name(), outC);
            end
        end
        $finish();
    end: testbench

endmodule