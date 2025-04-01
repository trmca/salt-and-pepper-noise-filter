module tb_fifoBuffer ();

    logic clk, rst;
    logic wr_en, rd_en;
    logic [7:0] wr_data, rd_data;

    parameter int datastream_len = 20000; //number of data samples to be sent into fifo buffer

    logic [7:0] datastream [0:datastream_len-1];
    logic [7:0] fifo_output [0:datastream_len-1];

    int pass_counter, fail_counter;
        
    //DUT instantiation
    fifoBuffer DUT(
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .wr_data(wr_data),
        .rd_data(rd_data)
    );

    //clock generation
    always #20 clk <= ~clk;

    //test stimulus
    initial begin
        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        wr_data = 8'b00000000;
        pass_counter = 0;
        fail_counter = 0;
        

        //datastream generation
        for (int i = 0; i < datastream_len; i++) begin
            datastream[i] = $urandom & 8'hFF;
        end

        #80;

        rst = 0;

        #40;

        wr_en = 1;

        for (int i = 0; i < datastream_len + 253; i++) begin
            wr_data = datastream[i];
            if (i == 252) 
                rd_en = 1;
            if (i > 252) begin
                fifo_output[i-253] = rd_data;
                if (fifo_output[i-253] == datastream[i-253])
                    pass_counter++;
                else begin
                    fail_counter++;
                    $display ("FAIL AT DATASTREAM LOCATION %0d", i-253);
                end        
            end
            if (i == datastream_len)
                wr_en = 0;
            #40;    
        end
        
        $display ("%0d PASS | %0d FAIL", pass_counter, fail_counter);
        
        if (fail_counter == 0)
            $display ("TEST PASSED");
        else
            $display ("TEST FAILED");    
        
        #80 $finish;
    end

endmodule