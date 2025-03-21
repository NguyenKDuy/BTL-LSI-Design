`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 03:01:15 PM
// Design Name: 
// Module Name: Memory
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


module memory_5x8 #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 5,
    parameter MEM_DEPTH  = (1 << ADDR_WIDTH)
)(
    input                       clk,
    input                       rst,
    input                       sel,
    input                       rd,
    input                       wr,
    input                       ld_ir,
    input                       data_e,
    input      [ADDR_WIDTH-1:0] address,
    inout      [DATA_WIDTH-1:0] data_out     // Bidirectional port
);

    reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];
    reg [DATA_WIDTH-1:0] read_data_reg;
    reg [DATA_WIDTH-1:0] data_in;

    // Cổng ra 3 trạng thái
    assign data = (rd && sel && data_e) ? read_data_reg : {DATA_WIDTH{1'bz}};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            read_data_reg <= {DATA_WIDTH{1'b0}};
        end else if (sel) begin
            if (wr && !rd && data_e) begin
                data_in <= data_out;
                mem[address] <= data_in;
            end else if (rd && !wr && data_e) begin
                read_data_reg <= mem[address];
            end
        end
    end
endmodule
