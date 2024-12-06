module traffic #(parameter SLOT = 15,Shift=5) (clk, rst, sensors, traffic1,traffic2,traffic3,traffic4);
input clk, rst;
output reg [2:0] traffic1,traffic2,traffic3,traffic4;
input [8:1] sensors;

parameter T1 = 4'b0001, T2 = 4'b0010, T3 = 4'b0100, T4 = 4'b1000;
parameter Green = 3'b001, Yellow = 3'b010, Red = 3'b100;
parameter Double_slot=SLOT*2+Shift ,Single_Slot=SLOT+Shift;

reg [5:0] counter;
reg [3:0] current_state, next_state;


always @(posedge clk or posedge rst) begin
    if (rst) begin
        current_state = T1;
        counter <= sensors[1] & sensors[2] ? Double_slot : sensors[1] | sensors[2] ? Single_Slot : 1;
    end else if (counter > 1) begin
        counter <= counter - 1;
    end else begin
        current_state = next_state;
        case (current_state)
            T1: counter <= sensors[1] & sensors[2] ? Double_slot : sensors[1] | sensors[2] ? Single_Slot : 1;
            T2: counter <= sensors[3] & sensors[4] ? Double_slot : sensors[3] | sensors[4] ? Single_Slot : 1;
            T3: counter <= sensors[5] & sensors[6] ? Double_slot : sensors[5] | sensors[6] ? Single_Slot : 1;
            T4: counter <= sensors[7] & sensors[8] ? Double_slot : sensors[7] | sensors[8] ? Single_Slot : 1;
        endcase
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
    traffic1=Red;
    traffic2=Red;
    traffic3=Red;
    traffic4=Red;
    case(current_state)
        T1: traffic1 = ~(|sensors)?Green:(counter > Shift) ? Green : Yellow;
        T2: traffic2 = ~(|sensors)?Green:(counter > Shift) ? Green : Yellow;
        T3: traffic3 = ~(|sensors)?Green:(counter > Shift) ? Green : Yellow;
        T4: traffic4 = ~(|sensors)?Green:(counter > Shift) ? Green : Yellow;
    endcase
end

endmodule
