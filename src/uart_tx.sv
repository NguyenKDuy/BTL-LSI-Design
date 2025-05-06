`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2025 10:34:03 AM
// Design Name: 
// Module Name: uart_tx
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


module uart_tx #( parameter
        CLK_HZ = 12_000_000,
        BAUD = 9600,
        bit [15:0] BAUD_DIVISOR = CLK_HZ / BAUD
)(
        input clk,
        input nrst,
        //input tx_do_sample,
        
        input [7:0] tx_data,
        input tx_start,                 // write strobe
        output logic tx_busy = 1'b0,
        output logic txd = 1'b1
);

        logic [9:0] tx_shifter = '0;
        logic [15:0] tx_sample_cntr = '0;
        always_ff @ (posedge clk) begin
                if( (~nrst) || (tx_sample_cntr[15:0] == '0) ) begin
                        tx_sample_cntr[15:0] <= (BAUD_DIVISOR-1'b1);
                end else begin
                        tx_sample_cntr[15:0] <= tx_sample_cntr[15:0] - 1'b1;
                end
        end
        
        logic tx_do_sample;
        assign tx_do_sample = (tx_sample_cntr[15:0] == 'd0);
        
        
        always_ff @ (posedge clk) begin
                if( ~nrst ) begin
                        tx_busy <= 1'b0;
                        tx_shifter[9:0] <= '0;
                        txd <= 1'b1;
                end else begin
                if( ~tx_busy ) begin
        // asynchronous data load and 'busy' set
                        if( tx_start ) begin
                        tx_shifter[9:0] <= { 1'b1,tx_data[7:0],1'b0 };
                        tx_busy <= 1'b1;
                        end
                        end else begin
                                if( tx_do_sample ) begin    // next bit
                                // txd MUST change only on tx_do_sample although data may be loaded earlier
                                        { tx_shifter[9:0],txd } <= { tx_shifter[9:0],txd } >> 1;
                                        // early asynchronous 'busy' reset
                                        if( ~|tx_shifter[9:1] ) begin
                                        // txd still holds data, but shifter is ready to get new info
                                        tx_busy <= 1'b0;
                                        end
                                end // tx_do_sample
        
                        end // ~tx_busy
                end // ~nrst
        end

endmodule