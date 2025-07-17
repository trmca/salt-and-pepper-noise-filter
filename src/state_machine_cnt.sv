module state_machine_cnt(
    input logic clk, nres,
    output logic ram_rd_en, ram_wr_en, fifo1_wr_en, fifo1_rd_en, fifo2_wr_en, fifo2_rd_en, sort_en,
    output logic [15:0] ram_wr_addr, ram_rd_addr
    );
        
typedef enum {idle, initialization, sorting_state, done} state;
logic [9:0] counter;
logic [7:0] wr_x, wr_y;
state curr_state, next_state;

always_ff @(posedge clk) begin
    if (!nres) begin
        curr_state <= idle;
        counter <= 10'b0;
    end    
    else begin
        curr_state <= next_state;
        if (curr_state == initialization) begin
            counter <= counter + 1'b1;
            wr_x = 8'b00000000;
            wr_y = 8'b00000001;
        end    
        else if (curr_state == sorting_state) begin
           if (wr_x == 8'b11111110) begin
                wr_x <= 8'b0;
                wr_y <= wr_y + 1;
           end    
           else
                wr_x <= wr_x + 1'b1;                    
        end
        else begin
            wr_x <= 8'b0;
            wr_y <= 8'b0;
            counter <= 10'b0;
        end
    end       
end

always_comb begin
    if (curr_state == idle)
        next_state = initialization;
    else if (curr_state == initialization) begin
        if (counter == 526)
            next_state = sorting_state;
        else
            next_state = curr_state;    
    end
    else if (curr_state == sorting_state) begin
        if (wr_x == 8'b11111110 && wr_y == 8'b11111110)
            next_state = done;
        else
            next_state = curr_state;    
    end                
    else
        next_state = curr_state;
end

always_comb begin
    case(curr_state)
    idle: begin
        ram_rd_en = 0;
        ram_wr_en = 0;
        fifo1_rd_en = 0;
        fifo1_wr_en = 0;
        fifo2_rd_en = 0;
        fifo2_wr_en = 0;
        sort_en = 0;
        ram_rd_addr = 0;
        ram_wr_addr = 0;
    end
    initialization: begin
        ram_rd_en = 1;
        ram_rd_addr = counter;
        if (counter >= 5)
            fifo1_wr_en = 1;
        else
            fifo1_wr_en = 0;
        if (counter >= 257)
            fifo1_rd_en = 1;
        else
            fifo1_rd_en = 0;    
        if (counter >= 261)
            fifo2_wr_en = 1;
        else
            fifo2_wr_en = 0;    
        if (counter >= 513)
            fifo2_rd_en = 1;
        else
            fifo2_rd_en = 0;
        if (counter >= 516)
            sort_en = 1;
        else    
            sort_en = 0;                        
    end
    sorting_state: begin
        ram_rd_en = 1;
        fifo1_wr_en = 1;
        fifo1_rd_en = 1;
        fifo2_wr_en = 1;
        fifo2_rd_en = 1;
        sort_en = 1;
        ram_rd_addr = wr_y*256+wr_x+511;    
        //if ((wr_y*256+wr_x+1)%256 == 0 || (wr_y*256+wr_x+1)%256 == 1) begin
        //    ram_wr_en = 0;
        //end
       // else begin     
            ram_wr_en = 1;
            ram_wr_addr = wr_y*256+wr_x;
      //  end
    end
    done: begin
        ram_rd_en = 0;
        ram_wr_en = 0;
        fifo1_wr_en = 0;
        fifo1_rd_en = 0;
        fifo2_wr_en = 0;
        fifo2_rd_en = 0;
        sort_en = 0;
    end   
    endcase 
end
  
endmodule
