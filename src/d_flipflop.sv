module d_flipflop(
    input logic clk, reset,
    input logic [7:0] D,
    output logic [7:0] Q
);

always_ff @(posedge clk) begin
    if (reset)
        Q <= 8'b00000000;
    else
        Q <= D;        
end

endmodule