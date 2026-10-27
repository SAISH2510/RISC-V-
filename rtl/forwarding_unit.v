module forwarding_unit(

    input [4:0] idex_rs1,
    input [4:0] idex_rs2,

    input [4:0] exmem_rd,
    input exmem_regwrite,

    input [4:0] memwb_rd,
    input memwb_regwrite,

    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);

always @(*)
begin

    forwardA = 2'b00;
    forwardB = 2'b00;

    // EX hazard

    if(exmem_regwrite &&
       (exmem_rd != 0) &&
       (exmem_rd == idex_rs1))
    begin
        forwardA = 2'b10;
    end

    if(exmem_regwrite &&
       (exmem_rd != 0) &&
       (exmem_rd == idex_rs2))
    begin
        forwardB = 2'b10;
    end

    // MEM hazard

    if(memwb_regwrite &&
       (memwb_rd != 0) &&
       !(exmem_regwrite &&
         (exmem_rd != 0) &&
         (exmem_rd == idex_rs1)) &&
       (memwb_rd == idex_rs1))
    begin
        forwardA = 2'b01;
    end

    if(memwb_regwrite &&
       (memwb_rd != 0) &&
       !(exmem_regwrite &&
         (exmem_rd != 0) &&
         (exmem_rd == idex_rs2)) &&
       (memwb_rd == idex_rs2))
    begin
        forwardB = 2'b01;
    end

end

endmodule