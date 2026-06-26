`timescale 1ns/1ps
//============================================================
// Module : timer
// Description : Parameterized Countdown Timer IP
// Author : Mihir
//============================================================

module timer #(
    parameter WIDTH = 8
)(
    input  wire                 clk,
    input  wire                 rst,

    input  wire                 start,
    input  wire                 enable,

    input  wire [WIDTH-1:0]     load_value,

    output reg  [WIDTH-1:0]     count,
    output reg                  done,
    output reg                  running
);

//------------------------------------------------------------
// Timer Logic
//------------------------------------------------------------

always @(posedge clk) begin

    //--------------------------------------------------------
    // Reset
    //--------------------------------------------------------

    if (rst) begin
        count   <= {WIDTH{1'b0}};
        done    <= 1'b0;
        running <= 1'b0;
    end

    //--------------------------------------------------------
    // Start Timer
    //--------------------------------------------------------

    else if (start) begin
        count   <= load_value;
        running <= 1'b1;
        done    <= 1'b0;
    end

    //--------------------------------------------------------
    // Timer Running
    //--------------------------------------------------------

    else if (running && enable) begin

        if (count > 0) begin
            count <= count - 1'b1;
            done  <= 1'b0;
        end

        else begin
            running <= 1'b0;
            done    <= 1'b1;
        end

    end

    //--------------------------------------------------------
    // Hold State
    //--------------------------------------------------------

    else begin
        count   <= count;
        running <= running;
        done    <= done;
    end

end

endmodule
