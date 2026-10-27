module hazard_detection_unit(

    input idex_memread,

    input [4:0] idex_rd,

    input [4:0] ifid_rs1,
    input [4:0] ifid_rs2,

    output reg pc_write,
    output reg ifid_write,

    output reg control_stall
);

always @(*)
begin

    if(idex_memread &&
       ((idex_rd == ifid_rs1) ||
        (idex_rd == ifid_rs2)))
    begin

        pc_write     = 0;
        ifid_write   = 0;
        control_stall= 1;

    end

    else
    begin

        pc_write     = 1;
        ifid_write   = 1;
        control_stall= 0;

    end

end

endmodule