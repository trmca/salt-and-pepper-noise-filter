module fifoBuffer (
    input logic clk,
    input logic nres,
    input logic wr_en, rd_en,
    input logic [7:0] wr_data,
    output logic [7:0] rd_data
);

    parameter int FIFO_DEPTH = 253;
    parameter int ADDR_WIDTH = $clog2(FIFO_DEPTH);

    logic [7:0] mem [0:FIFO_DEPTH-1];
    logic [7:0] out_buffer;
    logic [7:0] out_data;

    //read and write pointers
    logic [ADDR_WIDTH-1:0] rd_ptr, wr_ptr;

    //write operation
    always_ff @(posedge clk) begin
        if (!nres)
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
    always_ff @(posedge clk) begin
        if (!nres)
            rd_ptr <=0;
        else begin
            if (rd_en) begin
                if (rd_ptr == 8'b11111100) begin //in case rd_ptr reaches address FIFO_DEPTH-1 it goes to address 0
                    out_data <= mem[rd_ptr];
                    rd_ptr <= 0;
                end
                else begin
                    out_data <= mem[rd_ptr];
                    rd_ptr <= rd_ptr + 1;
                end
            end
        end   
    end

/*    always_ff @(posedge clk) begin
        out_buffer <= out_data;
    end
*/    
    always_comb begin
        rd_data = out_data;
    end

endmodule
