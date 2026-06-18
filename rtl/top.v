`include "asynch_fifo_mem.sv"
`include "sync_ff.sv"
`include "wr_ptr_logic.sv"
`include "rd_ptr_logic.sv"


module async_fifo_top #(parameter DEPTH = 32, DATA_WIDTH = 32)
(
    input wr_clk,
    input wr_rst_n,
    input wr_en,
    input rd_clk,
    input rd_rst_n,
    input rd_en,
    input [DATA_WIDTH-1:0] wr_data,

    output [DATA_WIDTH-1:0] rd_data,
    output full,
    output empty
);

  localparam ADDR_WIDTH = $clog2(DEPTH);

  wire [ADDR_WIDTH:0] g_wptr_sync, g_rptr_sync;
  wire [ADDR_WIDTH:0] b_wptr, b_rptr;
  wire [ADDR_WIDTH:0] g_wptr, g_rptr;

  wire [ADDR_WIDTH-1:0] wr_addr, rd_addr;

asynch_fifo_mem #(.DEPTH(DEPTH),.ADDR_WIDTH(ADDR_WIDTH),.DATA_WIDTH(DATA_WIDTH)) mem (.wr_clk(clk),.wr_en(wr_en),.full(full),.bin_wr_addr(wr_addr),.wr_data(wr_data),.bin_rd_addr(rd_addr),.rd_data(rd_data));
wr_ptr_logic #(.DEPTH(DEPTH),.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH)) wr_ptr (.wr_clk(wr_clk),.wr_rst_n(wr_rst_n),.wr_en(wr_en),.gray_rd_ptr_sync(gray_rd_ptr_sync),.full(full),.bin_wr_ptr(bin_wr_ptr),.gray_wr_ptr(gray_wr_ptr));
sync_ff #(.DEPTH(DEPTH),.ADDR_WIDTH(ADDR_WIDTH)) sync_wr (.clk(wr_clk),.rst_n(wr_rst_n),.ptr(g_wptr),.sync_ptr(g_wptr_sync));
rd_ptr_logic #(.DEPTH(DEPTH),.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH)) rd_ptr (.rd_clk(rd_clk),.rd_rst_n(rd_rst_n),.rd_en(rd_en),.gray_wr_ptr_sync(gray_wr_ptr_sync),.empty(empty),.bin_rd_ptr(bin_rd_ptr),.gray_rd_ptr(gray_rd_ptr));
sync_ff #(.DEPTH(DEPTH),.ADDR_WIDTH(ADDR_WIDTH)) sync_rd (.clk(rd_clk),.rst_n(rd_rst_n),.ptr(g_rptr),.sync_ptr(g_rptr_sync));


endmodule
