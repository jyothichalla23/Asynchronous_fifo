module rd_ptr_logic #(parameter DEPTH = 32, DATA_WIDTH = 32, ADDR_WIDTH = $clog2(DEPTH);)
(
    input rd_clk,
    input rd_rst_n,
    input rd_en,
    input [ADDR_WIDTH:0] gray_wr_ptr_sync,

    output reg empty,
    output reg [ADDR_WIDTH:0] bin_rd_ptr, gray_rd_ptr
);

reg output [ADDR_WIDTH:0] bin_rd_ptr_next, gray_rd_ptr_next;
reg empty_next;

assign bin_rd_ptr_next  = bin_rd_ptr+(rd_en & !empty);
assign gray_rd_ptr_next = (bin_rd_ptr_next>>1)^bin_rd_ptr_next;

always@(posedge rd_clk and negedge rd_rst_n)
begin
    if(!rd_rst_n)
    begin
        bin_rd_ptr <= 0;
        gray_rd_ptr <= 0;
        empty <= 0;
    end
    else
    begin
        bin_rd_ptr <= bin_rd_ptr_next;
        gray_rd_ptr <= gray_rd_ptr_next;
        empty <= empty_next;
    end
end

assign empty_next = (gray_rd_ptr_next == grey_wr_ptr_sync);

endmodule