module para_ff (rst_n, clk, D, Q);
    parameter SIZE = 1;
    input rst_n, clk; 
    input [SIZE-1:0] D;
    output reg [SIZE-1:0] Q;
    always @(posedge clk, negedge rst_n) begin
        if (~rst_n)
            Q <= 0;
        else
            Q <= D; 
    end
endmodule
