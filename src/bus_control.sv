`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2025 10:37:38 AM
// Design Name: 
// Module Name: bus_control
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


module bus_control #(
    parameter DATA_WIDTH = 8,                 
    parameter ADDR_WIDTH = 5                 
)(
        
        input ctrl_signal,
        input [DATA_WIDTH-1:0] data_tx,
        output [DATA_WIDTH-1:0] data_rx,
        inout [DATA_WIDTH-1:0] bidr
);
        assign data_rx = bidr;
        assign bidr = ctrl_signal ? data_tx : 'hz;
endmodule
