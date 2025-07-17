module toplevel_design(
    input logic clk, nres,
    output logic [7:0] median_out
    );

logic [7:0] ram_r1, r1_r2, r2_r3, r3_f1, f1_r4, r4_r5, r5_r6, r6_f2, f2_r7, r7_r8, r8_r9, r9_sort;
logic ram_rd_en, ram_wr_en, fifo1_wr_en, fifo2_wr_en, fifo1_rd_en, fifo2_rd_en, sort_en;
logic [15:0] ram_wr_addr, ram_rd_addr;

state_machine_cnt FSM(
    .clk(clk),
    .nres(nres),
    .ram_rd_en(ram_rd_en), 
    .ram_wr_en(ram_wr_en),
    .fifo1_wr_en(fifo1_wr_en),
    .fifo1_rd_en(fifo1_rd_en),
    .fifo2_wr_en(fifo2_wr_en),
    .fifo2_rd_en(fifo2_rd_en),
    .sort_en(sort_en),
    .ram_wr_addr(ram_wr_addr),
    .ram_rd_addr(ram_rd_addr)
);
    
imageRAM RAM_MEM(
    .clk(clk),
    .wr_en(ram_wr_en),
    .rd_en(ram_rd_en),
    .wr_addr(ram_wr_addr),
    .rd_addr(ram_rd_addr),
    .wr_data(median_out),
    .rd_data(ram_r1)
);

fifoBuffer fifo1(
    .clk(clk),
    .nres(nres),
    .wr_en(fifo1_wr_en),
    .rd_en(fifo1_rd_en),
    .wr_data(r3_f1),
    .rd_data(f1_r4)    
);

fifoBuffer fifo2(
    .clk(clk),
    .nres(nres),
    .wr_en(fifo2_wr_en),
    .rd_en(fifo2_rd_en),
    .wr_data(r6_f2),
    .rd_data(f2_r7)    
);

d_flipflop pixreg1(
    .clk(clk),
    .nres(nres),
    .D(ram_r1),
    .Q(r1_r2)
);

d_flipflop pixreg2(
    .clk(clk),
    .nres(nres),
    .D(r1_r2),
    .Q(r2_r3)
);

d_flipflop pixreg3(
    .clk(clk),
    .nres(nres),
    .D(r2_r3),
    .Q(r3_f1)
);

d_flipflop pixreg4(
    .clk(clk),
    .nres(nres),
    .D(f1_r4),
    .Q(r4_r5)
);

d_flipflop pixreg5(
    .clk(clk),
    .nres(nres),
    .D(r4_r5),
    .Q(r5_r6)
);

d_flipflop pixreg6(
    .clk(clk),
    .nres(nres),
    .D(r5_r6),
    .Q(r6_f2)
);

d_flipflop pixreg7(
    .clk(clk),
    .nres(nres),
    .D(f2_r7),
    .Q(r7_r8)
);

d_flipflop pixreg8(
    .clk(clk),
    .nres(nres),
    .D(r7_r8),
    .Q(r8_r9)
);

d_flipflop pixreg9(
    .clk(clk),
    .nres(nres),
    .D(r8_r9),
    .Q(r9_sort)
);

selectMedian medianSort(
    .clk(clk),
    .nres(nres),
    .enable(sort_en),
    .px0(r1_r2),
    .px1(r2_r3),
    .px2(r3_f1),
    .px3(r4_r5),
    .px4(r5_r6),
    .px5(r6_f2),
    .px6(r7_r8),
    .px7(r8_r9),
    .px8(r9_sort),
    .median(median_out)
);
    
    
endmodule
