module riscv_pipeline_cpu(
    input clk,
    input reset
);

//IF wires
wire [31:0] pc_current;
wire [31:0] pc_next;
wire [31:0] instruction;

wire pc_write;

//PC
pc PC(
    .clk(clk),
    .reset(reset),
    .pc_write(pc_write),
    .next_pc(pc_next),
    .pc_out(pc_current)
);

//Instruction memory

instruction_memory IMEM(
    .addr(pc_current),
    .instruction(instruction)
);

//PC+4

wire [31:0] pc_plus4;

assign pc_plus4 = pc_current + 32'd4;

//IF/ID pipeline register

wire [31:0] ifid_pc;
wire [31:0] ifid_instr;

wire ifid_write;
wire ifid_flush;

ifid_reg IFID(
    .clk(clk),
    .reset(reset),

    .write_enable(ifid_write),
    .flush(ifid_flush),

    .pc_in(pc_current),
    .instr_in(instruction),

    .pc_out(ifid_pc),
    .instr_out(ifid_instr)
);

//Instruction fields

wire [6:0] opcode;
wire [4:0] rd;
wire [2:0] funct3;
wire [4:0] rs1;
wire [4:0] rs2;
wire [6:0] funct7;

assign opcode = ifid_instr[6:0];
assign rd     = ifid_instr[11:7];
assign funct3 = ifid_instr[14:12];
assign rs1    = ifid_instr[19:15];
assign rs2    = ifid_instr[24:20];
assign funct7 = ifid_instr[31:25];

//control unit
wire reg_write;
wire mem_read;
wire mem_write;
wire mem_to_reg;
wire alu_src;
wire branch;
wire jump;

wire [1:0] alu_op;

control_unit CU(
    .opcode(opcode),

    .reg_write(reg_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),

    .alu_src(alu_src),

    .branch(branch),
    .jump(jump),

    .alu_op(alu_op)
);
// register file
wire [31:0] rs1_data;
wire [31:0] rs2_data;

register_file RF(

    .clk(clk),

    .reg_write(memwb_reg_write),

    .rs1(rs1),
    .rs2(rs2),

    .rd(memwb_rd),

    .write_data(writeback_data),

    .read_data1(rs1_data),
    .read_data2(rs2_data)
);
//immediate generator
wire [31:0] immediate;

imm_gen IMMGEN(
    .instruction(ifid_instr),
    .imm_out(immediate)
);
//hazard detection unit
wire control_stall;

hazard_detection_unit HDU(

    .idex_memread(idex_mem_read),
    .idex_rd(idex_rd),

    .ifid_rs1(rs1),
    .ifid_rs2(rs2),

    .pc_write(pc_write),
    .ifid_write(ifid_write),

    .control_stall(control_stall)
);
//ID/EX output wires
// ID/EX Outputs

wire idex_reg_write;
wire idex_mem_read;
wire idex_mem_write;
wire idex_mem_to_reg;
wire idex_alu_src;
wire idex_branch;

wire [1:0] idex_alu_op;

wire [31:0] idex_pc;
wire [31:0] idex_rs1_data;
wire [31:0] idex_rs2_data;
wire [31:0] idex_imm;

wire [4:0] idex_rs1;
wire [4:0] idex_rs2;
wire [4:0] idex_rd;

wire [2:0] idex_funct3;
wire [6:0] idex_funct7;
//ID/EX reg instantiation

wire stall_reg_write;
wire stall_mem_read;
wire stall_mem_write;
wire stall_mem_to_reg;
wire stall_alu_src;
wire stall_branch;

wire [1:0] stall_alu_op;

assign stall_reg_write = control_stall ? 1'b0 : reg_write;
assign stall_mem_read  = control_stall ? 1'b0 : mem_read;
assign stall_mem_write = control_stall ? 1'b0 : mem_write;
assign stall_mem_to_reg= control_stall ? 1'b0 : mem_to_reg;
assign stall_alu_src   = control_stall ? 1'b0 : alu_src;
assign stall_branch    = control_stall ? 1'b0 : branch;
assign stall_alu_op    = control_stall ? 2'b00 : alu_op;

idex_reg IDEX(

    .clk(clk),
    .reset(reset),
    .flush(idex_flush | control_stall),

    .reg_write_in(stall_reg_write),
    .mem_read_in(stall_mem_read),
    .mem_write_in(stall_mem_write),
    .mem_to_reg_in(stall_mem_to_reg),
    .alu_src_in(stall_alu_src),
    .branch_in(stall_branch),
    .alu_op_in(stall_alu_op),

    .pc_in(ifid_pc),
    .rs1_data_in(rs1_data),
    .rs2_data_in(rs2_data),
    .imm_in(immediate),

    .rs1_in(rs1),
    .rs2_in(rs2),
    .rd_in(rd),

    .funct3_in(funct3),
    .funct7_in(funct7),

    .reg_write_out(idex_reg_write),
    .mem_read_out(idex_mem_read),
    .mem_write_out(idex_mem_write),
    .mem_to_reg_out(idex_mem_to_reg),
    .alu_src_out(idex_alu_src),
    .branch_out(idex_branch),

    .alu_op_out(idex_alu_op),

    .pc_out(idex_pc),
    .rs1_data_out(idex_rs1_data),
    .rs2_data_out(idex_rs2_data),
    .imm_out(idex_imm),

    .rs1_out(idex_rs1),
    .rs2_out(idex_rs2),
    .rd_out(idex_rd),

    .funct3_out(idex_funct3),
    .funct7_out(idex_funct7)
);
//alu control
wire [3:0] alu_ctrl;

