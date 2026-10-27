module forward_mux(

    input [31:0] reg_data,
    input [31:0] exmem_data,
    input [31:0] memwb_data,

    input [1:0] forward_sel,

    output reg [31:0] out
);

always @(*)
begin

    case(forward_sel)

        2'b00:
            out = reg_data;

        2'b01:
            out = memwb_data;

        2'b10:
            out = exmem_data;

        default:
            out = reg_data;

    endcase

end

endmodule