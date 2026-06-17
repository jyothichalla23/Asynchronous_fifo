module wr_ptr_logic #(parameter DEPTH = 32, DATA_WIDTH = 32, ADDR_WIDTH = $clog2(DEPTH))
(
    input wr_clk,
    input wr_rst_n,
    input wr_en,
    input [ADDR_WIDTH:0] gray_rd_ptr_sync,

    output reg full,
    output reg [ADDR_WIDTH:0] bin_wr_ptr, gray_wr_ptr
);

wire [ADDR_WIDTH:0] bin_wr_ptr_next, gray_wr_ptr_next;
wire full_next;

assign bin_wr_ptr_next  = bin_wr_ptr+(wr_en & !full);
assign gray_wr_ptr_next = (bin_wr_ptr_next>>1)^bin_wr_ptr_next;

always@(posedge wr_clk or negedge wr_rst_n)
begin
    if(!wr_rst_n)
    begin
        bin_wr_ptr <= 0;
        gray_wr_ptr <= 0;
        full <= 0;
    end
    else
    begin
        bin_wr_ptr <= bin_wr_ptr_next;
        gray_wr_ptr <= gray_wr_ptr_next;
        full <= full_next;
    end
end

assign full_next = (gray_wr_ptr_next == {~gray_rd_ptr_sync[ADDR_WIDTH:ADDR_WIDTH-1],gray_rd_ptr_sync[ADDR_WIDTH-2:0]});

endmodule