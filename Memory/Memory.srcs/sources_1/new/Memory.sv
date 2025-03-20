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


module memory_5x8 (
    input             clk,       // Clock
    input             rst,       // Reset 
    input             sel,       // Tín hiệu chọn 
    input             rd,        // 1 = cho phép đọc
    input             wr,        // 1 = cho phép ghi
    input             ld_ir,     // 1 = cho phép nạp IR 
    inout      [7:0]  data_e,    // Bus dữ liệu 2 chiều
    input      [4:0]  address,   // Địa chỉ 5 bit

    output reg [7:0]  data_out   // Dữ liệu đầu ra (có thể là lệnh hoặc dữ liệu)
);

    // Mảng nhớ 32 ô, mỗi ô 8 bit
    reg [7:0] mem_array [0:31];

    // Thanh ghi IR 
    reg [7:0] IR;

    // Thanh ghi lưu địa chỉ trung gian 
    reg [4:0] address_reg;

    integer i;

    // Bus dữ liệu hai chiều: chỉ xuất dữ liệu ra khi sel=1 và rd=1 (không ghi)
    assign data_e = (sel && rd && !wr) ? data_out : 8'hZZ;

    always @(posedge clk) begin
        if (rst) begin
            // Đưa tất cả về 0
            data_out    <= 8'd0;
            IR          <= 8'd0;
            address_reg <= 5'd0;
            for (i = 0; i < 32; i = i + 1) begin
                mem_array[i] <= 8'd0;
            end
        end 
        else begin
            // Xử lý ghi nếu cần (sel=1, wr=1, rd=0)
            if (sel && wr && !rd) begin
                mem_array[address] <= data_e;
            end

            // Xử lý đọc theo tổ hợp {sel, rd, ld_ir}
            case ({sel, rd, ld_ir})
                3'b110: begin // = 'd6
                    // Đưa address vào thanh ghi
                    address_reg <= address;
                end

                3'b111: begin // = 'd7
                    // Dùng địa chỉ lưu ở thanh ghi truy xuất lệnh/data -> data_out
                    data_out <= mem_array[address_reg];
                
                    IR <= mem_array[address_reg];
                end

                3'b010: begin // = 'd2
                    // Dùng địa chỉ từ address truy xuất thẳng data mem
                    data_out <= mem_array[address];
                end

                default: begin
                    // Không làm gì 
                end
            endcase
        end
    end

endmodule
