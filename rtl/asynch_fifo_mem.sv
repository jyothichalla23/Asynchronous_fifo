module asynch_fifo_mem #(parameter DEPTH=32, ADDR_WIDTH=$clog2(DEPTH), DATA_WIDTH=32)
(
    input wr_clk,
    input wr_en,
    input full,
    input [ADDR_WIDTH-1:0] bin_wr_addr,
    input [DATA_WIDTH-1:0] wr_data,
    input [ADDR_WIDTH-1:0] bin_rd_addr,

    output logic [DATA_WIDTH-1:0] rd_data
);

reg [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1];

always@(posedge wr_clk)
begin
    if(wr_en && !full) 
    begin
        fifo_mem[bin_wr_addr[ADDR_WIDTH-1:0]] <= wr_data;
    end
/*    
    else
    begin
        fifo_mem[bin_wr_addr[ADDR_WIDTH-1:0]] <= DATA_WIDTH'0;
    end 
    */
end

assign rd_data = fifo_mem[bin_rd_addr[ADDR_WIDTH-1:0]];

endmodule
