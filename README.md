# RISC-V-
A 32-bit RISC-V processor implemented in Verilog, featuring a five-stage pipeline, data forwarding, hazard detection, branch handling, and waveform-based verification using Icarus Verilog and GTKWave.

The project focuses on improving instruction throughput and reducing pipeline stalls through hazard management and forwarding techniques.

## Key Features

* **5-Stage Pipeline:** Implements Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write Back (WB).
* **Data Forwarding:** Implements forwarding paths from EX/MEM and MEM/WB pipeline stages to reduce unnecessary stalls caused by data dependencies.
* **Hazard Detection:** Detects load-use data hazards and introduces stalls when operands are not yet available.
* **Branch Handling:** Implements branch decision logic, target address calculation, and pipeline flushing to handle control hazards.
* **ALU Operations:** Supports arithmetic and logical operations, including ADD, SUB, AND, OR, XOR, shifts, and set-less-than operations, according to the implemented ALU control logic.
* **Load/Store Operations:** Supports memory access through load and store instructions.
* **Waveform-Based Verification:** Uses Verilog testbenches, VCD waveform dumps, and GTKWave to observe instruction flow and internal pipeline signals.

## Pipeline Architecture

The processor follows the conventional five-stage RISC-V pipeline.

| Stage | Name               | Function                                                                      |
| ----- | ------------------ | ----------------------------------------------------------------------------- |
| IF    | Instruction Fetch  | Fetches instructions using the program counter.                               |
| ID    | Instruction Decode | Decodes instructions, generates control signals, and reads source registers.  |
| EX    | Execute            | Performs ALU operations, evaluates branches, and calculates memory addresses. |
| MEM   | Memory Access      | Executes load and store operations.                                           |
| WB    | Write Back         | Writes computation results or loaded data into the register file.             |

Pipeline registers separate the stages:

* IF/ID
* ID/EX
* EX/MEM
* MEM/WB

These registers allow multiple instructions to be processed simultaneously.

## Pipeline Stall Reduction

One of the main objectives of this project is to reduce pipeline stalls caused by data dependencies.

The processor incorporates forwarding logic and hazard detection to minimize unnecessary pipeline interruptions.

### Techniques Used

**1. Data Forwarding**

Results from later pipeline stages can be forwarded directly to the execute stage when an instruction depends on a recently computed result. This reduces the need to wait for the result to be written back to the register file.

**2. Hazard Detection**

The hazard detection unit identifies load-use dependencies that cannot be resolved immediately through forwarding. When necessary, it stalls the program counter and IF/ID register and inserts a bubble into the pipeline.

**3. Branch Handling**

Branch decision logic determines whether a branch is taken. The processor updates the program counter and flushes affected pipeline instructions when required.

### Performance Improvement

**Achieved pipeline stall reduction: approximately 30%.**

This is the project's reported stall-reduction result. The percentage should be evaluated against a clearly defined baseline using the same instruction sequence and simulation conditions.

A reproducible measurement can be calculated as:

$$
\text{Stall Reduction (\%)} =
\frac{S_{\text{baseline}}-S_{\text{optimized}}}
{S_{\text{baseline}}}\times100
$$

Where:

* \(S_{\text{baseline}}\) = number of stall cycles before optimization.
* \(S_{\text{optimized}}\) = number of stall cycles after optimization.

The measured improvement depends on the instruction mix, dependency patterns, branch frequency, and test program.

## RTL Module Organization

The design is divided into individual Verilog modules for easier development, debugging, and verification.

| Module                    | Purpose                                            |
| ------------------------- | -------------------------------------------------- |
| `riscv_pipeline_cpu.v`    | Top-level processor integration                    |
| `pc.v`                    | Program counter                                    |
| `instruction_memory.v`    | Instruction storage and fetch                      |
| `ifid_reg.v`              | IF/ID pipeline register                            |
| `idex_reg.v`              | ID/EX pipeline register                            |
| `exmem_reg.v`             | EX/MEM pipeline register                           |
| `memwb_reg.v`             | MEM/WB pipeline register                           |
| `register_file.v`         | General-purpose register storage                   |
| `control_unit.v`          | Instruction decoding and control-signal generation |
| `imm_gen.v`               | Immediate-value generation                         |
| `alu.v`                   | Arithmetic and logical operations                  |
| `alu_control.v`           | ALU operation selection                            |
| `forwarding_unit.v`       | Forwarding control generation                      |
| `forward_mux.v`           | Operand selection for forwarded data               |
| `hazard_detection_unit.v` | Load-use hazard detection and stall control        |
| `branch_unit.v`           | Branch condition evaluation                        |
| `flush_unit.v`            | Pipeline flush control                             |
| `data_memory.v`           | Load/store data memory                             |

