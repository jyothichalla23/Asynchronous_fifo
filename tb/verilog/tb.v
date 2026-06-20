`include "top.v"

module tb;

parameter DEPTH = 8 ;
parameter DATA_WIDTH = 32;

reg wr_clk;
reg wr_rst_n;
reg wr_en;
reg rd_clk;
reg rd_rst_n;
reg rd_en;
reg [DATA_WIDTH-1:0] wr_data;

wire [DATA_WIDTH-1:0] rd_data;
wire full;
wire empty;

async_fifo_top #(
    .DEPTH(DEPTH),
    .DATA_WIDTH(DATA_WIDTH)
    ) top (
        .wr_clk(wr_clk),
        .wr_rst_n(wr_rst_n),
        .wr_en(wr_en),
        .rd_clk(rd_clk),
        .rd_rst_n(rd_rst_n),
        .rd_en(rd_en),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .full(full),
        .empty(empty)
        );


initial 
begin
    wr_clk = 0;
    forever 
    begin
        #5 wr_clk = ~wr_clk;    
    end   
end

initial 
begin
    rd_clk = 0;
    forever 
    begin
        #10 rd_clk = ~rd_clk;    
    end   
end

initial 
begin
   wr_rst_n = 0;
   wr_en    = 0;
   rd_rst_n = 0;
   rd_en    = 0;
   wr_data  = 0;
end

#50;
wr_rst_n = 1;
wr_en    = 1;

task write_fifo(input [DATA_WIDTH-1:0] data_in);
begin
    @(posedge wr_clk)
    begin
        if(!full)
        begin
            wr_en = 1 ;
            wr_data = data_in;
        end
    end
    
    @(posedge wr_clk)
    wr_en = 0;
end
endtask

task read_fifo();
begin
    @(posedge rd_clk)
    begin
        if(!empty)
            rd_en = 1 ;
    end
    
    @(posedge wr_clk)
    wr_en = 0;
end
endtask

initial
begin
    write_fifo(DATA_WIDTH'1);
    read_fifo();

    #200;
    $finish;
end

initial 
begin
    $monitor("T=%0t | W_EN=%b R_EN=%b DIN=%0d DOUT=%0d FULL=%b EMPTY=%b",
              $time, w_en, r_en, data_in,
              data_out, full, empty);
end

endmodule

