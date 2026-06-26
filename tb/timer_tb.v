`timescale 1ns/1ps
//============================================================
// Testbench : timer_tb
// Description : Verification of Countdown Timer IP
//============================================================

module timer_tb;

parameter WIDTH = 8;

// Inputs
reg clk;
reg rst;
reg start;
reg enable;
reg [WIDTH-1:0] load_value;

// Outputs
wire [WIDTH-1:0] count;
wire done;
wire running;

//------------------------------------------------------------
// DUT
//------------------------------------------------------------

timer #(
    .WIDTH(WIDTH)
) dut (

    .clk(clk),
    .rst(rst),
    .start(start),
    .enable(enable),
    .load_value(load_value),

    .count(count),
    .done(done),
    .running(running)

);

//------------------------------------------------------------
// Clock Generation
//------------------------------------------------------------

always #5 clk = ~clk;

//------------------------------------------------------------
// Waveform Dump
//------------------------------------------------------------

initial begin

    $dumpfile("timer.vcd");
    $dumpvars(0, timer_tb);

    $display("-------------------------------------------------------------");
    $display("Time\tStart\tEnable\tLoad\tCount\tRun\tDone");
    $display("-------------------------------------------------------------");

    $monitor("%0t\t%b\t%b\t%0d\t%0d\t%b\t%b",
              $time,
              start,
              enable,
              load_value,
              count,
              running,
              done);

end

//------------------------------------------------------------
// Stimulus
//------------------------------------------------------------

initial begin

    clk = 0;
    rst = 1;

    start = 0;
    enable = 0;

    load_value = 0;

    //-------------------------
    // Reset
    //-------------------------

    #20;
    rst = 0;

    //-------------------------
    // Load timer with 10
    //-------------------------

    load_value = 10;
    start = 1;

    #10;
    start = 0;
    enable = 1;

    //-------------------------
    // Pause Timer
    //-------------------------

    #40;
    enable = 0;

    //-------------------------
    // Resume Timer
    //-------------------------

    #30;
    enable = 1;

    //-------------------------
    // Wait until completion
    //-------------------------

    #120;

    //-------------------------
    // Second Test
    //-------------------------

    load_value = 5;
    start = 1;

    #10;
    start = 0;

    #80;

    $display("--------------------------------");
    $display("Timer Test Completed");
    $display("--------------------------------");

    $finish;

end

endmodule
