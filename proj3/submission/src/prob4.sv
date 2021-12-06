// Proj 2 Prob 1 FSM Boolean Expression Design
module S1_FSM (
    input clk, rst,
    output logic out
);

    logic [3:0] cs, ns;

    always_ff @(posedge clk or posedge rst) begin: seq_logic
        if (rst) begin
            cs <= 4'b0000;
        end else cs <= ns;
    end: seq_logic

    always_comb begin: next_state_logic
        ns[3] = (!cs[3]&!cs[2]) | (!cs[3]&cs[2]&!(cs[1]^cs[0])) | (cs[3]&cs[2]&(cs[1]^cs[0]));
        ns[2] = cs[3];
        ns[1] = cs[2];
        ns[0] = cs[1];
    end: next_state_logic

    always_comb begin: output_logic
        out = !cs[2] | cs[2] & !(cs[1]^cs[0]);
    end: output_logic

endmodule


// // Proj 2 Prob 1 Test Design
// module S1_FSM (
//     input clk, rst,
//     output logic out
// );

//     logic [3:0] cs;

//     always_ff @(posedge clk or posedge rst) begin: seq_logic
//         if (rst) cs <= 4'b0000;
//         else begin
//             cs[3] <= ((!cs[3]&!cs[2]) | (!cs[3]&cs[2]&!(cs[1]^cs[0])) | (cs[3]&cs[2]&(cs[1]^cs[0])));
//             cs[2] <= cs[3];
//             cs[1] <= cs[2];
//             cs[0] <= cs[1];
//         end
//     end: seq_logic

//     always_comb begin: output_logic
//         out = !cs[2] | cs[2] & !(cs[1]^cs[0]);
//     end: output_logic

// endmodule

// // FSM Design
// module S1_FSM (
//     input clk, rst,
//     output logic out
// );

//     logic [3:0] cs, ns;

//     always_ff @(posedge clk, posedge rst) begin: seq_logic
//         if (rst) cs <= 4'b0000;
//         else cs <= ns;
//     end: seq_logic

//     always_comb begin: next_state_logic
//         case (cs)
//             0:  ns = 8;
//             1:  ns = 8;
//             2:  ns = 9;
//             3:  ns = 9;
//             4:  ns = 10;
//             5:  ns = 2;
//             6:  ns = 3;
//             7:  ns = 11;
//             8:  ns = 4;
//             9:  ns = 4;
//             10: ns = 5;
//             11: ns = 5;
//             12: ns = 6;
//             13: ns = 13;
//             14: ns = 15;
//             15: ns = 7;
//             default: ns = 0;
//         endcase
//     end: next_state_logic

//     always_comb begin: output_logic
//         if ((cs == 5) || (cs == 6) || (cs == 13) || (cs == 14)) out = 1'b0;
//         else out = 1'b1;
//     end: output_logic
// endmodule


// // Structural Design
// module S1_FSM (
//     input clk, rst,
//     output logic out
// );

//     logic [0:3] Q;
//     logic [0:5] W;

//     always_ff @(posedge clk, posedge rst) begin
//         if (rst) Q <= 4'b0000;
//         else begin
//             Q <= {W[2], Q[0:2]};
//         end
//     end

//     always_comb begin
//         W[0] = Q[3] ^ Q[2];
//         W[1] = ~(W[0] & Q[1]);
//         W[2] = W[1] ^ Q[0];
//         W[3] = W[0] | Q[3];
//         W[4] = Q[3] | W[3];
//         W[5] = ~(W[1] & W[3]);
//         out = W[5] ^ W[4];
//     end

// endmodule