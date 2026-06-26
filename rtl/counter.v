`timescale 1ns/1ps
//============================================================
// Module : counter
// Description : Parameterized Synchronous Up Counter
// Author : Mihir
//============================================================

module counter #(
    parameter WIDTH = 8
)(
    input  wire             clk,
    input  wire             rst,
    input  wire             enable,

    output reg  [WIDTH-1:0] count,
    output reg              overflow
);

always @(posedge clk) begin

    if (rst) begin
        count     <= {WIDTH{1'b0}};
        overflow  <= 1'b0;
    end

    else if (enable) begin

        if (count == {WIDTH{1'b1}}) begin
            count     <= {WIDTH{1'b0}};
            overflow  <= 1'b1;
        end
        else begin
            count     <= count + 1'b1;
            overflow  <= 1'b0;
        end

    end

    else begin
        count     <= count;
        overflow  <= 1'b0;
    end

end

endmodule
