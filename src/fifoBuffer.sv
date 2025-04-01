module fifoBuffer (
    input logic clk,
    input logic rst,
    input logic wr_en, rd_en,
    input logic [7:0] wr_data,
    output logic [7:0] rd_data
);

    parameter int FIFO_DEPTH = 253;
    parameter int ADDR_WIDTH = $clog2(FIFO_DEPTH);

    logic [7:0] mem [0:FIFO_DEPTH-1];

    //read and write pointers
    logic [ADDR_WIDTH-1:0] rd_ptr, wr_ptr;

    //write operation
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            wr_ptr <= 0;
        else begin
            if (wr_en) begin
                if (wr_ptr == 8'b11111100) begin //in case wr_ptr reaches address FIFO_DEPTH-1 it goes to address 0
                    mem[wr_ptr] <= wr_data;
                    wr_ptr <= 0;
                end
                else begin
                    mem[wr_ptr] <= wr_data;
                    wr_ptr <= wr_ptr + 1; 
                end
            end
        end
    end

    //read operation
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            rd_ptr <=0;
        else begin
            if (rd_en) begin
                if (rd_ptr == 8'b11111100) begin //in case rd_ptr reaches address FIFO_DEPTH-1 it goes to address 0
                    rd_data <= mem[rd_ptr];
                    rd_ptr <= 0;
                end
                else begin
                    rd_data <= mem[rd_ptr];
                    rd_ptr <= rd_ptr + 1;
                end
            end
        end   
    end

endmodule