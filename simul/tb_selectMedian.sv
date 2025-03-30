class testArray;
logic [7:0] array [8:0];
logic [7:0] testMedianValue;

function new();
    rand logic [7:0] randomArray [8:0];
    this.array = randomArray;
    testMedianValue = 8b'00000000;
endfunction;

function simpleSort();
    logic [7:0] temp;
    for (int i = 0; i < 8, i++) begin
        for (int j = 0, j < 8-i, j++) begin
            if (array[j] > array[j+1]) begin
                temp = array[j];
                array[j] = array[j+1];
                array[j+1] = temp;
            end
        end
    end
    testMedianValue = array[4];
endfunction;

function getArray();
    return array;
endfunction;

function getMedian();
    return testMedianValue;
endfunction;
endclass;


module tb_selectMedian ();

param int testDepth = 49; //number of tests

testArray arr1;
logic clk, rst;
logic eval;
logic [7:0] px0, px1, px2, px3, px4, px5, px6, px7, px8;
logic [7:0] median;
logic [7:0] workingArray [8:0];
logic [7:0] simpleSortOut [testDepth:0], dutOut [testDepth:0];

//dut instantiation
selectMedian DUT (
    .clk(clk),
    .rst(rst),
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
    arr1 = new();

    #15 rst = 0;
    for (loop = 0; loop < testDepth+10; loop++) begin
        workingArray = arr1.getArray();
        px0 = workingArray[0];
        px1 = workingArray[1];
        px2 = workingArray[2];
        px3 = workingArray[3];
        px4 = workingArray[4];
        px5 = workingArray[5];
        px6 = workingArray[6];
        px7 = workingArray[7];
        px8 = workingArray[8];
        simpleSort(arr1);
        if (loop < testDepth) begin
            simpleSortOut[loop] = arr1.getMedian();
        end
        if (loop > 9) begin
            dutOut[loop-10] = median;
            if (dutOut[loop-10] == simpleSortOut[loop-10])
                $display ("%b | %b | PASS", dutOut[loop-10], simpleSortOut[loop-10]);
            else
                $display ("%b | %b | FAIL", dutOut[loop-10], simpleSortOut[loop-10]);
        end
        #20;        
    end
    #50 $finish;
end

endmodule;    