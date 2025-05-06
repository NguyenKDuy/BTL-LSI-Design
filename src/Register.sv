`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2025 01:00:57 PM
// Design Name: 
// Module Name: Register
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


module Register(
    input  logic clk,          // Clock
    input  logic rst,          // Reset
    input  logic load,         // Signal Load dữ liệu ra output
    input  logic [7:0] data_in, // input 8-bit
    output logic [7:0] inB      // ouput 8-bit
);
    always @(posedge clk) begin
        if (rst) begin
            inB   <= 8'b0;  // Reset đầu ra về 0
        end 
        else begin      //truyền trực tiếp ko dùng buffer
            if (load)
                inB <= data_in;
        end  
 
    end

endmodule
