module gray2bin (i_gray, o_binary);
    parameter SIZE = 1;
    input [SIZE-1:0] i_gray;
    output [SIZE-1:0] o_binary;
    genvar i;
    generate
        for(i=0; i < SIZE; i = i+1) begin
            assign o_binary[i] = ^(i_gray >> i);
        end
    endgenerate
endmodule