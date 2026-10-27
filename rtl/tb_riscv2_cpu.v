`timescale 1ns/1ps

module tb_riscv2_cpu;

reg clk;
reg reset;

//--------------------------------------------------
// Instantiate DUT
//--------------------------------------------------

riscv_pipeline_cpu dut(
    .clk(clk),
    .reset(reset)
);

//--------------------------------------------------
// Clock Generation (100 MHz)
//--------------------------------------------------

initial
begin
    clk = 0;
end

always #5 clk = ~clk;

//--------------------------------------------------
// Reset
//--------------------------------------------------

initial
begin
    reset = 1;

    #20;

    reset = 0;
end

//--------------------------------------------------
// Initialize Data Memory
//--------------------------------------------------
integer i;
initial
begin
    // Give time for reset
    #1

    // Inputs for application program
    dut.DMEM.memory[0] = 32'd10;
    dut.DMEM.memory[1] = 32'd20;

    // Clear remaining memory
    
    for(i=2;i<256;i=i+1)
        dut.DMEM.memory[i]=0;
end

//--------------------------------------------------
// VCD Dump
//--------------------------------------------------

initial
begin

    $dumpfile("pipeline.vcd");

    // Dump entire processor hierarchy
    $dumpvars(0,tb_riscv2_cpu);

end

//--------------------------------------------------
// Run Simulation
//--------------------------------------------------

initial
begin

    #1000;

    $finish;

end

endmodule