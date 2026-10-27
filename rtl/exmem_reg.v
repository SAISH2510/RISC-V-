module exmem_reg(

    input clk,
    input reset,

    input reg_write_in,
    input mem_read_in,
    input mem_write_in,
    input mem_to_reg_in,

    input branch_taken_in,

    input [31:0] alu_result_in,
    input [31:0] write_data_in,

    input [4:0] rd_in,

    output reg reg_write_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg mem_to_reg_out,

    output reg branch_taken_out,

    output reg [31:0] alu_result_out,
    output reg [31:0] write_data_out,

    output reg [4:0] rd_out
);

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin

        reg_write_out    <= 0;
        mem_read_out     <= 0;
        mem_write_out    <= 0;
        mem_to_reg_out   <= 0;

        branch_taken_out <= 0;

        alu_result_out   <= 0;
        write_data_out   <= 0;

        rd_out           <= 0;

    end

    else
    begin

        reg_write_out    <= reg_write_in;
        mem_read_out     <= mem_read_in;
        mem_write_out    <= mem_write_in;
        mem_to_reg_out   <= mem_to_reg_in;

        branch_taken_out <= branch_taken_in;

        alu_result_out   <= alu_result_in;
        write_data_out   <= write_data_in;

        rd_out           <= rd_in;

    end

end

endmodule