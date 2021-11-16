// Bubble Sort Algorithm

module bubbleSort #(parameter N=3) (
    input clk, rst, we, sort,
    input [31:0] d,
    input [N-1:0] a,
    output logic [31:0] q,
    output logic done
    );

    logic [31:0] mem [0:2**N-1];
    logic [N-1:0] i, j;

    // Inferred RAM
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            done <= 1'b0;
            q <= '0;
            i <= 2**N-1;
            j <= '0;
        end else if (we) begin
            // New values written to RAM, restart sorting variables
            done <= 1'b0;
            i <= 2**N-1;
            j <= '0;
            // Write d value to memory
            mem[a] <= d;
        end
        q <= mem[a];
    end

    // Sorting
    always_ff @(posedge clk) begin
        if (sort && !done) begin
            if (mem[j] > mem[j+1]) begin // swap
                mem[j] <= mem[j+1];
                mem[j+1] <= mem[j];
            end
            if (j > 2**N-2) begin
                j <= '0;
                i <= i-1;
            end else i <= i;
            if (i < 1) begin
                done <= 1'b1;
                i <= 2**N-1;
            end
            j <= j+1;
        end
    end

endmodule



module top();

    parameter N = 3;

    logic clk, rst, we, sort, done;
    logic [31:0] d, q;
    logic [N-1:0] a;

    bubbleSort #(N) bSort (.*);

    initial begin
        clk = 1'b0;
        forever #50 clk = ~clk;
    end

    initial begin
        rst = 1'b1;
        repeat (3) @(negedge clk);
        rst = 1'b0;

        // Testing Writing to RAM
        $display("Testing Writing to RAM.");
        for (int i = 0; i < 2**N; i++) begin
            d = i;
            a = i;
            we = 1'b1;
            repeat (1) @(negedge clk);
        end
        we = 1'b0;

        // Testing Reading from RAM
        $display("Testing Reading from RAM");
        for (int i = 0; i < 2**N; i++) begin
            a = i;
            repeat (1) @(negedge clk);
            $display("Read %0d from location %0d.", q, a);
        end

        rst = 1'b1;
        repeat (3) @(negedge clk);
        rst = 1'b0;

        $display("\n\n");
        // Writing random values to RAM
        $display("Writing random values to RAM");
        for (int i = 0; i < 2**N; i++) begin
            d = $urandom() % 10;
            a = i;
            $display("Writing %0d to location %0d.", d, a);
            we = 1'b1;
            repeat (1) @(negedge clk);
        end
        we = 1'b0;

        $display("\n\nSorting.");
        while (!done) begin
            sort = 1'b1;
            repeat (1) @(negedge clk);
        end
        sort = 1'b0;
        
        // Reading from RAM
        $display("\n\nReading Sorted Values from RAM");
        for (int i = 0; i < 2**N; i++) begin
            a = i;
            repeat (1) @(negedge clk);
            $display("Read %0d from location %0d.", q, a);
        end

        $finish();
    end

endmodule