// ECE 581 Project 2
// Problem 4

// N-bit FIFO with N+1 Binary Counter
// Elements:
// Read pointer
// Write Pointer
// Write Counter
// Read Counter
// Full comparator
// Empty comparator

module FIFO #(parameter N = 3, parameter W = 4) (
    input wr_en, rd_en, clk, rst,
    input [W-1:0] wr_data,
    output logic [W-1:0] rd_data,
    output logic full, empty
);

    logic [N:0] rd_ctr, wr_ctr;
    logic [N-1:0] rd_ptr, wr_ptr;
    logic [W-1:0] fifo_data [0:2**N-1]; 

    assign rd_ptr = rd_ctr[N-1:0];
    assign wr_ptr = wr_ctr[N-1:0];

    // FF write counter
    always_ff @(posedge clk or posedge rst) begin: write_counter
        if (rst) wr_ctr <= '0;
        else if (!full && wr_en) begin
            wr_ctr <= wr_ctr + 1;
        end else wr_ctr <= wr_ctr;
    end: write_counter

    // FF read pointer
    always_ff @(posedge clk or posedge rst) begin: read_counter
        if (rst) rd_ctr <= '0;
        else if (!empty && rd_en) begin
            rd_ctr <= rd_ctr + 1;
        end else rd_ctr <= rd_ctr;
    end: read_counter

    // Read data
    always_ff @(posedge clk or posedge rst) begin: read_data
        if (rst) rd_data <= '0;
        else if (!empty && rd_en) begin
            rd_data <= fifo_data[rd_ptr];
        end else rd_data <= rd_data;
    end: read_data

    // Write data
    always_ff @(posedge clk or posedge rst) begin: write_data
        if (!full && wr_en) begin
            fifo_data[wr_ptr] <= wr_data;
        end else fifo_data[wr_ptr] <= fifo_data[wr_ptr];
    end: write_data

    // full and empty logic
    always_comb begin: full_empty
        if (rd_ptr == wr_ptr) begin
            full = (wr_ctr[N] != rd_ctr[N]) ? 1'b1 : 1'b0;
            empty = (wr_ctr[N] == rd_ctr[N]) ? 1'b1 : 1'b0;
        end else begin
            full = 1'b0;
            empty = 1'b0;
        end
    end: full_empty

endmodule

module top();
    parameter W = 4;
    parameter N = 3;

    logic clk, rst, wr_en, rd_en, full, empty;
    logic [W-1:0] rd_data, wr_data;
    int rdptr;

    FIFO #(.W(W), .N(N)) fifo_0 (.*);

    initial begin
        clk = 1'b0;
        forever #50 clk = ~clk;
    end

    initial begin
        rst = 1'b1;
        repeat (2) @(negedge clk);
        rst = 1'b0;
        repeat (2) @(negedge clk);

        $display("FIFO initial state. rd_data=%04b\tfull=%01b\tempty=%01b", rd_data, full, empty);
        
        // Test 1 write and 1 read
        $display("\n\nTest 1: 1 Write followed by 1 Read");
        wr_data = $random() & {W{1'b1}};
        $display("Writing %0d to location %0d.", wr_data, fifo_0.wr_ptr);
        wr_en = 1'b1;
        repeat(1) @(negedge clk);
        wr_en = 1'b0;
        $display("FIFO state. rd_data=%04b\tfull=%01b\tempty=%01b", rd_data, full, empty);
        $display("Reading data from location %0d.", fifo_0.rd_ptr);
        rd_en = 1'b1;
        repeat (1) @(negedge clk);
        rd_en = 1'b0;
        $display("FIFO state. rd_data=%04b\tfull=%01b\tempty=%01b", rd_data, full, empty);


        $display("\n\nTest 2: 6 writes followed by 6 reads");
        // 6 writes
        repeat(2) @(negedge clk);
        $display("FIFO state. rd_data=%04b\tfull=%01b\tempty=%01b", rd_data, full, empty);
        wr_en = 1'b1;
        for (int i = 0; i < 6; i++) begin
            wr_data = i & {W{1'b1}};
            $display("Writing %0d to location %0d.", wr_data, fifo_0.wr_ptr);
            repeat(1) @(negedge clk);
        end
        wr_en = 1'b0;
        $display("FIFO state. rd_data=%04b\tfull=%01b\tempty=%01b", rd_data, full, empty);

        // 6 reads
        repeat (2) @(negedge clk);
        rd_en = 1'b1;
        for (int i = 0; i < 6; i++) begin
            rdptr = fifo_0.rd_ptr;
            repeat (1) @(negedge clk);
            $display("Read %0d from location %0d", rd_data, rdptr);
        end
        rd_en = 1'b0;
        $display("FIFO state. rd_data=%04b\tfull=%01b\tempty=%01b", rd_data, full, empty);

        // Test 3 - write till full.
        $display("\n\nTest 3: Write until full.");
        repeat(2) @(negedge clk);
        $display("FIFO state. rd_data=%04b\tfull=%01b\tempty=%01b", rd_data, full, empty);
        wr_en = 1'b1;
        for (int i = 0; i < 2**N; i++) begin
            wr_data = i & {W{1'b1}};
            $display("Writing %0d to location %0d.", wr_data, fifo_0.wr_ptr);
            repeat(1) @(negedge clk);
        end
        wr_en = 1'b0;
        $display("FIFO state. rd_data=%04b\tfull=%01b\tempty=%01b", rd_data, full, empty);

        // Test 4a - Attempt to overflow.
        $display("\n\nTest 4a: Test overflow.");
        repeat(2) @(negedge clk);
        $display("FIFO state. rd_data=%04b\tfull=%01b\tempty=%01b", rd_data, full, empty);
        wr_en = 1'b1;
        for (int i = 0; i < 2**N; i++) begin
            wr_data = $random() & {W{1'b1}};
            $display("Writing %0d to location %0d.", wr_data, fifo_0.wr_ptr);
            repeat(1) @(negedge clk);
        end
        wr_en = 1'b0;
        $display("FIFO state. rd_data=%04b\tfull=%01b\tempty=%01b", rd_data, full, empty);

        // Test 4b - Read until Empty and check overflow
        $display("\n\nTest 4b: Read until empty. Check that random values were not written.");
        repeat (2) @(negedge clk);
        rd_en = 1'b1;
        for (int i = 0; i < 2**N; i++) begin
            rdptr = fifo_0.rd_ptr;
            repeat (1) @(negedge clk);
            $display("Read %0d from location %0d", rd_data, rdptr);
        end
        rd_en = 1'b0;
        $display("FIFO state. rd_data=%04b\tfull=%01b\tempty=%01b", rd_data, full, empty);

        // Test 4c - Attempt to underflow
        $display("\n\nTest 4c: Read while empty. Verify that the rd_data value doesn't change.");
        repeat (2) @(negedge clk);
        rd_en = 1'b1;
        for (int i = 0; i < 2**N; i++) begin
            rdptr = fifo_0.rd_ptr;
            repeat (1) @(negedge clk);
            $display("Read %0d from location %0d", rd_data, rdptr);
        end
        rd_en = 1'b0;
        $display("FIFO state. rd_data=%04b\tfull=%01b\tempty=%01b", rd_data, full, empty);

        $finish();
    end
endmodule