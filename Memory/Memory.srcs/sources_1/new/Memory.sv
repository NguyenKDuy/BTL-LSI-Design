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
    input             sel,       // Tín hiệu chọn bộ nhớ
    input             rd,        // 1 = cho phép đọc
    input             wr,        // 1 = cho phép ghi
    input             ld_ir,     // 1 = cho phép nạp IR (data_out)
    inout      [7:0]  data_e,    // Bus dữ liệu 2 chiều
    input      [4:0]  address,   // Địa chỉ 5 bit (0..31)

    output reg [7:0]  data_out   // Dữ liệu đầu ra (có thể là lệnh hoặc dữ liệu)
);

    // Mảng bộ nhớ 32 ô, mỗi ô 8 bit
    reg [7:0] mem [0:31];

    // Thanh ghi tạm để giữ dữ liệu đọc ra từ bộ nhớ
    reg [7:0] read_data_reg;

    // Khối đồng bộ (đọc/ghi)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset
            read_data_reg <= 8'b0;
            data_out      <= 8'b0;
        end
        else if (sel) begin
            // Chỉ thực hiện nếu sel=1 (bộ nhớ được chọn)
            if (wr && !rd) begin
                // Ghi dữ liệu từ bus vào bộ nhớ
                mem[address] <= data_e;
            end
            else if (rd && !wr) begin
                // Đọc dữ liệu từ bộ nhớ
                read_data_reg <= mem[address];
                
                // Nếu cần nạp vào IR (hoặc thanh ghi lệnh) thì cập nhật data_out
                if (ld_ir) begin
                    data_out <= mem[address];
                end
            end
            // Nếu rd=wr=0 hoặc rd=wr=1 thì không làm gì (có thể bổ sung xử lý nếu muốn)
        end
    end

    // Mạch ba trạng thái cho bus data_e:
    // - Khi đang đọc (rd=1, wr=0, sel=1), đưa dữ liệu ra bus
    // - Ngược lại, để bus ở trạng thái trở kháng cao
    assign data_e = (sel && rd && !wr) ? read_data_reg : 8'bz;

endmodule