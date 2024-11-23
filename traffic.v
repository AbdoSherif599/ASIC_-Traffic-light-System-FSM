module traffic (clk, rst, sensors, traffic);
input clk, rst;
output reg [4:1] traffic;
input [8:1] sensors;

parameter T1 = 4'b0001, T2 = 4'b0010, T3 = 4'b0100, T4 = 4'b1000;

reg [3:0] current_state, next_state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        current_state <= T1;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        T1: begin
            if (sensors[3] | sensors[4]) next_state = T2;
            else if (sensors[5] | sensors[6]) next_state = T3;
            else if (sensors[7] | sensors[8]) next_state = T4;
            else next_state = T1;
        end
        T2: begin
            if (sensors[5] | sensors[6]) next_state = T3;
            else if (sensors[7] | sensors[8]) next_state = T4;
            else if (sensors[1] | sensors[2]) next_state = T1;
            else next_state = T2;
        end
        T3: begin
            if (sensors[7] | sensors[8]) next_state = T4;
            else if (sensors[1] | sensors[2]) next_state = T1;
            else if (sensors[3] | sensors[4]) next_state = T2;
            else next_state = T3;
        end
        T4: begin
            if (sensors[1] | sensors[2]) next_state = T1;
            else if (sensors[3] | sensors[4]) next_state = T2;
            else if (sensors[5] | sensors[6]) next_state = T3;
            else next_state = T4;
        end
        default: next_state = T1;
    endcase
end

always @(*) begin
    case(current_state)
        T1: begin
            traffic = T1;
        end
        T2: begin
           traffic = T2;
        end
        T3: begin
           traffic = T3;
        end
        T4: begin
           traffic = T4;
        end
        default: traffic = 0;
    endcase
end

endmodule
