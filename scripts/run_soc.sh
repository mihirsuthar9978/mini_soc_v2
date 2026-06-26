#!/bin/bash

echo "======================================"
echo "      Mini SoC Simulation"
echo "======================================"

# Clean previous build
rm -f mini_soc.vvp
rm -f mini_soc.vcd

echo "Compiling..."

iverilog -g2012 \
-o mini_soc.vvp \
rtl/counter.v \
rtl/alu.v \
rtl/timer.v \
rtl/gpio.v \
rtl/apb_slave.v \
rtl/mini_soc.v \
tb/mini_soc_tb.v

if [ $? -ne 0 ]; then
    echo "Compilation Failed!"
    exit 1
fi

echo "Running Simulation..."

vvp mini_soc.vvp

echo "Opening GTKWave..."

gtkwave mini_soc.vcd
