`timescale 1ns/1ps

module gpio_tb;

parameter WIDTH = 8;

reg clk;
reg rst;

reg write_enable;

reg [WIDTH-1:0] direction;
reg [WIDTH-1:0] write_data;

reg [WIDTH-1:0] gpio_in;

wire [WIDTH-1:0] gpio_out;
wire [WIDTH-1:0] gpio_read;

gpio #(
    .WIDTH(WIDTH)
) dut(

    .clk(clk),
    .rst(rst),

    .write_enable(write_enable),

    .direction(direction),
    .write_data(write_data),

    .gpio_in(gpio_in),

    .gpio_out(gpio_out),
    .gpio_read(gpio_read)

);

always #5 clk = ~clk;

initial begin

    clk = 0;
    rst = 1;

    write_enable = 0;

    direction = 8'b00000000;
    write_data = 8'h00;
    gpio_in = 8'h00;

    $dumpfile("gpio.vcd");
    $dumpvars(0,gpio_tb);

    $display("----------------------------------------------");
    $display("Time\tDIR\tGPIO_IN\tGPIO_OUT\tGPIO_READ");
    $display("----------------------------------------------");

    $monitor("%0t\t%b\t%b\t%b\t%b",
             $time,
             direction,
             gpio_in,
             gpio_out,
             gpio_read);

    //--------------------------------------
    // Reset
    //--------------------------------------

    #20;
    rst = 0;

    //--------------------------------------
    // Configure upper nibble as outputs
    //--------------------------------------

    direction = 8'b11110000;

    //--------------------------------------
    // Write Output
    //--------------------------------------

    write_data = 8'b10100000;
    write_enable = 1;

    #10;
    write_enable = 0;

    //--------------------------------------
    // External Inputs
    //--------------------------------------

    gpio_in = 8'b00001111;

    #40;

    //--------------------------------------
    // Change Inputs
    //--------------------------------------

    gpio_in = 8'b00000101;

    #40;

    //--------------------------------------
    // Write Again
    //--------------------------------------

    write_data = 8'b11010000;

    write_enable = 1;

    #10;

    write_enable = 0;

    #60;

    $finish;

end

endmodule