alu_control ALUCTRL(

    .alu_op(idex_alu_op),

    .funct3(idex_funct3),
    .funct7(idex_funct7),

    .alu_ctrl(alu_ctrl)
);
//forwarding unit
wire [1:0] forwardA;
wire [1:0] forwardB;
forwarding_unit FU(

    .idex_rs1(idex_rs1),
    .idex_rs2(idex_rs2),

    .exmem_rd(exmem_rd),
    .exmem_regwrite(exmem_reg_write),

    .memwb_rd(memwb_rd),
    .memwb_regwrite(memwb_reg_write),

    .forwardA(forwardA),
    .forwardB(forwardB)
);
//forwarding muxes
wire [31:0] alu_in1;
wire [31:0] alu_in2_pre;
forward_mux FMUX_A(

    .reg_data(idex_rs1_data),
    .exmem_data(exmem_alu_result),
    .memwb_data(writeback_data),

    .forward_sel(forwardA),

    .out(alu_in1)
);
forward_mux FMUX_B(

    .reg_data(idex_rs2_data),
    .exmem_data(exmem_alu_result),
    .memwb_data(writeback_data),

    .forward_sel(forwardB),

    .out(alu_in2_pre)
);
 //alu source mux
wire [31:0] alu_in2;

assign alu_in2 =
        (idex_alu_src)
        ? idex_imm
        : alu_in2_pre;
//alu
wire [31:0] alu_result;
wire zero;
alu ALU(

    .a(alu_in1),
    .b(alu_in2),

    .alu_control(alu_ctrl),

    .result(alu_result),
    .zero(zero)
);

//branch unit
wire branch_taken;
branch_unit BRANCH(

    .rs1_data(alu_in1),
    .rs2_data(alu_in2_pre),

    .funct3(idex_funct3),

    .branch_taken(branch_taken)
);
//branch adress
wire [31:0] branch_target;

assign branch_target =
       idex_pc + idex_imm;
//flush unit
wire idex_flush;
flush_unit FLUSH(

    .branch_taken(branch_taken),

    .ifid_flush(ifid_flush),
    .idex_flush(idex_flush)
);
//Next pc logic
assign pc_next =
       (idex_branch && branch_taken)
       ? branch_target
       : pc_plus4;


//.............................

// EX/MEM wires

wire exmem_reg_write;
wire exmem_mem_read;
wire exmem_mem_write;
wire exmem_mem_to_reg;

wire exmem_branch_taken;

wire [31:0] exmem_alu_result;
wire [31:0] exmem_write_data;

wire [4:0] exmem_rd;

//Instantiate EX/MEM register:

exmem_reg EXMEM(

    .clk(clk),
    .reset(reset),

    .reg_write_in(idex_reg_write),
    .mem_read_in(idex_mem_read),
    .mem_write_in(idex_mem_write),
    .mem_to_reg_in(idex_mem_to_reg),

    .branch_taken_in(branch_taken),

    .alu_result_in(alu_result),
    .write_data_in(alu_in2_pre),

    .rd_in(idex_rd),

    .reg_write_out(exmem_reg_write),
    .mem_read_out(exmem_mem_read),
    .mem_write_out(exmem_mem_write),
    .mem_to_reg_out(exmem_mem_to_reg),

    .branch_taken_out(exmem_branch_taken),

    .alu_result_out(exmem_alu_result),
    .write_data_out(exmem_write_data),

    .rd_out(exmem_rd)

);
// data memory
wire [31:0] mem_read_data;

data_memory DMEM(

    .clk(clk),

    .mem_read(exmem_mem_read),
    .mem_write(exmem_mem_write),

    .addr(exmem_alu_result),

    .write_data(exmem_write_data),

    .read_data(mem_read_data)

);
//MEM/WB Wires
wire memwb_reg_write;
wire memwb_mem_to_reg;

wire [31:0] memwb_mem_data;
wire [31:0] memwb_alu_result;

wire [4:0] memwb_rd;
//MEM/WB Register
memwb_reg MEMWB(

    .clk(clk),
    .reset(reset),

    .reg_write_in(exmem_reg_write),
    .mem_to_reg_in(exmem_mem_to_reg),

    .mem_data_in(mem_read_data),
    .alu_result_in(exmem_alu_result),

    .rd_in(exmem_rd),

    .reg_write_out(memwb_reg_write),
    .mem_to_reg_out(memwb_mem_to_reg),

    .mem_data_out(memwb_mem_data),
    .alu_result_out(memwb_alu_result),

    .rd_out(memwb_rd)

);
//Writeback MUX
wire [31:0] writeback_data;

assign writeback_data =
       (memwb_mem_to_reg)
       ? memwb_mem_data
       : memwb_alu_result;



endmodule