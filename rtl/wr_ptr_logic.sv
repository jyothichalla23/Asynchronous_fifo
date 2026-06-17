module wr_ptr_logic #(parameter DEPTH = 32, DATA_WIDTH = 32, ADDR_WIDTH = $clog2(DEPTH);)
(
    input wr_clk,
    input wr_rst_n,
    input wr_en,
    input [ADDR_WIDTH:0] grey_rd_ptr_sync,

    output reg full,
    output reg [ADDR_WIDTH:0] bin_wr_ptr, grey_wr_ptr
);

reg output [ADDR_WIDTH:0] bin_wr_ptr_next, grey_wr_ptr_next;
reg full_next;

assign bin_wr_ptr_next  = bin_wr_ptr+(wr_en & !full);
assign grey_wr_ptr_next = (bin_wr_ptr_next>>1)^bin_wr_ptr_next;

always@(posedge wr_clk and negedge wr_rst_n)
begin
    if(!wr_rst_n)
    begin
        bin_wr_ptr <= 0;
        grey_wr_ptr <= 0;
        full <= 0;
    end
    else
    begin
        bin_wr_ptr <= bin_wr_ptr_next;
        grey_wr_ptr <= grey_wr_ptr_next;
        full <= full_next;
    end
end

assign full_next = (grey_wr_ptr_next == {~grey_rd_ptr_sync[ADDR_WIDTH],grey_rd_ptr_sync[ADDR_WIDTH-1:0]});

endmodule