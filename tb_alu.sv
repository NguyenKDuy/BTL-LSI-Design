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
              $display("\n--- TEST FLOAT 8-BIT ADDITION (1|3|4 FORMAT) ---");
        // test1: 16.0 + 14.0 = 30.0
        inA = 8'b01110000;
        inB = 8'b01101100;
        opcode = 3'b010; #10;

        // test2: 6.0 + 1.5 = 7.5
        inA = 8'b01011000;
        inB = 8'b00111000;
        opcode = 3'b010; #10;

        // test3: 16.0 + 16.0
        inA = 8'b01110000;
        inB = 8'b01110000;
        opcode = 3'b010; #10;

        // Test4: -6.0 + -2.0 = -8.0
        inA = 8'b11011000;
        inB = 8'b11000000;
        opcode = 3'b010; #10;

        // Test5: 6.0 + (-2.0) = 4.0
        inA = 8'b01011000;
        inB = 8'b11000000;
        opcode = 3'b010; #10;

        // Test6: -2.0 + 2.0 = 0.0
        inA = 8'b11000000;
        inB = 8'b01000000;
        opcode = 3'b010; #10;

        // Test7: -2.75 + 1.25
        inA = 8'b11000110;
        inB = 8'b00110100;
        opcode = 3'b010; #10;
        
        // Test8: -1.25 + (-1.75)
        inA = 8'b10110100;
        inB = 8'b10111100;
        opcode = 3'b010; #10;
        
        // Test9: 16.0 + 15.0 = 31.0
        inA = 8'b01110000;
        inB = 8'b01101110;
        opcode = 3'b010; #10;

        // Test10: -31.0 + 0.125 ≈ -30.875 (Exp_diff = 7, lose bits => wrong
        inA = 8'b11111111;
        inB = 8'b00000000;
        opcode = 3'b010; #10;

        // Test11: -0.125 + -31.0 ≈ -31.125
        inA = 8'b10000000;
        inB = 8'b11111111;
        opcode = 3'b010; #10;
        $finish;
    end
    
    //Debug
    initial begin
        $monitor("Time=%0t | inA=%b | inB=%b | Opcode=%b | Result=%b | Zero_Flag=%b",
                 $time, inA, inB, opcode, res, is_zero);
    end
endmodule

