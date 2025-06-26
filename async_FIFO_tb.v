module async_FIFO_tb;

    parameter FIFO_DEPTH = 512;
    parameter FIFO_WIDTH = 4;

    reg i_rst_n, i_wclk, i_wen, i_rclk, i_ren;
    reg [FIFO_WIDTH-1:0] i_wdata;

    wire o_full, o_rempty;
    wire [FIFO_WIDTH-1:0] o_rdata;

    async_FIFO #(.FIFO_DEPTH(FIFO_DEPTH), .FIFO_WIDTH(FIFO_WIDTH)) dut (i_rst_n, i_wclk, i_wen, i_wdata, o_full, i_rclk, i_ren, o_rdata, o_rempty);


    //wclk
    initial begin
        i_wclk = 0;
        forever
            #2 i_wclk = ~i_wclk;
    end

    //rclk
    initial begin
        i_rclk = 0;
        forever
            #7 i_rclk = ~i_rclk;
    end
    
    initial begin
        i_rst_n = 0;
        i_wen = 0;
        i_ren = 0;
        @(negedge i_wclk);
        i_rst_n = 1;
        repeat(2000) begin
            i_wen = $random;
            i_ren = $random;
            i_wdata = $random;
            @(negedge i_wclk);
        end

        repeat(4000) begin
            i_wen = 0;
            i_ren = $random;
            i_wdata = $random;
            @(negedge i_wclk);
        end
        $stop;
    end
endmodule