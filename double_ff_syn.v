module double_ff_syn (rst_n, clk, D, Q);
    parameter SIZE = 1;

    input rst_n, clk;
    input [SIZE-1:0] D;
    output [SIZE-1:0] Q;
    
    //intermediate wire
    wire [SIZE-1:0] q_i;

    //synchronizer
    para_ff #(.SIZE(SIZE)) ff1_syn (.rst_n(rst_n), .clk(clk), .D(D), .Q(q_i));
    para_ff #(.SIZE(SIZE)) ff2_syn (.rst_n(rst_n), .clk(clk), .D(q_i), .Q(Q));

endmodule

