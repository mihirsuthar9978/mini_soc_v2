`timescale 1ns/1ps
//============================================================
// Module : apb_slave
// Description : APB3 Slave Interface
// Author : Mihir
//============================================================

module apb_slave(

    input wire PCLK,
    input wire PRESETn,

    input wire PSEL,
    input wire PENABLE,
    input wire PWRITE,

    input wire [7:0] PADDR,
    input wire [31:0] PWDATA,

    output reg [31:0] PRDATA,
    output reg PREADY,

    //--------------------------------------------------------
    // Counter
    //--------------------------------------------------------

    input wire [7:0] counter_value,

    //--------------------------------------------------------
    // ALU
    //--------------------------------------------------------

    output reg [7:0] alu_a,
    output reg [7:0] alu_b,
    output reg [2:0] alu_opcode,

    input wire [7:0] alu_result,

    //--------------------------------------------------------
    // Timer
    //--------------------------------------------------------

    output reg [7:0] timer_load,

    output reg timer_start,
    output reg timer_enable,

    input wire timer_done,
    input wire timer_running,

    //--------------------------------------------------------
    // GPIO
    //--------------------------------------------------------

    output reg [7:0] gpio_direction,
    output reg [7:0] gpio_write,

    input wire [7:0] gpio_read

);

//------------------------------------------------------------
// APB WRITE
//------------------------------------------------------------

always @(posedge PCLK or negedge PRESETn)

begin

    if(!PRESETn)

    begin

        alu_a <= 0;
        alu_b <= 0;
        alu_opcode <= 0;

        timer_load <= 0;
        timer_start <= 0;
        timer_enable <= 0;

        gpio_direction <= 0;
        gpio_write <= 0;

        PREADY <= 0;

    end

    else

    begin

        PREADY <= 0;
        timer_start <= 0;

        if(PSEL && PENABLE)

        begin

            PREADY <= 1;

            if(PWRITE)

            begin

                case(PADDR)

                8'h04:
                    alu_a <= PWDATA[7:0];

                8'h08:
                    alu_b <= PWDATA[7:0];

                8'h0C:
                    alu_opcode <= PWDATA[2:0];

                8'h14:
                    timer_load <= PWDATA[7:0];

                8'h18:

                begin
                    timer_start <= PWDATA[0];
                    timer_enable <= PWDATA[1];
                end

                8'h20:
                    gpio_direction <= PWDATA[7:0];

                8'h24:
                    gpio_write <= PWDATA[7:0];

                endcase

            end

        end

    end

end

//------------------------------------------------------------
// APB READ
//------------------------------------------------------------

always @(*)

begin

    PRDATA = 32'h00000000;

    if(PSEL && !PWRITE)

    begin

        case(PADDR)

        8'h00:
            PRDATA = {24'h0,counter_value};

        8'h10:
            PRDATA = {24'h0,alu_result};

        8'h1C:
            PRDATA = {30'b0,timer_running,timer_done};

        8'h28:
            PRDATA = {24'h0,gpio_read};

        default:
            PRDATA = 32'h00000000;

        endcase

    end

end

endmodule
