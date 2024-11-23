module tb;

reg clk, rst;
reg [8:1] sensors;

wire [4:1] result;

initial begin
    $dumpfile("test.fst");
    $dumpvars(0, tb);

    clk = 0;
    sensors = 'b01010101;
    rst = 0;

    #500
    $finish;
end

always #5 clk =~clk;

traffic dut(.clk(clk), .rst(rst), .sensors(sensors), .traffic(result));

endmodule
