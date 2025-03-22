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


module memory #(
    parameter DATA_WIDTH = 8,                  // Độ rộng dữ liệu
    parameter ADDR_WIDTH = 5,                  // Độ rộng địa chỉ (cho 2^5 = 32 ô)
    parameter MEM_DEPTH  = (1 << ADDR_WIDTH)    // Số lượng ô bộ nhớ (32)
)(
    input                        clk,         // Clock
    input                        rst,         // Reset (đồng bộ)
    input                        sel,         // Tín hiệu chọn bộ nhớ
    input                        rd,          // 1 = cho phép đọc
    input                        wr,          // 1 = cho phép ghi
    input                        ld_ir,       // 1 = cho phép nạp vào IR (bidr)
    input                       data_e,     
    input       [ADDR_WIDTH-1:0] address,     // Địa chỉ
    inout  [DATA_WIDTH-1:0] bidr     // Dữ liệu đầu ra (có thể là lệnh hoặc dữ liệu)
);      

    logic [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];
     logic [DATA_WIDTH-1:0] data_tx;
     logic [DATA_WIDTH-1:0] data_rx;
     logic [ADDR_WIDTH-1:0] addr_reg;
        
        always @(posedge clk) begin
                if (rst) begin
                        data_tx <= {DATA_WIDTH{1'b0}};
                end 
                else begin
                        if (wr && data_e  && !rd) begin
                                mem[addr_reg] <= data_rx;
                                $display("%t - mem[%0d]: %h", $time, addr_reg, data_rx);
                        end     
                        else if ({sel,rd,ld_ir} inside {3'b111, 3'b110,3'b010, 3'b000} && !data_e) begin
                                data_tx <= mem[address];                                                                  //Load datamem to data_tx
                                if ({sel,rd,ld_ir} == 3'b000) addr_reg <= address;                              //Happen for phase 6 => Ready for phase 8 to STO, if not, can't STO data to mem
                        end
                end
        end
        assign bidr = ({sel,rd,ld_ir} inside {3'b110, 3'b111, 3'b000, 3'b010,  3'b100} && (!data_e)) ? data_tx : 'hz;
        assign data_rx = bidr;
        
        initial begin
                 # 35 $readmemb("rmem.bin", mem);
        end
        
endmodule
