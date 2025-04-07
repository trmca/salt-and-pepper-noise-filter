class testArray;
    logic [7:0] array [8:0];
    logic [7:0] testMedianValue;

    function new(input logic [7:0] randomArray [8:0]);
        this.array = randomArray;
        testMedianValue = 8'b00000000;
    endfunction;

    function simpleSort();
        logic [7:0] temp;
        for (int i = 0; i < 8; i++) begin
            for (int j = 0; j < 8-i; j++) begin
                if (array[j] > array[j+1]) begin
                    temp = array[j];
                    array[j] = array[j+1];
                    array[j+1] = temp;
                end
            end
        end
        testMedianValue = array[4];
    endfunction;

    function getArray(ref logic [7:0] arr [8:0]);
        arr = array;
    endfunction;

    function getMedian(ref logic [7:0] median);
        median = testMedianValue;
    endfunction;
endclass


module tb_selectMedian ();

    parameter int testDepth = 150; //number of tests

    testArray arr1;
    logic clk, rst, enable;
    logic [7:0] px0, px1, px2, px3, px4, px5, px6, px7, px8;
    logic [7:0] median;
    logic [7:0] workingArray [8:0];
    logic [7:0] sortedArray [8:0];
    logic [7:0] rndArr [8:0];
    logic [7:0] simpleSortOut [testDepth:0], dutOut [testDepth:0];
    int pass_counter, fail_counter;


    //dut instantiation
    selectMedian DUT (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .px0(px0),
        .px1(px1),
        .px2(px2),
        .px3(px3),
        .px4(px4),
        .px5(px5),
        .px6(px6),
        .px7(px7),
        .px8(px8),
        .median(median)
    );
    
    //clock generation
    always #20 clk <= ~clk;

    //test stimulus
    initial begin
        clk = 0;
        rst = 1;
        enable = 1;
        pass_counter = 0;
        fail_counter = 0;
    
        foreach (rndArr[i]) begin
            rndArr[i] = $urandom & 8'hFF;
        end

        arr1 = new(rndArr);

        #15 rst = 0;
        for (int loop = 0; loop < testDepth+10; loop++) begin
            arr1.getArray(workingArray);
            px0 = workingArray[0];
            px1 = workingArray[1];
            px2 = workingArray[2];
            px3 = workingArray[3];
            px4 = workingArray[4];
            px5 = workingArray[5];
            px6 = workingArray[6];
            px7 = workingArray[7];
            px8 = workingArray[8];
            arr1.simpleSort();
            arr1.getArray(sortedArray);
            if (loop <= testDepth) begin
                arr1.getMedian(simpleSortOut[loop]);
            end
            if (loop > 9) begin
                dutOut[loop-10] = median;
                if (dutOut[loop-10] == simpleSortOut[loop-10]) begin
                    $display ("%b | %b | PASS", dutOut[loop-10], simpleSortOut[loop-10]);
                    pass_counter++;
                end else begin
                    $display ("%b | %b | FAIL", dutOut[loop-10], simpleSortOut[loop-10]);
                    fail_counter++;
                end
            end
            #40;
        
            foreach (rndArr[i]) begin
                rndArr[i] = $urandom & 8'hFF;
            end
    
            arr1 = new(rndArr);

        end
    
        $display ("%0d PASSED | %0d FAILED", pass_counter, fail_counter);
    
        #50 $finish;
    
    end

endmodule