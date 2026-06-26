`timescale 1ns/1ps
//============================================================
// Module : gpio
// Description : Parameterized GPIO Peripheral
// Author : Mihir
//============================================================

module gpio #(
    parameter WIDTH = 8
)(
    input  wire                 clk,
    input  wire                 rst,

    input  wire                 write_enable,

    input  wire [WIDTH-1:0]     direction,
    input  wire [WIDTH-1:0]     write_data,

    input  wire [WIDTH-1:0]     gpio_in,

    output reg  [WIDTH-1:0]     gpio_out,
    output wire [WIDTH-1:0]     gpio_read
);

integer i;

//------------------------------------------------------------
// Output Register
//------------------------------------------------------------

always @(posedge clk) begin

    if(rst)
        gpio_out <= {WIDTH{1'b0}};

    else if(write_enable)
        gpio_out <= write_data;

end

//------------------------------------------------------------
// Read Logic
//------------------------------------------------------------

generate

genvar k;

for(k=0;k<WIDTH;k=k+1)

begin : GPIO_READ

assign gpio_read[k] = direction[k] ?
                      gpio_out[k] :
                      gpio_in[k];

end

endgenerate

endmodule
