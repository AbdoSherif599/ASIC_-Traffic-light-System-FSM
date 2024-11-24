`timescale 100ms/100ms

module tb;

reg clk, rst;
reg [8:1] sensors;

wire [4:1] result;

initial begin
    $dumpfile("test.fst");
    $dumpvars(0, tb);

    clk = 0;
    rst = 0;

    // Resetting Feature
    #11
    sensors = 'b1010;
    #22
    rst = 1;
    #4
    rst = 0;

    #1000
    $finish;
end

always #5 clk =~clk;

traffic #(.SLOT(5)) dut(.clk(clk), .rst(rst), .sensors(sensors), .traffic(result));

endmodule
