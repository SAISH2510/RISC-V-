module alu_control(

    input [1:0] alu_op,

    input [2:0] funct3,
    input [6:0] funct7,

    output reg [3:0] alu_ctrl
);

always @(*)
begin

    case(alu_op)

        // Load/Store
        2'b00:
        begin
            alu_ctrl = 4'b0000;
        end

        // Branch
        2'b01:
        begin
            alu_ctrl = 4'b0001;
        end

        // R-Type
        2'b10:
        begin

            case({funct7,funct3})

                {7'b0000000,3'b000}:
                    alu_ctrl = 4'b0000;

                {7'b0100000,3'b000}:
                    alu_ctrl = 4'b0001;

                {7'b0000000,3'b111}:
                    alu_ctrl = 4'b0010;

                {7'b0000000,3'b110}:
                    alu_ctrl = 4'b0011;

                {7'b0000000,3'b100}:
                    alu_ctrl = 4'b0100;

                {7'b0000000,3'b001}:
                    alu_ctrl = 4'b0101;

                {7'b0000000,3'b101}:
                    alu_ctrl = 4'b0110;

                {7'b0000000,3'b010}:
                    alu_ctrl = 4'b0111;

                default:
                    alu_ctrl = 4'b0000;

            endcase

        end

        // I-Type
        2'b11:
        begin

            case(funct3)

                3'b000:
                    alu_ctrl = 4'b0000;

                3'b111:
                    alu_ctrl = 4'b0010;

                3'b110:
                    alu_ctrl = 4'b0011;

                3'b100:
                    alu_ctrl = 4'b0100;

                3'b001:
                    alu_ctrl = 4'b0101;

                3'b101:
                    alu_ctrl = 4'b0110;

                3'b010:
                    alu_ctrl = 4'b0111;

                default:
                    alu_ctrl = 4'b0000;

            endcase

        end

        default:
            alu_ctrl = 4'b0000;

    endcase

end

endmodule