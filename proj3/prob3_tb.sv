
`timescale 1ns/10ps
module top();

    logic [3:0] in_A, in_B;
    logic [4:0] result;

    gray_adder #(4) ga(.*);

    initial begin
        $monitor(,$time," result=%b, in_A=%b, in_B=%b",result,in_A,in_B); //This monitor statement prints anytime these values change
        #1 in_A = 4'b0000; in_B = 4'b0000; //Covers 16 combinations of adding 2 graycode numbers
        #1 in_A = 4'b0001; in_B = 4'b0000;
        #1 in_A = 4'b0010; in_B = 4'b0000;
        #1 in_A = 4'b0011; in_B = 4'b0000;
        #1 in_A = 4'b0000; in_B = 4'b0000;
        #1 in_A = 4'b0000; in_B = 4'b0001;
        #1 in_A = 4'b0000; in_B = 4'b0010;
        #1 in_A = 4'b0000; in_B = 4'b0011;
        #1 in_A = 4'b0000; in_B = 4'b0000;
        #1 in_A = 4'b0001; in_B = 4'b0100;
        #1 in_A = 4'b0010; in_B = 4'b1000;
        #1 in_A = 4'b0011; in_B = 4'b1100;
        #1 in_A = 4'b0100; in_B = 4'b0000;
        #1 in_A = 4'b1000; in_B = 4'b0001;
        #1 in_A = 4'b1100; in_B = 4'b0010;
        #1 in_A = 4'b1000; in_B = 4'b0011;
        #10 $finish;
    end

endmodule


// module top();
//     parameter N = 4;

//     logic [N-1:0] in_A, in_B;
//     logic [N:0] result;

//     gray_adder #(N) ga ();

// endmodule