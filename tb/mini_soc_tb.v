`timescale 1ns/1ps

module mini_soc_tb;

//-----------------------------------------------------
// APB Interface Signals
//-----------------------------------------------------

reg         PCLK;
reg         PRESETn;
reg         PSEL;
reg         PENABLE;
reg         PWRITE;

reg  [7:0]  PADDR;
reg  [31:0] PWDATA;

wire [31:0] PRDATA;
wire        PREADY;

// GPIO External Input

reg [7:0] gpio_in;

//-----------------------------------------------------
// DUT
//-----------------------------------------------------

mini_soc dut (

    .PCLK(PCLK),
    .PRESETn(PRESETn),

    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),

    .PADDR(PADDR),
    .PWDATA(PWDATA),

    .PRDATA(PRDATA),
    .PREADY(PREADY),

    .gpio_in(gpio_in)

);

//-----------------------------------------------------
// Clock Generation
//-----------------------------------------------------

always #5 PCLK = ~PCLK;

//-----------------------------------------------------
// APB WRITE TASK
//-----------------------------------------------------

task apb_write;

input [7:0] addr;
input [31:0] data;

begin

    @(posedge PCLK);

    PSEL    = 1'b1;
    PENABLE = 1'b0;
    PWRITE  = 1'b1;
    PADDR   = addr;
    PWDATA  = data;

    @(posedge PCLK);

    PENABLE = 1'b1;

    @(posedge PCLK);

    PSEL    = 1'b0;
    PENABLE = 1'b0;
    PWRITE  = 1'b0;

end

endtask

//-----------------------------------------------------
// APB READ TASK
//-----------------------------------------------------

task apb_read;

input [7:0] addr;

begin

    @(posedge PCLK);

    PSEL    = 1'b1;
    PENABLE = 1'b0;
    PWRITE  = 1'b0;
    PADDR   = addr;

    @(posedge PCLK);

    PENABLE = 1'b1;

    @(posedge PCLK);

    $display("-------------------------------------");
    $display("READ ADDRESS : 0x%0h", addr);
    $display("READ DATA    : 0x%08h", PRDATA);
    $display("-------------------------------------");

    PSEL    = 1'b0;
    PENABLE = 1'b0;

end

endtask

//-----------------------------------------------------
// Stimulus
//-----------------------------------------------------

initial begin

    //----------------------------
    // Initialize
    //----------------------------

    PCLK     = 0;
    PRESETn  = 0;

    PSEL     = 0;
    PENABLE  = 0;
    PWRITE   = 0;

    PADDR    = 0;
    PWDATA   = 0;

    gpio_in  = 8'h00;

    //----------------------------
    // Waveform
    //----------------------------

    $dumpfile("mini_soc.vcd");
    $dumpvars(0, mini_soc_tb);

    //----------------------------
    // Apply Reset
    //----------------------------

    #20;
    PRESETn = 1;

    //-------------------------------------------------
    // ALU TEST
    //-------------------------------------------------

    // Operand A = 15
    apb_write(8'h04, 32'd15);

    // Operand B = 10
    apb_write(8'h08, 32'd10);

    // ADD
    apb_write(8'h0C, 32'd0);

    #20;

    apb_read(8'h10);

    //-------------------------------------------------
    // SUBTRACT
    //-------------------------------------------------

    apb_write(8'h0C, 32'd1);

    #20;

    apb_read(8'h10);

    //-------------------------------------------------
    // TIMER TEST
    //-------------------------------------------------

    apb_write(8'h14, 32'd8);

    // start=1 enable=1

    apb_write(8'h18, 32'b11);

    #120;

    apb_read(8'h1C);

    //-------------------------------------------------
    // GPIO TEST
    //-------------------------------------------------

    gpio_in = 8'h55;

    // Direction Register

    apb_write(8'h20, 32'hF0);

    // Output Register

    apb_write(8'h24, 32'hA0);

    #20;

    apb_read(8'h28);

    //-------------------------------------------------
    // Counter Test
    //-------------------------------------------------

    #80;

    apb_read(8'h00);

    //-------------------------------------------------
    // Finish
    //-------------------------------------------------

    #50;

    $display("------------------------------------");
    $display(" MINI SOC TEST COMPLETED ");
    $display("------------------------------------");

    $finish;

end

endmodule
