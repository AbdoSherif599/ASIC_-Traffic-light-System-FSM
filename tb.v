`timescale 100ms/100ms

module tb;

reg clk, rst;
reg [8:1] sensors;
wire [2:0] traffic1,traffic2,traffic3,traffic4;
integer testing_success;


always #1 clk =~clk;

traffic #(.SLOT(15),.Shift(3)) dut(.clk(clk), .rst(rst), .sensors(sensors),.traffic1(traffic1),.traffic2(traffic2),.traffic3(traffic3),.traffic4(traffic4));
task check_traffic_state(
    input [2:0] expected_traffic1,
    input [2:0] expected_traffic2,
    input [2:0] expected_traffic3,
    input [2:0] expected_traffic4,
    input integer step_number
);
begin
    if (traffic1 == expected_traffic1 && traffic2 == expected_traffic2 &&
        traffic3 == expected_traffic3 && traffic4 == expected_traffic4) begin
        $display("Step %0d: Success! Traffic signals are as expected:", step_number);
        $display("Traffic1: %s, Traffic2: %s, Traffic3: %s, Traffic4: %s",
                 (expected_traffic1 == 3'b001) ? "Green" :
                 (expected_traffic1 == 3'b010) ? "Yellow" : "Red",
                 (expected_traffic2 == 3'b001) ? "Green" :
                 (expected_traffic2 == 3'b010) ? "Yellow" : "Red",
                 (expected_traffic3 == 3'b001) ? "Green" :
                 (expected_traffic3 == 3'b010) ? "Yellow" : "Red",
                 (expected_traffic4 == 3'b001) ? "Green" :
                 (expected_traffic4 == 3'b010) ? "Yellow" : "Red");
    end else begin
        $error("Step %0d: Failed! Expected traffic signals: T1=%s, T2=%s, T3=%s, T4=%s | Actual traffic signals: T1=%s, T2=%s, T3=%s, T4=%s",
               step_number,
               (expected_traffic1 == 3'b001) ? "Green" :
               (expected_traffic1 == 3'b010) ? "Yellow" : "Red",
               (expected_traffic2 == 3'b001) ? "Green" :
               (expected_traffic2 == 3'b010) ? "Yellow" : "Red",
               (expected_traffic3 == 3'b001) ? "Green" :
               (expected_traffic3 == 3'b010) ? "Yellow" : "Red",
               (expected_traffic4 == 3'b001) ? "Green" :
               (expected_traffic4 == 3'b010) ? "Yellow" : "Red",
               (traffic1 == 3'b001) ? "Green" :
               (traffic1 == 3'b010) ? "Yellow" : "Red",
               (traffic2 == 3'b001) ? "Green" :
               (traffic2 == 3'b010) ? "Yellow" : "Red",
               (traffic3 == 3'b001) ? "Green" :
               (traffic3 == 3'b010) ? "Yellow" : "Red",
               (traffic4 == 3'b001) ? "Green" :
               (traffic4 == 3'b010) ? "Yellow" : "Red");
               testing_success=0;
    end
end
endtask


initial begin

    clk = 0;
    rst = 0;
    testing_success=1;

    // Resetting Feature
    $display("Testing reset then testing if traffic 1 and traffic 2 are half congested");
    @(negedge clk);
    sensors = 'b00001010;
    rst = 1;
    @(negedge clk);
    rst = 0;
    check_traffic_state(1,4,4,4,1);
    repeat(15)@(negedge clk);
    check_traffic_state(2,4,4,4,1);
    repeat(3)@(negedge clk);
   check_traffic_state(4,1,4,4,1);
    repeat(15)@(negedge clk);
    check_traffic_state(4,2,4,4,1);
    repeat(3)@(negedge clk);
        check_traffic_state(1,4,4,4,1);
    repeat(15)@(negedge clk);
    check_traffic_state(2,4,4,4,1);
    repeat(3)@(negedge clk);
   check_traffic_state(4,1,4,4,1);
    repeat(15)@(negedge clk);
    check_traffic_state(4,2,4,4,1);
    sensors='b11111111;
    repeat(3)@(negedge clk);
        
    
   
    $display("\n\n\nTesting if all traffics are fully congested");
    //If all congested loop in order T1 to T4 waits 10s 
    
    check_traffic_state(4,4,1,4,2);
    repeat(30)@(negedge clk);
    check_traffic_state(4,4,2,4,2);
    repeat(3)@(negedge clk);
   check_traffic_state(4,4,4,1,2);
    repeat(30)@(negedge clk);
    check_traffic_state(4,4,4,2,2);
    repeat(3)@(negedge clk);
    check_traffic_state(1,4,4,4,2);
    repeat(30)@(negedge clk);
    check_traffic_state(2,4,4,4,2);
    repeat(3)@(negedge clk);
   check_traffic_state(4,1,4,4,2);
    repeat(30)@(negedge clk);
    check_traffic_state(4,2,4,4,2);
    sensors='b01110111;
    repeat(3)@(negedge clk);

   
    $display("\n\n\nTesting if  traffic 1 and traffic 3 are fully congested and traffic 2 and traffic 4 are half congested");
    //If sensors for T1 are all fired then it waits 10s or else 5s
     // T1 10 sec  T2 5 sec  T3 10 sec  T4 5 sec
    check_traffic_state(4,4,1,4,3);
    repeat(30)@(negedge clk);
    check_traffic_state(4,4,2,4,3);
    repeat(3)@(negedge clk);
   check_traffic_state(4,4,4,1,3);
    repeat(15)@(negedge clk);
    check_traffic_state(4,4,4,2,3);
    repeat(3)@(negedge clk);
    check_traffic_state(1,4,4,4,3);
    repeat(30)@(negedge clk);
    check_traffic_state(2,4,4,4,3);
    repeat(3)@(negedge clk);
   check_traffic_state(4,1,4,4,3);
    repeat(15)@(negedge clk);
    check_traffic_state(4,2,4,4,3);
    sensors='b01000001; // fire T4 and T1 only
    repeat(3)@(negedge clk);

 
    //Fire the next congested Traffic in order
    $display("\n\n\nTesting Fire the next congested Traffic in order ,if  traffic 1 and traffic 4 are half congested");
    
    check_traffic_state(4,4,4,1,4);
    repeat(15)@(negedge clk);
    check_traffic_state(4,4,4,2,4);
    repeat(3)@(negedge clk);
   check_traffic_state(1,4,4,4,4);
    repeat(15)@(negedge clk);
    check_traffic_state(2,4,4,4,4);
    repeat(3)@(negedge clk);
    check_traffic_state(4,4,4,1,4);
    repeat(15)@(negedge clk);
    check_traffic_state(4,4,4,2,4);
    repeat(3)@(negedge clk);
   check_traffic_state(1,4,4,4,4);
    repeat(15)@(negedge clk);
    check_traffic_state(2,4,4,4,4);
    sensors='b01;//fire T1 only
    repeat(3)@(negedge clk);


    
    $display("\n\n\nTesting Fire the next congested Traffic in order ,if  traffic 1 is half congested");
     check_traffic_state(1,4,4,4,5);
    repeat(15)@(negedge clk);
    check_traffic_state(2,4,4,4,5);
    repeat(3)@(negedge clk);
    check_traffic_state(1,4,4,4,5);
    repeat(15)@(negedge clk);
    check_traffic_state(2,4,4,4,5);
    repeat(3)@(negedge clk);
    check_traffic_state(1,4,4,4,5);
    repeat(15)@(negedge clk);
    check_traffic_state(2,4,4,4,5);
    sensors='b0; // no sensor read
    repeat(3)@(negedge clk);    
    
     $display("\n\n\nTesting Stayin current state if no congested traffic");
    check_traffic_state(1,4,4,4,6);
    repeat(15)@(negedge clk);
    check_traffic_state(1,4,4,4,6);
    repeat(15)@(negedge clk);
    check_traffic_state(1,4,4,4,6);
    repeat(15)@(negedge clk);
    check_traffic_state(1,4,4,4,6);
    repeat(15)@(negedge clk);
    sensors='b01000000; // act after getting any read of the sensors
    repeat(3)@(negedge clk);    
    
$display("\n\n\nTesting act after getting any read of the sensors, in this case traffic 4 is half congested");
    
    check_traffic_state(4,4,4,1,7);
    repeat(15)@(negedge clk);
    check_traffic_state(4,4,4,2,7);
    repeat(3)@(negedge clk);
    check_traffic_state(4,4,4,1,7);
    repeat(15)@(negedge clk);
    check_traffic_state(4,4,4,2,7);
    repeat(3)@(negedge clk);    
    


if (testing_success==1) begin
     $display("\n\n\nModule passed test successfuly.");
end
else begin
  $error("\n\n\nModule didnot pass test ");
end
       
        $stop;
    end







endmodule
