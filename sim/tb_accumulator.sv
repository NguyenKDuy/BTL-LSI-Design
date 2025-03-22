`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 06:21:06 PM
// Design Name: 
// Module Name: tb_accumulator
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

module tb_accumulator;
    reg clk, rst, ld_ac;
    reg [7:0] data_in;
    wire [7:0] data_out;

    accumulator accu_sim (
        .clk(clk),
        .rst(rst),
        .ld_ac(ld_ac),
        .data_in(data_in),
        .data_out(data_out)
    );

    // clock 10ns
    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; ld_ac = 0; data_in = 8'b00000000;
        #10 rst = 0;

        // Test 1: load new value to Accumulator
        data_in = 8'b00001111; ld_ac = 1;
        #10 ld_ac = 0;

        // Test 2: load new value to Accumulator
        data_in = 8'b10101010; ld_ac = 1;
        #10 ld_ac = 0;

        // Test 3: check if load = 0
        #10;

        // Test 4: Reset Accumulator = 0
        rst = 1;
        #10 rst = 0;

        // Test 5: Load new value
        data_in = 8'b11110000; ld_ac = 1;
        #10 ld_ac = 0;

        #20 $finish;
    end

    initial begin
        $monitor("Time=%0t | ld_ac=%b | rst=%b | data_in=%b | data_out=%b",
                 $time, ld_ac, rst, data_in, data_out);
    end
endmodule