## Verification Strategy

The processor is verified by executing machine-code programs loaded into instruction memory.

Assembly programs are converted into hexadecimal machine-code files, which are loaded by the instruction memory for simulation.

### Verification Scenarios

* Reset and program-counter initialization
* Instruction fetch and sequential execution
* Instruction decoding and immediate generation
* R-type arithmetic and logical operations
* I-type immediate arithmetic
* Load and store operations
* Data forwarding between pipeline stages
* Load-use hazard detection and stall insertion
* Conditional branches and pipeline flushing
* Integrated execution of a program containing multiple instruction types

### Waveform Analysis

The testbench generates a Value Change Dump (VCD) file for inspection in GTKWave.

Important signals include:

* `pc_current`, `pc_next`
* `instruction`
* `ifid_instr`
* `idex_pc`
* `idex_rs1_data`, `idex_rs2_data`
* `alu_result`
* `forwardA`, `forwardB`
* `control_stall`
* `branch_taken`
* `ifid_flush`, `idex_flush`
* `exmem_alu_result`
* `mem_read_data`
* `writeback_data`
* `memwb_reg_write`

These signals help trace instructions through the pipeline and examine forwarding, stalls, branch handling, memory accesses, and register write-back.

## Tools and Technologies

* **Verilog HDL** — RTL design
* **Icarus Verilog** — RTL simulation
* **GTKWave** — Waveform analysis
* **Visual Studio Code** — Development environment
* **RISC-V Assembly** — Program development and instruction-level testing
* **RISC-V Assembler** — Conversion of assembly programs into machine code

## Running the Simulation

### 1. Compile the RTL and testbench

Open a terminal in the project directory and compile the source files.

Example:

```bash
iverilog -g2012 -o cpu_sim tb_riscv_pipeline_cpu.v riscv_pipeline_cpu.v pc.v instruction_memory.v ifid_reg.v idex_reg.v exmem_reg.v memwb_reg.v control_unit.v register_file.v imm_gen.v alu_control.v alu.v forwarding_unit.v forward_mux.v hazard_detection_unit.v branch_unit.v flush_unit.v data_memory.v
```

Adjust the testbench filename if yours differs.

### 2. Run the simulation

```bash
vvp cpu_sim
```

Ensure the instruction memory loads the intended `.mem` file and that any required output directories already exist.

### 3. Open the waveform

If the simulation generates `pipeline.vcd`, run:

```bash
gtkwave pipeline.vcd
```

Inspect the pipeline registers and control signals to follow instruction execution.

## Project Goals

* Design a modular 32-bit pipelined RISC-V processor.
* Understand instruction-level parallelism through pipeline execution.
* Reduce data-hazard penalties using forwarding.
* Handle load-use hazards using appropriate stall control.
* Manage control hazards through branch resolution and flushing.
* Verify processor behavior through assembly programs and waveform analysis.
* Evaluate pipeline performance using stall-cycle measurements.

## Future Improvements

* Expand the supported RISC-V instruction set.
* Improve branch handling and investigate earlier branch resolution.
* Add automated regression tests and stronger self-checking verification.
* Compare stall counts and CPI across multiple instruction workloads.
* Perform synthesis and timing analysis using tools such as Yosys and OpenSTA.
* Explore FPGA implementation or ASIC physical-design integration.

## Conclusion

This project demonstrates the design and verification of a five-stage pipelined RISC-V processor using Verilog. Forwarding, hazard detection, and branch handling provide practical experience with pipeline control and instruction dependencies.

The reported approximately 30% reduction in pipeline stalls highlights the potential benefits of targeted hazard-management techniques. Waveform-based verification provides visibility into internal processor behavior and supports debugging and performance analysis.
 
