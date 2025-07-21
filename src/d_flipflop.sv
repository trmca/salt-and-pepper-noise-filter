module d_flipflop(
    input logic clk, nres,
    input logic [7:0] D,
    output logic [7:0] Q
);

always_ff @(posedge clk) begin
    if (!nres)
        Q <= 8'b00000000;
    else
        Q <= D;        
end

endmodule
