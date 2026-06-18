module synch_ff #(parameter DEPTH = 32, ADDR_WIDTH = $clog2(DEPTH))
(
    input clk,
    input rst_n,
    input [ADDR_WIDTH:0] ptr,

    output reg [ADDR_WIDTH:0] ptr_syn
);
reg [ADDR_WIDTH:0] ptr_1;

always@(posedge clk and negedge rst_n)
begin
    if(!rst_n)
    begin
        ptr_1 <= 0;
        ptr_syn <= 0;
    end
    else 
    begin
        ptr_1 <= ptr;
        ptr_syn <= ptr_1; 
    end
end

endmodule
