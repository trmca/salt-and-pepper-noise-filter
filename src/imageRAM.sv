parameter int RAM_depth = 256*256;
parameter logic addr_width = $clog2(RAM_depth);

module imageRAM(
    input logic clk,
    input logic wr_en, rd_en,
    input logic [addr_width - 1:0] wr_addr, rd_addr,
    input logic [7:0] wr_data,
    output logic [7:0] rd_data
);

logic [7:0] data_out;
logic [7:0] mem [0: RAM_depth-1];
reg [7:0] out_buffer;

always @(posedge clk) begin
    if (wr_en) begin
        mem[wr_addr] <= wr_data; 
    end
    if (rd_en) begin
        data_out <= mem[rd_addr];
    end
end

always @(posedge clk) begin
    out_buffer <= data_out;
end

always_comb begin
    rd_data = out_buffer;
end

endmodule
