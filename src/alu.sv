`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 05:56:10 PM
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu(
    input [2:0] opcode,
    input [7:0] inA,
    input [7:0] inB,
    output reg [7:0] res,
    output reg is_zero
);

always @(*) begin
    case(opcode)
        3'b000: res = inA; //HLT
        3'b001: res = inA; //SKZ
        3'b010: res = inA + inB; //ADD 
        3'b011: res = inA & inB; //AND
        3'b100: res = inA ^ inB; //XOR
        3'b101: res = inA; //LDA        - changed
        3'b110: res = inA; //STO
        3'b111: res = inA; //JMP
        
        default: res = 8'b00000000;
    endcase
    is_zero = (inA == 8'b00000000) ? 1 : 0;
end

endmodule
