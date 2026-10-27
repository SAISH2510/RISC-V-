module instruction_memory(
    input [31:0] addr,
    output [31:0] instruction
);

reg [31:0] memory [0:255];

assign instruction = memory[addr[9:2]];

initial begin
    $readmemh("app.mem", memory);
end

endmodule