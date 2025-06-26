module bin2gray (i_binary, o_gray);
    parameter SIZE = 1;
    input [SIZE-1:0] i_binary;
    output [SIZE-1:0] o_gray;

    assign o_gray = i_binary ^ (i_binary >> 1);
endmodule