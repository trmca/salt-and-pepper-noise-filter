module toplevel_tb(
    );
    
logic clk, nres;
logic [7:0] median_out;
int fd;

toplevel_design DUT(
    .clk(clk),
    .nres(nres),
    .median_out(median_out)
);

always #4 clk <= ~clk;

initial begin
clk = 0;
nres = 0;

#12 nres = 1;

#524308

fd = $fopen("./output", "w"); 
if (fd)  $display("File was opened successfully : %0d", fd);
    else     $display("File was NOT opened successfully : %0d", fd);   

for (int i = 0; i < 256*256; i++) begin
    $fdisplay(fd, "%08b", toplevel_design.RAM_MEM.mem[i]);
end   

#8 $finish;
   
end

    
endmodule
