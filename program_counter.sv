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
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module program_counter(
    input rst,              // RESET
    input clk,              // CLOCK
    input sel,              // SELECT
    input inc,              // INCRESE INSTRUCTION
    input ld,               // LOAD INSTRUCTION
    input [4:0] jmp,        // JUMP NUMBER
    output logic [4:0] out  // OUT_TMP_PC 
    );  
    reg [4:0] tmp_out = 0 ;
    
    //Load proggram counter
    always @(posedge clk or sel or rst ) begin
        if (rst) begin
            out<= 1'd0;
            tmp_out <= 1'd0;
        end
        else begin
            if (sel) begin
                out <= tmp_out;
            end
            else begin
                out <= out;
            end
        end
    end
    
    //Update proggram counter
     always @(posedge clk or posedge rst or posedge ld or posedge inc) begin
        if (rst) begin
            out<= 1'd0;
            tmp_out <= 1'd0;
        end
        else begin 
            if (ld) begin //JUMP CASE
                tmp_out <= jmp;
            end
            else if (inc) begin //NOMMAL CASE
                tmp_out <= tmp_out + 1;
            end
            else begin 
                tmp_out <= tmp_out;
            end
        end  
     end
endmodule




