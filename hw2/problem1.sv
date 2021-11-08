module mooreFSM (
    input in, rst, clk,
    output logic [3:0] out
    );
    typedef enum logic [1:0] {S0, S1, S2, S3} states_t;
    states_t cs, ns;

    // Sequential Logic
    always_ff @(posedge clk, posedge rst) begin: set_ns
        if (rst) cs <= S0;
        else cs <= ns;
    end: set_ns

    // Next State Logic
    always_comb begin: ns_logic
        ns = cs;
        unique case (cs)
            S0: begin 
                if (in) ns = S1;
                if (!in) ns = S0;
            end
            S1: begin
                if (in) ns = S1;
                if (!in) ns = S2;
            end
            S2: begin
                if (in) ns = S3;
                if (!in) ns = S2;
            end
            S3: begin
                if (in) ns = S3;
                if (!in) ns = S0;
            end
            default: ns = cs;
        endcase
    end: ns_logic

    // Output Logic
    always_comb begin: output_logic
        unique case (cs)
            S0: out = 4'b0000;
            S1: out = 4'b1001;
            S2: out = 4'b1100;
            S3: out = 4'b1111;
            default: out = 'x;
        endcase
    end: output_logic

endmodule



module mealyFSM (
    input in, rst, clk,
    output logic [3:0] out
    );
    typedef enum logic [1:0] {S0, S1, S2, S3} states_t;
    states_t cs, ns;

    // Sequential Logic
    always_ff @(posedge clk, posedge rst) begin: set_ns
        if (rst) cs <= S0;
        else cs <= ns;
    end: set_ns

    // Next State Logic
    always_comb begin: ns_logic
        ns = cs;
        unique case (cs)
            S0: begin 
                if (in) ns = S1;
                if (!in) ns = S0;
            end
            S1: begin
                if (in) ns = S1;
                if (!in) ns = S2;
            end
            S2: begin
                if (in) ns = S3;
                if (!in) ns = S2;
            end
            S3: begin
                if (in) ns = S3;
                if (!in) ns = S0;
            end
            default: ns = cs;
        endcase
    end: ns_logic

    // Output Logic
    always_comb begin: output_logic
        out = 'x;
        unique case (cs)
            S0: begin
                if (in) out = 4'b1001;
                if (!in) out = 4'b0000;
            end
            S1: begin
                if (in) out = 4'b1001;
                if (!in) out = 4'b1100;
            end
            S2: begin
                if (in) out = 4'b1111;
                if (!in) out = 4'b1100;
            end
            S3: begin
                if (in) out = 4'b1111;
                if (!in) out = 4'b0000;
            end
            default: out = 'x;
        endcase
    end: output_logic
    
endmodule

module top();

    logic in, rst, clk;
    logic [3:0] trace;
    logic [3:0] out_moore, out_mealy;


    initial begin
        clk = 1'b1;
        forever #50 clk = ~clk;
    end

    mooreFSM moore (
        .out(out_moore),
        .* );

    mealyFSM mealy (
        .out(out_mealy),
        .* );

    task resetFSM();
        in = 1'bx;
        @(negedge clk) rst = 1'b1;
        @(negedge clk) rst = 1'b0;
        $display("\nResetting FSM.");
    endtask

    initial begin
        for (int i = 0; i < 16; i++) begin
            resetFSM();
            trace = i & 4'hF;
            $display($time, " Trace: %04b\tInput: %01b\tMoore State: %s\tMoore Output:%04b\tMealy State: %s\tMealy Output: %04b", trace, in, moore.cs.name(), out_moore, mealy.cs.name(), out_mealy);
            for (int j = 0; j < 4; j++) begin
                repeat (1) @(negedge clk);
                in = trace[j];
                repeat (1) @(negedge clk);
                $display($time, " Trace: %04b\tInput: %01b\tMoore State: %s\tMoore Output:%04b\tMealy State: %s\tMealy Output: %04b", trace, in, moore.cs.name(), out_moore, mealy.cs.name(), out_mealy);
            end
        end
        $finish;
    end

endmodule