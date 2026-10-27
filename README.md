# RISC-V Processor with Data Hazard Reduction

## Overview

Designed and implemented a RISC-V processor with an optimized datapath to reduce pipeline data hazards and improve execution efficiency. The design incorporates a forwarding unit to minimize unnecessary pipeline stalls and improve instruction throughput.

## Key Features

* **RISC-V Architecture:** Implemented a pipelined processor supporting instruction execution through multiple pipeline stages.
* **Forwarding Unit:** Implemented data forwarding paths to resolve RAW (Read After Write) data hazards by forwarding results directly between pipeline stages.
* **Data Hazard Reduction:** Achieved up to 50–60% reduction in data hazard-related stalls through forwarding and datapath optimization, based on project-specific evaluation.
* **Pipeline Optimization:** Improved instruction execution efficiency by reducing unnecessary stalls and maintaining pipeline flow.
* **RTL Design:** Developed the processor using Verilog HDL with modular datapath and control logic.

## Architecture

The processor uses a pipelined architecture with the following stages:

1. **IF – Instruction Fetch:** Fetches instructions from instruction memory.
2. **ID – Instruction Decode:** Decodes instructions and reads register operands.
3. **EX – Execute:** Performs arithmetic and logical operations.
4. **MEM – Memory Access:** Performs data memory operations.
5. **WB – Write Back:** Writes results back to the register file.

## Forwarding Unit

The forwarding unit detects dependencies between instructions in different pipeline stages and selects the appropriate forwarded operands.

* Detects RAW data dependencies.
* Forwards execution or memory-stage results to the execution stage.
* Reduces pipeline stalls caused by dependencies that can be resolved through forwarding.
* Improves instruction throughput by enabling dependent instructions to execute with fewer delays.

## Data Hazard Reduction

The processor incorporates forwarding logic to reduce stalls caused by data dependencies.

**Reported improvement:** Up to 50–60% reduction in data hazard-related stalls compared with the baseline implementation.

*Note: Retain this performance figure only if supported by simulation results or a documented comparison against the baseline processor.*

## Verification

The design can be verified using Verilog/SystemVerilog testbenches covering:

* Arithmetic and logical instructions.
* Instruction dependencies and RAW hazards.
* Forwarding conditions and operand selection.
* Load-use hazards and pipeline stalls.
* Register write-back and instruction execution.

## Tools and Technologies

* Verilog HDL
* RISC-V ISA
* RTL Design
* Pipelined Processor Architecture
* Forwarding and Hazard Detection
* Simulation and Functional Verification

## Author

Your Name
