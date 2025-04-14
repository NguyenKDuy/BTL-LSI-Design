`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2025 11:31:30 PM
// Design Name: 
// Module Name: tb_risc8b
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


module tb_risc8b#(
        parameter DATA_WIDTH = 8,                  // Độ rộng dữ liệu
        parameter ADDR_WIDTH = 5                  // Độ rộng địa chỉ (cho 2^5 = 32 ô)
)(

    );
    logic clk;
    logic rst;
    logic [ADDR_WIDTH-1:0] pc_counter;
    logic [DATA_WIDTH-1:0] alu_out;
    logic halt;

    risc_8b dut (clk, rst, pc_counter, alu_out, halt);
    
    initial begin
        clk = 0;
        rst = 1;
        #35;
        rst = 0;
        $readmemb("wmem.bin", dut.Memory.mem);
    end
    always #10 clk = ~clk;
    
    
endmodule
