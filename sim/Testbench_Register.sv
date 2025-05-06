`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2025 01:23:45 PM
// Design Name: 
// Module Name: Testbench_Register
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


module tb_Register;
    logic clk, rst, load;
    logic [7:0] data_in;
    logic [7:0] data_out;

    // Kết nối module với testbench
    Register UUT (
        .clk(clk),
        .rst(rst),
        .load(load),
        .data_in(data_in),
        .inA(data_out)
    );

    // Tạo xung clock
    always #10 clk = ~clk; // Chu kỳ clock 20ns

    initial begin
        clk = 0;
        rst = 1;
        load = 0; 
        data_in = 8'b00000000;
        
        #10 rst = 0;  // Thả reset

        // Ghi dữ liệu vào thanh ghi khi load = 0
        #20 data_in = 8'b10101010; load = 1; 
        #40 load = 0; 
        #20 data_in = 8'b11001100; load = 0;    

        // Load dữ liệu từ thanh ghi ra output
        #20 load = 1;
        
        #20 load =0;
        
        // Test giữ giá trị đầu ra khi load = 1
        #20 load = 1;
        
        #20 load = 0; data_in = 8'b11110000;

        // Load dữ liệu mới ra output
        #20 load = 1;

        // Reset lại thanh ghi
        #20 rst = 1;
        #20 rst = 0; load = 0;
        #20 load = 1;
        
        #20 load = 0;
        
        #40 data_in = 8'b11111111; load = 1; 

        #20 rst = 1;
        #20 rst = 0;
        
        #40 $finish;
    end
endmodule

