`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 06:20:08 PM
// Design Name: 
// Module Name: accumulator
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


`timescale 1ns / 100ps

module accumulator (
    input clk,            
    input rst,
    input ld_ac,
    input [7:0] data_in,
    output reg [7:0] data_out
);

always @(posedge clk) begin
    if (rst)
        data_out <= 8'b00000000;
    else if (ld_ac)
        data_out <= data_in;
end

endmodule
