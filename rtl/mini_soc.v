`timescale 1ns/1ps
//============================================================
// Module : mini_soc
// Description : Mini SoC Top Level
// Author : Mihir
//============================================================

module mini_soc(

    //-----------------------------
    // APB Interface
    //-----------------------------

    input wire         PCLK,
    input wire         PRESETn,

    input wire         PSEL,
    input wire         PENABLE,
    input wire         PWRITE,

    input wire [7:0]   PADDR,
    input wire [31:0]  PWDATA,

    output wire [31:0] PRDATA,
    output wire        PREADY,

    //-----------------------------
    // External GPIO
    //-----------------------------

    input wire [7:0] gpio_in

);

//============================================================
// Internal Signals
//============================================================

// Counter

wire [7:0] counter_value;
wire counter_overflow;

// ALU

wire [7:0] alu_result;
wire zero;
wire carry;
wire overflow;

wire [7:0] alu_a;
wire [7:0] alu_b;
wire [2:0] alu_opcode;

// Timer

wire [7:0] timer_load;
wire timer_start;
wire timer_enable;

wire [7:0] timer_count;
wire timer_done;
wire timer_running;

// GPIO

wire [7:0] gpio_direction;
wire [7:0] gpio_write;
wire [7:0] gpio_read;
wire [7:0] gpio_out;

//============================================================
// Counter
//============================================================

counter #(
    .WIDTH(8)
)
u_counter(

    .clk(PCLK),
    .rst(~PRESETn),
    .enable(1'b1),

    .count(counter_value),
    .overflow(counter_overflow)

);

//============================================================
// ALU
//============================================================

alu #(
    .WIDTH(8)
)
u_alu(

    .a(alu_a),
    .b(alu_b),

    .opcode(alu_opcode),

    .result(alu_result),

    .zero(zero),
    .carry(carry),
    .overflow(overflow)

);

//============================================================
// Timer
//============================================================

timer #(
    .WIDTH(8)
)
u_timer(

    .clk(PCLK),
    .rst(~PRESETn),

    .start(timer_start),
    .enable(timer_enable),

    .load_value(timer_load),

    .count(timer_count),
    .done(timer_done),
    .running(timer_running)

);

//============================================================
// GPIO
//============================================================

gpio #(
    .WIDTH(8)
)
u_gpio(

    .clk(PCLK),
    .rst(~PRESETn),

    .write_enable(PSEL && PENABLE && PWRITE && (PADDR==8'h24)),

    .direction(gpio_direction),

    .write_data(gpio_write),

    .gpio_in(gpio_in),

    .gpio_out(gpio_out),
    .gpio_read(gpio_read)

);

//============================================================
// APB Slave
//============================================================

apb_slave u_apb(

    .PCLK(PCLK),
    .PRESETn(PRESETn),

    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),

    .PADDR(PADDR),
    .PWDATA(PWDATA),

    .PRDATA(PRDATA),
    .PREADY(PREADY),

    //---------------- Counter ----------------

    .counter_value(counter_value),

    //---------------- ALU ----------------

    .alu_a(alu_a),
    .alu_b(alu_b),
    .alu_opcode(alu_opcode),

    .alu_result(alu_result),

    //---------------- Timer ----------------

    .timer_load(timer_load),

    .timer_start(timer_start),
    .timer_enable(timer_enable),

    .timer_done(timer_done),
    .timer_running(timer_running),

    //---------------- GPIO ----------------

    .gpio_direction(gpio_direction),
    .gpio_write(gpio_write),

    .gpio_read(gpio_read)

);

endmodule
