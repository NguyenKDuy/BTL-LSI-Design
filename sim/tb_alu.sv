`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 06:00:27 PM
// Design Name: 
// Module Name: tb_alu
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



`timescale 1ns / 1ps

module tb_alu;
    reg [7:0] inA, inB;
    reg [2:0] opcode;
    wire [7:0] res;
    wire is_zero;
    
    // Gọi ALU
    alu alu_sim (
        .opcode(opcode),
        .inA(inA),
        .inB(inB),
        .res(res),
        .is_zero(is_zero)
    );

    initial begin
        // inA = -18, inB = 25**
        $display("\n--- TESTING BASIC OPERATIONS ---");
        #5;  
        inA = 8'b11101110; inB = 8'b00011001; opcode = 3'b000; #10;  // HLT
        inA = 8'b11101110; inB = 8'b00011001; opcode = 3'b001; #10;  // SKZ
        inA = 8'b00000000; inB = 8'b00011001; opcode = 3'b001; #10;  // SKZ (is_zero = 1)
        inA = 8'b11101110; inB = 8'b00011001; opcode = 3'b011; #10;  // AND
        inA = 8'b11101110; inB = 8'b00011001; opcode = 3'b100; #10;  // XOR
        inA = 8'b11101110; inB = 8'b00011001; opcode = 3'b101; #10;  // LDA
        inA = 8'b11101110; inB = 8'b00011001; opcode = 3'b110; #10;  // STO
        inA = 8'b11101110; inB = 8'b00011001; opcode = 3'b111; #10;  // JMP

        //ADD
        $display("\n--- TESTING ADD, AND, XOR OPERATIONS WITH OVERFLOW CASES ---");

        // 2 negative numbers not overflow (-50 + -30)
        inA = 8'b11001110;  // -50
        inB = 8'b11100010;  // -30
        
        opcode = 3'b010; #10;  // ADD

        // *2 negative numbers overflow (-100 + -60)
        inA = 8'b10011100;  // -100
        inB = 8'b11000100;  // -60
        
        opcode = 3'b010; #10;  // ADD

        // 2 positive numbers not overflow (30 + 40)
        inA = 8'b00011110;  // 30
        inB = 8'b00101000;  // 40
        
        opcode = 3'b010; #10;  // ADD

        // 2 positive numbers overflow (100 + 50)
        inA = 8'b01100100;  // 100
        inB = 8'b00110010;  // 50
        
        opcode = 3'b010; #10;  // ADD

        // 1 negative and 1 positive number not overflow (-30 + 20)
        inA = 8'b11100010;  // -30
        inB = 8'b00010100;  // 20
        
        opcode = 3'b010; #10;  // ADD

        // 1 negative and 1 positive number overflow (-100 + 120)**
        inA = 8'b10011100;  // -100
        inB = 8'b01111000;  // 120
        
        opcode = 3'b010; #10;  // ADD

        $finish;
    end
    
    //Debug
    initial begin
        $monitor("Time=%0t | inA=%b (%0d) | inB=%b (%0d) | Opcode=%b | Result=%b (%0d) | Zero_Flag=%b",
                $time, inA, $signed(inA), inB, $signed(inB), opcode, res, $signed(res), is_zero);
    end
endmodule

