`timescale 100ms/100ms

module tb;

reg clk, rst;
reg [8:1] sensors;
integer file_id,file_id2,i;

wire [4:1] result,result_tb,result_correct;
reg  [7:0] correct_values [9:0];
reg  [7:0] tb_values [9:0];

initial begin
    $dumpfile("test.fst");
    $dumpvars(0, tb);
    file_id=$fopen("test_bench_test_values.txt","w");
    clk = 0;
    rst = 0;

    // Resetting Feature
    #11
    sensors = 'b1010;
    #22
    rst = 1;
    #4
    rst = 0;
    for ( i=0 ;i<10 ;i=i+1 ) begin
        $fwrite(file_id,"%h\n",result);
        #50;
    end
   
    //If all congested loop in order T1 to T4 waits 10s 
    sensors='b11111111;
    for ( i=0 ;i<8 ;i=i+1 ) begin
        $fwrite(file_id,"%h\n",result);
        #100;
    end
   
    
    //If sensors for T1 are all fired then it waits 10s or else 5s
    sensors='b01110111; // T1 10 sec  T2 5 sec  T3 10 sec  T4 5 sec
    for ( i=0 ;i<12 ;i=i+1 ) begin
        $fwrite(file_id,"%h\n",result);
        #50;
    end

 
    //Fire the next congested Traffic in order
    sensors='b01000001; // fire T4 and T1 only
    for ( i=0 ;i<6 ;i=i+1 ) begin
        $fwrite(file_id,"%h\n",result);
        #50;
    end
    sensors='b01;//fire T1 only
     $fwrite(file_id,"%h\n",result);
    #200
    sensors='b0; // no sensor read
     $fwrite(file_id,"%h\n",result);
    #200
    sensors='b01000000; // act after getting any read of the sensors
     $fwrite(file_id,"%h\n",result);
    #200
    $fclose(file_id);
    

         $readmemh("test_bench_test_values.txt", tb_values);
        $readmemh("test_bench_correct_values.txt", correct_values);

        // Compare values
        $display("Comparing testbench values with correct values...");
        for (i = 0; i < 10; i = i + 1) begin
            if (tb_values[i] !== correct_values[i]) begin
                $display("Mismatch at line %0d: Testbench value = %h, Correct value = %h", i, tb_values[i], correct_values[i]);
            end else begin
                $display("Match at line %0d: %h", i, tb_values[i]);
            end
        end

        $display("File comparison completed successfully.");
        $finish;
    end






always #5 clk =~clk;

traffic #(.SLOT(5)) dut(.clk(clk), .rst(rst), .sensors(sensors), .traffic(result));

endmodule
