module async_FIFO (i_rst_n, i_wclk, i_wen, i_wdata, o_full, i_rclk, i_ren, o_rdata, o_rempty);
    parameter FIFO_DEPTH = 16;
    parameter FIFO_WIDTH = 4;

    localparam PTR_WIDTH = $clog2(FIFO_DEPTH);

    input i_rst_n, i_wclk, i_wen, i_rclk, i_ren;
    input [FIFO_WIDTH-1:0] i_wdata;

    output o_full, o_rempty;
    output reg [FIFO_WIDTH-1:0] o_rdata;
    
    reg [FIFO_WIDTH-1:0] FIFO [0:FIFO_DEPTH-1];
    
    reg [PTR_WIDTH:0] w_ptr, r_ptr; // one extra bit to det. the overlap
    wire [PTR_WIDTH:0]  w_ptr_syn_rclk, r_ptr_syn_wclk; // synchronized ptr. to the dest. clk

    // ======== wclk Domain ======== //
    always @(posedge i_wclk, negedge i_rst_n) begin
        if (~i_rst_n) begin
            w_ptr <= 0; 
        end
        else if (i_wen & ~o_full) begin // check if full
            //write date
            FIFO[w_ptr[PTR_WIDTH-1:0]] <= i_wdata;

            //incr w_ptr
            w_ptr <= w_ptr + 1;
        end
    end
    
    //double_ff synchronizer with binary to gray converter

    wire [PTR_WIDTH:0] r_ptr_gray, r_ptr_syn_wclk_gray;

    bin2gray #(PTR_WIDTH+1) b2g_i1 (r_ptr, r_ptr_gray);

    double_ff_syn #(.SIZE(PTR_WIDTH+1)) syn_1 (.rst_n(rst_n), .clk(i_wclk), .D(r_ptr_gray), .Q(r_ptr_syn_wclk_gray));

    gray2bin #(PTR_WIDTH+1) g2b_i1 (r_ptr_syn_wclk_gray, r_ptr_syn_wclk);




    // full flag
    assign o_full = (w_ptr[PTR_WIDTH] != r_ptr_syn_wclk[PTR_WIDTH]) && (w_ptr[PTR_WIDTH-1:0] == r_ptr_syn_wclk[PTR_WIDTH-1:0]) ? 1'b1 : 1'b0; 



    // ======== rclk Domain ======== //

    always @(posedge i_rclk, negedge i_rst_n) begin
        if (~i_rst_n) begin
            r_ptr <= 0; 
        end
        else if (i_ren & ~o_rempty) begin // check if empty
            //write date
            o_rdata <= FIFO[r_ptr[PTR_WIDTH-1:0]];

            //incr r_ptr
            r_ptr <= r_ptr + 1;
        end
    end

    //double_ff synchronizer with binary to gray coverter
    wire [PTR_WIDTH:0] w_ptr_gray, w_ptr_syn_rclk_gray;

    bin2gray #(PTR_WIDTH+1) b2g_i2 (w_ptr, w_ptr_gray);

    double_ff_syn #(.SIZE(PTR_WIDTH+1)) syn_2 (.rst_n(rst_n), .clk(i_rclk), .D(w_ptr_gray), .Q(w_ptr_syn_rclk_gray));

    gray2bin #(PTR_WIDTH+1) g2b_i2 (w_ptr_syn_rclk_gray, w_ptr_syn_rclk);



    //empty flag
    assign o_rempty = (r_ptr == w_ptr_syn_rclk) ? 1'b1 : 1'b0; 

endmodule