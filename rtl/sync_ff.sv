module sync_ff #(parameter DEPTH = 32, ADDR_WIDTH = $clog2(DEPTH) ;)
(
    input clk,
    input rst_n,
    input [ADDR_WIDTH:0] ptr,

    output reg [ADDR_WIDTH:0] sync_ptr
);

reg [ADDR_WIDTH:0] ptr_out;

always @(posedge clk and negedge rst_n) 
begin
    if(!rst_n)
    begin
        ptr_out  <= 0;
        sync_ptr <= 0;
    end
    else
    begin
        ptr_out  <= ptr;
        sync_ptr <= ptr_out;
    end
end
endmodule