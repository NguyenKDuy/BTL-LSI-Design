`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2025 05:22:48 PM
// Design Name: 
// Module Name: tb_alu_accumulator
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



module tb_alu_accumulator;
    reg clk, rst, ld_ac;
    reg [2:0] opcode;
    reg [7:0] inA, inB;
    wire [7:0] alu_result, acc_out;
    wire is_zero;
    
    alu alu_inst (
        .opcode(opcode),
        .inA(inA),
        .inB(inB),
        .res(alu_result),
        .is_zero(is_zero)
    );
    
    accumulator acc_inst (
        .clk(clk),
        .rst(rst),
        .ld_ac(ld_ac),
        .data_in(alu_result),
        .data_out(acc_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Reset
        rst = 1; ld_ac = 0; inA = 0; inB = 0; opcode = 3'b000;
        #10 rst = 0;

        // Test 0:
        inA = 8'b00000000;
        inB = 8'b00101010;
        opcode = 3'b101;   // LDA
        #10 ld_ac = 1;
        #10 ld_ac = 0;

        // Test 1: ADD
        inA = acc_out;
        inB = 8'b00011001; // 25
        opcode = 3'b010;   // ADD
        #10 ld_ac = 1;
        #10 ld_ac = 0;

        // Test 2: AND
        inA = acc_out;
        inB = 8'b00001111; // 15
        opcode = 3'b011; // AND
        #10 ld_ac = 1;
        #10 ld_ac = 0;

        // Test 3: XOR
        inA = acc_out;
        inB = 8'b00000111; // 7
        opcode = 3'b100; // XOR
        #10 ld_ac = 1;
        #10 ld_ac = 0;

        // Test 4: Reset
        rst = 1;
        #10 rst = 0;

        $finish;
    end

    
    initial begin
        $monitor("Time=%0t | rst=%b | ld_ac=%b | inA=%b (%0d) | inB=%b (%0d) | Opcode=%b | ALU_Out=%b (%0d) | Accumulator=%b (%0d) | Zero_Flag=%b",
                 $time, rst, ld_ac, inA, inA, inB, inB, opcode, alu_result, alu_result, acc_out, acc_out, is_zero);
    end
endmodule
