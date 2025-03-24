//Odd-even sorting logic that outputs median 8-bit value of 9 grayscale pixels

module selectMedian (
    input logic clk, rst,
    input logic [7:0] px0, px1, px2, px3, px4, px5, px6, px7, px8,
    output logic [7:0] median
);

    logic [7:0] inputArray [8:0];
    logic [7:0] sortedArray [8:0];
    logic [7:0] ppl1 [8:0], ppl2 [8:0], ppl3 [8:0], ppl4 [8:0], ppl5 [8:0], ppl6 [8:0], ppl7 [8:0], ppl8 [8:0];
    logic [7:0] stg1_out[8:0], stg2_out[8:0], stg3_out[8:0], stg4_out[8:0], stg5_out[8:0], stg6_out[8:0], stg7_out[8:0], stg8_out[8:0], stg9_out[8:0];
    //pipelined so that module can output one pixel for each clock cycle    

    always_ff @(posedge clk or posedge rst) begin
        if (rst) 
            ppl1 = '{8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};
            ppl2 = '{8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};
            ppl3 = '{8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};
            ppl4 = '{8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};
            ppl5 = '{8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};
            ppl6 = '{8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};
            ppl7 = '{8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};
            ppl8 = '{8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};
            initialArray = '{8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};
            sortedArray = '{8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};
        else
            initialArray[0] <= px0;
            initialArray[1] <= px1;
            initialArray[2] <= px2;
            initialArray[3] <= px3;    
            initialArray[4] <= px4;
            initialArray[5] <= px5;
            initialArray[6] <= px6;
            initialArray[7] <= px7;
            initialArray[8] <= px0;
            ppl1 <= stg1_out;
            ppl2 <= stg2_out;
            ppl3 <= stg3_out;
            ppl4 <= stg4_out;
            ppl5 <= stg5_out;
            ppl6 <= stg6_out;
            ppl7 <= stg7_out;
            ppl8 <= stg8_out;
            sortedArray <= stg9_out;
    end

    //sorting stage 1
    always_comb begin
        logic [7:0] temp1, temp2;
        logic [7:0] workingArray [8:0];
        
        workingArray = initialArray;
        
        if workingArray[1] < workingArray[0] begin
            temp1 = workingArray[0];
            temp2 = workingArray[1];
            workingArray[0] = temp2;
            workingArray[1] = temp1;
        end
        
        if workingArray[3] < workingArray[2] begin
            temp1 = workingArray[2];
            temp2 = workingArray[3];
            workingArray[2] = temp2;
            workingArray[3] = temp1;
        end

        if workingArray[5] < workingArray[4] begin
            temp1 = workingArray[4];
            temp2 = workingArray[5];
            workingArray[4] = temp2;
            workingArray[5] = temp1;
        end
        
        if workingArray[7] < workingArray[6] begin
            temp1 = workingArray[6];
            temp2 = workingArray[7];
            workingArray[6] = temp2;
            workingArray[7] = temp1;
        end

        stg1_out <= workingArray;
    end
    
    //sorting stage 2
    always_comb begin
        logic [7:0] temp1, temp2;
        logic [7:0] workingArray [8:0];
        
        workingArray = ppl1;
        
        if workingArray[2] < workingArray[0] begin
            temp1 = workingArray[0];
            temp2 = workingArray[2];
            workingArray[0] = temp2;
            workingArray[2] = temp1;
        end
        
        if workingArray[3] < workingArray[1] begin
            temp1 = workingArray[1];
            temp2 = workingArray[3];
            workingArray[1] = temp2;
            workingArray[3] = temp1;
        end

        if workingArray[6] < workingArray[4] begin
            temp1 = workingArray[4];
            temp2 = workingArray[6];
            workingArray[4] = temp2;
            workingArray[6] = temp1;
        end
        
        if workingArray[7] < workingArray[5] begin
            temp1 = workingArray[5];
            temp2 = workingArray[7];
            workingArray[5] = temp2;
            workingArray[7] = temp1;
        end

        stg2_out <= workingArray;
    end

    //sorting stage 3
    always_comb begin
        logic [7:0] temp1, temp2;
        logic [7:0] workingArray [8:0];
        
        workingArray = ppl2;
        
        if workingArray[2] < workingArray[1] begin
            temp1 = workingArray[1];
            temp2 = workingArray[2];
            workingArray[1] = temp2;
            workingArray[2] = temp1;
        end
        
        if workingArray[6] < workingArray[5] begin
            temp1 = workingArray[5];
            temp2 = workingArray[6];
            workingArray[5] = temp2;
            workingArray[6] = temp1;
        end

        stg3_out <= workingArray;
    end
    
    //sorting stage 4
    always_comb begin
        logic [7:0] temp1, temp2;
        logic [7:0] workingArray [8:0];
        
        workingArray = ppl3;
        
        if workingArray[4] < workingArray[0] begin
            temp1 = workingArray[0];
            temp2 = workingArray[4];
            workingArray[0] = temp2;
            workingArray[4] = temp1;
        end
        
        if workingArray[5] < workingArray[1] begin
            temp1 = workingArray[1];
            temp2 = workingArray[5];
            workingArray[1] = temp2;
            workingArray[5] = temp1;
        end

        if workingArray[6] < workingArray[2] begin
            temp1 = workingArray[2];
            temp2 = workingArray[6];
            workingArray[2] = temp2;
            workingArray[6] = temp1;
        end
        
        if workingArray[7] < workingArray[3] begin
            temp1 = workingArray[3];
            temp2 = workingArray[7];
            workingArray[3] = temp2;
            workingArray[7] = temp1;
        end

        stg4_out <= workingArray;
    end

    //sorting stage 5
    always_comb begin
        logic [7:0] temp1, temp2;
        logic [7:0] workingArray [8:0];
        
        workingArray = ppl4;
        
        if workingArray[4] < workingArray[2] begin
            temp1 = workingArray[2];
            temp2 = workingArray[4];
            workingArray[2] = temp2;
            workingArray[4] = temp1;
        end
        
        if workingArray[5] < workingArray[3] begin
            temp1 = workingArray[3];
            temp2 = workingArray[5];
            workingArray[3] = temp2;
            workingArray[5] = temp1;
        end

        stg5_out <= workingArray;
    end

    //sorting stage 6
    always_comb begin
        logic [7:0] temp1, temp2;
        logic [7:0] workingArray [8:0];
        
        workingArray = ppl5;
        
        if workingArray[8] < workingArray[0] begin
            temp1 = workingArray[0];
            temp2 = workingArray[8];
            workingArray[0] = temp2;
            workingArray[8] = temp1;
        end
        
        if workingArray[2] < workingArray[1] begin
            temp1 = workingArray[1];
            temp2 = workingArray[2];
            workingArray[1] = temp2;
            workingArray[2] = temp1;
        end

        if workingArray[4] < workingArray[3] begin
            temp1 = workingArray[3];
            temp2 = workingArray[4];
            workingArray[3] = temp2;
            workingArray[4] = temp1;
        end
        
        if workingArray[6] < workingArray[5] begin
            temp1 = workingArray[5];
            temp2 = workingArray[6];
            workingArray[5] = temp2;
            workingArray[6] = temp1;
        end

        stg6_out <= workingArray;
    end

    //sorting stage 7
    always_comb begin
        logic [7:0] temp1, temp2;
        logic [7:0] workingArray [8:0];
        
        workingArray = ppl6
        
        if workingArray[8] < workingArray[4] begin
            temp1 = workingArray[4];
            temp2 = workingArray[8];
            workingArray[4] = temp2;
            workingArray[8] = temp1;
        end
        
        stg7_out <= workingArray;
    end

    //sorting stage 8
    always_comb begin
        logic [7:0] temp1, temp2;
        logic [7:0] workingArray [8:0];
        
        workingArray = ppl7;
        
        if workingArray[4] < workingArray[2] begin
            temp1 = workingArray[2];
            temp2 = workingArray[4];
            workingArray[2] = temp2;
            workingArray[4] = temp1;
        end
        
        if workingArray[5] < workingArray[3] begin
            temp1 = workingArray[3];
            temp2 = workingArray[5];
            workingArray[3] = temp2;
            workingArray[5] = temp1;
        end

        stg8_out <= workingArray;
    end

    //sorting stage 1
    always_comb begin
        logic [7:0] temp1, temp2;
        logic [7:0] workingArray [8:0];
        
        workingArray = ppl8;
        
        if workingArray[4] < workingArray[3] begin
            temp1 = workingArray[3];
            temp2 = workingArray[4];
            workingArray[3] = temp2;
            workingArray[4] = temp1;
        end

        stg9_out <= workingArray;
    end

    always_comb begin
        median <= sortedArray[4];
    end

endmodule;    