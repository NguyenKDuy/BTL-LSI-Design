`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Bach Nguyen Duy
// 
// Create Date: 03/12/2025 10:15:39 AM
// Design Name: 
// Module Name: proggram_counter
// Project Name: Design simple RISC CPU
// Target Devices: 
// Tool Versions: Vivado 2024.2
// Description: 
// 
// Dependencies: 
// 
// Revision: 0.02 - Synchronous CLOCK
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module program_counter

(
    input rst,              // RESET
    input clk,              // CLOCK
    input sel,              // SELECT
    input inc,              // INCRESE INSTRUCTION
    input ld,               // LOAD INSTRUCTION
    input [4:0] jmp,        // JUMP NUMBER
    output logic [4:0] out = 'd0  // OUT_TMP_PC 
    );  
    reg [4:0] tmp_out = 'd0 ;
    
    //Load proggram counter
    always @(posedge clk) begin
        if (rst) begin
            out<= 1'd0;
            tmp_out <= 1'd0;
        end
        else begin
            //Update output
            if (sel) begin
                out <= tmp_out;
            end
            //Update jump variable to tmp output
            if (ld) begin
                tmp_out <= jmp;
            end
            else begin
                // increase tmp output 
                if (inc) begin;
                    tmp_out <= tmp_out + 1;
                end
            end
        end
    end          

endmodule




