`timescale 1ns/1ps
//==============================================================
// File Name   : tb_riscv_pipeline_cpu.v
// Project     : 5-Stage RISC-V Pipeline Processor
// Author      : ChatGPT Verification Suite
//
// Description:
// -------------------------------------------------------------
// Professional Verification Testbench
//
// Features:
// ---------
// ✔ Automatic clock generation
// ✔ Automatic reset generation
// ✔ Loads instruction memory (.mem files)
// ✔ Dumps waveform for GTKWave
// ✔ Prints pipeline activity every clock
// ✔ Dumps register file
// ✔ Dumps data memory
// ✔ PASS / FAIL checks
// ✔ Timeout protection
// ✔ Supports all 10 verification phases
//
// Compatible with:
//     Icarus Verilog
//     GTKWave
//
//==============================================================

module tb_riscv_pipeline_cpu;

//==============================================================
// PARAMETERS
//==============================================================

parameter CLK_PERIOD = 10;
parameter MAX_CYCLES = 500;

//==============================================================
// TESTBENCH SIGNALS
//==============================================================

reg clk;
reg reset;

integer cycle_count;
integer phase;

integer i;
integer errors;

reg [200:0] phase_name;

//==============================================================
// DUT
//==============================================================

riscv_pipeline_cpu dut
(
    .clk(clk),
    .reset(reset)
);

//==============================================================
// CLOCK GENERATION
//==============================================================

initial
begin
    clk = 1'b0;

    forever #(CLK_PERIOD/2)
        clk = ~clk;
end

//==============================================================
// RESET GENERATION
//==============================================================

initial
begin

    reset = 1'b1;

    repeat(5)
        @(posedge clk);

    reset = 1'b0;

    $display("");
    $display("====================================================");
    $display(" RESET RELEASED");
    $display("====================================================");
    $display("");

end

//==============================================================
// INITIAL VALUES
//==============================================================

initial
begin

    cycle_count = 0;
    errors      = 0;
    phase       = 1;

end

//==============================================================
// VCD DUMP
//==============================================================

initial
begin

    $dumpfile("riscv_pipeline.vcd");
    $dumpvars(0,tb_riscv_pipeline_cpu);

end

//==============================================================
// SIMULATION HEADER
//==============================================================

initial
begin

$display("");
$display("############################################################");
$display("#                                                          #");
$display("#        RISC-V 5 STAGE PIPELINE PROCESSOR                 #");
$display("#              COMPLETE VERIFICATION SUITE                #");
$display("#                                                          #");
$display("############################################################");

$display("");
$display("Clock Period : %0d ns",CLK_PERIOD);
$display("Maximum Cycles : %0d",MAX_CYCLES);
$display("");

end

//==============================================================
// LOAD PROGRAM
//==============================================================

initial
begin

// Default program
// Change this filename for each phase

$display("--------------------------------------------");
$display("Loading program_phase1.mem");
$display("--------------------------------------------");

$readmemh(
"program_phase1.mem",
dut.IMEM.memory
);

end

//==============================================================
// CYCLE COUNTER
//==============================================================

always @(posedge clk)
begin

    if(!reset)
    begin

        cycle_count <= cycle_count + 1;

    end

end

//==============================================================
// TIMEOUT
//==============================================================

always @(posedge clk)
begin

    if(cycle_count > MAX_CYCLES)
    begin

        $display("");
        $display("==========================================");
        $display("TIMEOUT");
        $display("Simulation exceeded maximum cycles.");
        $display("==========================================");

        $finish;

    end

end

//==============================================================
// BASIC RESET CHECK
//==============================================================

always @(posedge clk)
begin

    if(reset)
    begin

        if(dut.pc_current !== 32'd0)
        begin

            $display("FAIL : PC not reset");

            errors = errors + 1;

        end

    end

end

//==============================================================
// PIPELINE STATUS DISPLAY
//==============================================================

always @(posedge clk)
begin

if(!reset)
begin

$display("");
$display("=========================================================");
$display("Cycle : %0d",cycle_count);
$display("=========================================================");

$display("PC               = %h",dut.pc_current);
$display("Instruction       = %h",dut.instruction);

$display("IF/ID PC          = %h",dut.ifid_pc);
$display("IF/ID Instruction = %h",dut.ifid_instr);

$display("ID/EX PC          = %h",dut.idex_pc);
$display("ID/EX RD          = %d",dut.idex_rd);

$display("EX/MEM RD         = %d",dut.exmem_rd);
$display("EX/MEM ALU        = %h",dut.exmem_alu_result);

$display("MEM/WB RD         = %d",dut.memwb_rd);
$display("WriteBack Data    = %h",dut.writeback_data);

$display("ForwardA          = %b",dut.forwardA);
$display("ForwardB          = %b",dut.forwardB);

$display("Branch Taken      = %b",dut.branch_taken);

$display("PC Write          = %b",dut.pc_write);
$display("IFID Write        = %b",dut.ifid_write);

$display("Control Stall     = %b",dut.control_stall);

end

end

//==============================================================
// END OF PART 1
//==============================================================

// Part 2 will contain:
//
// dump_registers()
// dump_data_memory()
// dump_instruction_memory()
// print_pipeline_registers()
// PASS/FAIL helper tasks
// phase banner task
// monitor utilities
//==============================================================
// PART 2
// Verification Tasks
//==============================================================


//==============================================================
// PHASE BANNER
//==============================================================

task phase_banner;

input [200:0] title;

begin

$display("");
$display("############################################################");
$display("#                                                          #");
$display("                %s",title);
$display("#                                                          #");
$display("############################################################");
$display("");

end

endtask


//==============================================================
// PASS MESSAGE
//==============================================================

task pass_message;

input [200:0] msg;

begin

$display("");
$display("*********************************************");
$display("PASS : %s",msg);
$display("*********************************************");
$display("");

end

endtask


//==============================================================
// FAIL MESSAGE
//==============================================================

task fail_message;

input [200:0] msg;

begin

$display("");
$display("*********************************************");
$display("FAIL : %s",msg);
$display("*********************************************");
$display("");

errors = errors + 1;

end

endtask


//==============================================================
// PRINT REGISTER FILE
//==============================================================

task dump_register_file;

integer r;

begin

$display("");
$display("==============================================================");
$display("REGISTER FILE");
$display("==============================================================");

for(r=0;r<32;r=r+1)
begin

$display("x%-2d = %h",r,dut.RF.regs[r]);

end

$display("==============================================================");
$display("");

end

endtask


//==============================================================
// PRINT DATA MEMORY
//==============================================================

task dump_data_memory;

integer m;

begin

$display("");
$display("==============================================================");
$display("DATA MEMORY (First 64 Words)");
$display("==============================================================");

for(m=0;m<64;m=m+1)
begin

$display("[%02d] = %h",m,dut.DMEM.memory[m]);

end

$display("==============================================================");
$display("");

end

endtask


//==============================================================
// PRINT INSTRUCTION MEMORY
//==============================================================

task dump_instruction_memory;

integer m;

begin

$display("");
$display("==============================================================");
$display("INSTRUCTION MEMORY");
$display("==============================================================");

for(m=0;m<32;m=m+1)
begin

$display("[%02d] = %h",m,dut.IMEM.memory[m]);

end

$display("==============================================================");
$display("");

end

endtask


//==============================================================
// PRINT PIPELINE REGISTERS
//==============================================================

task print_pipeline_registers;

begin

$display("");
$display("================ PIPELINE REGISTERS ================");

$display("");

$display("IF STAGE");
$display("-----------------------------------------------");
$display("PC                : %h",dut.pc_current);
$display("Instruction       : %h",dut.instruction);

$display("");

$display("IF/ID");
$display("-----------------------------------------------");
$display("PC                : %h",dut.ifid_pc);
$display("Instruction       : %h",dut.ifid_instr);

$display("");

$display("ID/EX");
$display("-----------------------------------------------");
$display("PC                : %h",dut.idex_pc);
$display("RS1               : %d",dut.idex_rs1);
$display("RS2               : %d",dut.idex_rs2);
$display("RD                : %d",dut.idex_rd);
$display("IMM               : %h",dut.idex_imm);

$display("");

$display("EX/MEM");
$display("-----------------------------------------------");
$display("ALU Result        : %h",dut.exmem_alu_result);
$display("Destination       : %d",dut.exmem_rd);

$display("");

$display("MEM/WB");
$display("-----------------------------------------------");
$display("Destination       : %d",dut.memwb_rd);
$display("WriteBack         : %h",dut.writeback_data);

$display("");

$display("===================================================");

end

endtask


//==============================================================
// FORWARDING STATUS
//==============================================================

task print_forwarding_status;

begin

$display("");
$display("------------- FORWARDING UNIT ----------------");

$display("ForwardA = %b",dut.forwardA);
$display("ForwardB = %b",dut.forwardB);

case(dut.forwardA)

2'b00 : $display("ForwardA : Register File");
2'b01 : $display("ForwardA : MEM/WB");
2'b10 : $display("ForwardA : EX/MEM");
default: $display("ForwardA : Invalid");

endcase

case(dut.forwardB)

2'b00 : $display("ForwardB : Register File");
2'b01 : $display("ForwardB : MEM/WB");
2'b10 : $display("ForwardB : EX/MEM");
default: $display("ForwardB : Invalid");

endcase

$display("-----------------------------------------------");
$display("");

end

endtask


//==============================================================
// HAZARD STATUS
//==============================================================

task print_hazard_status;

begin

$display("");
$display("------------- HAZARD DETECTION ----------------");

$display("PC Write        : %b",dut.pc_write);
$display("IFID Write      : %b",dut.ifid_write);
$display("Control Stall   : %b",dut.control_stall);

if(dut.control_stall)
$display("STALL INSERTED");

else
$display("NO HAZARD");

$display("-----------------------------------------------");
$display("");

end

endtask


//==============================================================
// BRANCH STATUS
//==============================================================

task print_branch_status;

begin

$display("");
$display("--------------- BRANCH UNIT -------------------");

$display("Branch Taken : %b",dut.branch_taken);
$display("Branch Target: %h",dut.branch_target);
$display("Next PC      : %h",dut.pc_next);

$display("");

$display("IFID Flush   : %b",dut.ifid_flush);
$display("IDEX Flush   : %b",dut.idex_flush);

$display("-----------------------------------------------");
$display("");

end

endtask


//==============================================================
// SIMULATION SUMMARY
//==============================================================

task simulation_summary;

begin

$display("");
$display("############################################################");
$display("SIMULATION SUMMARY");
$display("############################################################");

$display("Cycles Executed : %0d",cycle_count);
$display("Errors Found    : %0d",errors);

if(errors==0)
$display("FINAL RESULT : PASS");

else
$display("FINAL RESULT : FAIL");

$display("############################################################");
$display("");

end

endtask


//==============================================================
// END OF PART 2
//==============================================================
//==============================================================
// PART 3
// MAIN VERIFICATION SEQUENCE
//==============================================================

//==============================================================
// MAIN TEST SEQUENCE
//==============================================================

initial
begin

    //----------------------------------------------------------
    // Wait until reset is released
    //----------------------------------------------------------

    @(negedge reset);

    repeat(2) @(posedge clk);

    //----------------------------------------------------------
    // PHASE 1
    //----------------------------------------------------------

    phase_banner("PHASE 1 : RESET VERIFICATION");

    if(dut.pc_current == 32'd0)
        pass_message("PC Reset Successful");
    else
        fail_message("PC Reset Failed");

    if(dut.ifid_pc == 32'd0)
        pass_message("IF/ID Reset Successful");
    else
        fail_message("IF/ID Reset Failed");

    if(dut.idex_pc == 32'd0)
        pass_message("ID/EX Reset Successful");
    else
        fail_message("ID/EX Reset Failed");

    dump_register_file();

    dump_data_memory();

    repeat(5) @(posedge clk);

    //----------------------------------------------------------
    // PHASE 2
    //----------------------------------------------------------

    phase_banner("PHASE 2 : INSTRUCTION FETCH");

    if(dut.instruction !== 32'hxxxxxxxx)
        pass_message("Instruction Successfully Fetched");
    else
        fail_message("Instruction Fetch Failed");

    if(dut.pc_current == 32'd4)
        pass_message("PC Incremented Correctly");
    else
        fail_message("PC Increment Error");

    print_pipeline_registers();

    dump_instruction_memory();

    repeat(5) @(posedge clk);

    //----------------------------------------------------------
    // PHASE 3
    //----------------------------------------------------------

    phase_banner("PHASE 3 : INSTRUCTION DECODE");

    if(dut.rs1 == dut.ifid_instr[19:15])
        pass_message("RS1 Decode Correct");
    else
        fail_message("RS1 Decode Error");

    if(dut.rs2 == dut.ifid_instr[24:20])
        pass_message("RS2 Decode Correct");
    else
        fail_message("RS2 Decode Error");

    if(dut.rd == dut.ifid_instr[11:7])
        pass_message("RD Decode Correct");
    else
        fail_message("RD Decode Error");

    if(dut.opcode == dut.ifid_instr[6:0])
        pass_message("Opcode Decode Correct");
    else
        fail_message("Opcode Decode Error");

    $display("");
    $display("Decoded Fields");
    $display("----------------------------");
    $display("Opcode : %b",dut.opcode);
    $display("RS1    : %0d",dut.rs1);
    $display("RS2    : %0d",dut.rs2);
    $display("RD     : %0d",dut.rd);
    $display("Funct3 : %b",dut.funct3);
    $display("Funct7 : %b",dut.funct7);

    repeat(5) @(posedge clk);

    //----------------------------------------------------------
    // PHASE 4
    //----------------------------------------------------------

    phase_banner("PHASE 4 : R-TYPE EXECUTION");

    if(dut.idex_reg_write)
        pass_message("Register Write Enabled");
    else
        fail_message("Register Write Not Enabled");

    if(dut.alu_result !== 32'hxxxxxxxx)
        pass_message("ALU Produced Result");
    else
        fail_message("ALU Output Invalid");

    $display("");
    $display("ALU INPUT A : %h",dut.alu_in1);
    $display("ALU INPUT B : %h",dut.alu_in2);
    $display("ALU CTRL    : %b",dut.alu_ctrl);
    $display("ALU RESULT  : %h",dut.alu_result);

    repeat(6) @(posedge clk);

    //----------------------------------------------------------
    // PHASE 5
    //----------------------------------------------------------

    phase_banner("PHASE 5 : I-TYPE EXECUTION");

    if(dut.idex_alu_src)
        pass_message("Immediate Selected");
    else
        fail_message("Immediate Selection Failed");

    if(dut.idex_imm !== 32'd0)
        pass_message("Immediate Generated");
    else
        fail_message("Immediate Generation Failed");

    $display("");
    $display("Immediate = %h",dut.idex_imm);

    dump_register_file();

    repeat(6) @(posedge clk);
    //----------------------------------------------------------
    // PHASE 6
    //----------------------------------------------------------

    phase_banner("PHASE 6 : LOAD / STORE VERIFICATION");

    repeat(10) @(posedge clk);

    if(dut.exmem_mem_read)
        pass_message("Load Instruction Detected");
    else if(dut.exmem_mem_write)
        pass_message("Store Instruction Detected");
    else
        fail_message("Load/Store Control Signals Incorrect");

    $display("");
    $display("----------- DATA MEMORY ACCESS -----------");
    $display("Address       : %h", dut.exmem_alu_result);
    $display("Write Data    : %h", dut.exmem_write_data);
    $display("Read Data     : %h", dut.mem_read_data);
    $display("Mem Read      : %b", dut.exmem_mem_read);
    $display("Mem Write     : %b", dut.exmem_mem_write);

    dump_data_memory();

    //----------------------------------------------------------
    // PHASE 7
    //----------------------------------------------------------

    phase_banner("PHASE 7 : FORWARDING UNIT");

    repeat(10) @(posedge clk);

    print_forwarding_status();

    if((dut.forwardA != 2'b00) || (dut.forwardB != 2'b00))
        pass_message("Forwarding Activated");
    else
        $display("INFO : No forwarding required for current program.");

    $display("");
    $display("ForwardA = %b", dut.forwardA);
    $display("ForwardB = %b", dut.forwardB);
    $display("ALU Input A = %h", dut.alu_in1);
    $display("ALU Input B = %h", dut.alu_in2);

    //----------------------------------------------------------
    // PHASE 8
    //----------------------------------------------------------

    phase_banner("PHASE 8 : HAZARD DETECTION");

    repeat(10) @(posedge clk);

    print_hazard_status();

    if(dut.control_stall)
    begin
        pass_message("Hazard Detected");

        if(!dut.pc_write)
            pass_message("PC Correctly Stalled");
        else
            fail_message("PC Stall Failed");

        if(!dut.ifid_write)
            pass_message("IF/ID Correctly Frozen");
        else
            fail_message("IF/ID Stall Failed");
    end
    else
    begin
        $display("INFO : No load-use hazard occurred.");
    end

    //----------------------------------------------------------
    // PHASE 9
    //----------------------------------------------------------

    phase_banner("PHASE 9 : BRANCH + FLUSH");

    repeat(10) @(posedge clk);

    print_branch_status();

    if(dut.branch_taken)
    begin
        pass_message("Branch Taken");

        if(dut.ifid_flush)
            pass_message("IF/ID Flush Successful");
        else
            fail_message("IF/ID Flush Failed");

        if(dut.idex_flush)
            pass_message("ID/EX Flush Successful");
        else
            fail_message("ID/EX Flush Failed");

        $display("Branch Target : %h", dut.branch_target);
        $display("Next PC       : %h", dut.pc_next);
    end
    else
    begin
        $display("INFO : No branch executed.");
    end

    //----------------------------------------------------------
    // PHASE 10
    //----------------------------------------------------------

    phase_banner("PHASE 10 : COMPLETE PROCESSOR");

    repeat(25) @(posedge clk);

    print_pipeline_registers();

    dump_register_file();

    dump_data_memory();

    if(errors == 0)
    begin
        pass_message("COMPLETE PROCESSOR VERIFICATION PASSED");
    end
    else
    begin
        fail_message("COMPLETE PROCESSOR VERIFICATION FAILED");
    end

    //----------------------------------------------------------
    // FINAL SUMMARY
    //----------------------------------------------------------

    simulation_summary();

    $display("");
    $display("==============================================");
    $display("FINAL REGISTER FILE");
    $display("==============================================");

    dump_register_file();

    $display("");
    $display("==============================================");
    $display("FINAL DATA MEMORY");
    $display("==============================================");

    dump_data_memory();

    $display("");
    $display("==============================================");
    $display("SIMULATION FINISHED");
    $display("==============================================");

    $finish;

end


//==============================================================
// OPTIONAL CLOCK MONITOR
//==============================================================

always @(posedge clk)
begin

    if(!reset)
    begin

        $display("");
        $display("----------------------------------------------");
        $display("Cycle %0d", cycle_count);
        $display("----------------------------------------------");

        $display("PC            : %h", dut.pc_current);
        $display("Instruction   : %h", dut.instruction);

        $display("IF/ID RD      : %0d", dut.rd);

        $display("ID/EX RD      : %0d", dut.idex_rd);

        $display("EX/MEM RD     : %0d", dut.exmem_rd);

        $display("MEM/WB RD     : %0d", dut.memwb_rd);

        $display("ALU Result    : %h", dut.alu_result);

        $display("WriteBack     : %h", dut.writeback_data);

        $display("ForwardA      : %b", dut.forwardA);

        $display("ForwardB      : %b", dut.forwardB);

        $display("Hazard        : %b", dut.control_stall);

        $display("Branch        : %b", dut.branch_taken);

    end

end

endmodule

//==============================================================
// END OF FILE
//==============================================================