`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 03:01:56 PM
// Design Name: 
// Module Name: tb_Memory
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


module tb_memory_5x8;

    // Khai báo các tín hiệu điều khiển
    reg         clk;
    reg         rst;
    reg         sel;
    reg         rd;
    reg         wr;
    reg         ld_ir;
    reg  [4:0]  address;
    wire [7:0]  data_out;

    // Khai báo tín hiệu cho bus dữ liệu 2 chiều
    // Khi tb_drive_en = 1, testbench sẽ điều khiển data_e bằng tb_drive_data
    reg         tb_drive_en;
    reg  [7:0]  tb_drive_data;
    wire [7:0]  data_e;
    assign data_e = tb_drive_en ? tb_drive_data : 8'hZZ;

    // Khai báo instance của module memory_5x8
    memory_5x8 dut (
        .clk(clk),
        .rst(rst),
        .sel(sel),
        .rd(rd),
        .wr(wr),
        .ld_ir(ld_ir),
        .data_e(data_e),
        .address(address),
        .data_out(data_out)
    );

    // Sinh tín hiệu clock: chu kỳ 10ns (tạo cạnh lên/xuống sau 5ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Đoạn mô phỏng (stimulus)
    initial begin
        // Khởi tạo ban đầu
        rst = 1;
        sel = 0;
        rd  = 0;
        wr  = 0;
        ld_ir = 0;
        address = 5'd0;
        tb_drive_data = 8'd0;
        tb_drive_en   = 0;
        
        // Đợi một vài chu kỳ clock để reset có hiệu lực
        #12;  
        rst = 0;
        #10;
        
        // --- Ghi dữ liệu ---
        // Ghi giá trị 8'hA5 vào địa chỉ 5'b00101
        address = 5'b00101;
        sel = 1;
        wr  = 1;
        rd  = 0;   // Đảm bảo không có hoạt động đọc
        tb_drive_data = 8'hA5;
        tb_drive_en = 1; // Kích hoạt driver trên bus data_e
        #10;  // Đợi đến cạnh clock tiếp theo
        tb_drive_en = 0;  // Tắt driver sau khi ghi
        wr = 0;
        #10;
        
        // --- Đọc trực tiếp (case 3'b010: sel=0, rd=1, ld_ir=0) ---
        address = 5'b00101;
        sel = 0;
        rd  = 1;
        ld_ir = 0;
        #10;  // Đợi một chu kỳ clock để dữ liệu được cập nhật
        
        // --- Đọc qua thanh ghi địa chỉ trung gian ---
        // Bước 1: Lưu địa chỉ vào address_reg (case 3'b110: sel=1, rd=1, ld_ir=0)
        address = 5'b00101;
        sel = 1;
        rd  = 1;
        ld_ir = 0;
        #10;  // Cạnh clock, địa chỉ được lưu vào address_reg
        
        // Bước 2: Đọc dữ liệu từ address_reg (case 3'b111: sel=1, rd=1, ld_ir=1)
        ld_ir = 1;
        #10;  // Dữ liệu từ ô nhớ tại địa chỉ đã lưu sẽ được đưa ra data_out (và nạp vào IR)
        
        // Reset các tín hiệu điều khiển về mặc định
        sel = 0;
        rd  = 0;
        ld_ir = 0;
        #10;
        
        // --- Ghi và đọc thêm ---
        // Ghi giá trị 8'h5A vào địa chỉ 5'b01010
        address = 5'b01010;
        sel = 1;
        wr  = 1;
        rd  = 0;
        tb_drive_data = 8'h5A;
        tb_drive_en = 1;
        #10;
        tb_drive_en = 0;
        wr = 0;
        #10;
        
        // Đọc trực tiếp từ địa chỉ 5'b01010 (với tổ hợp 3'b010)
        address = 5'b01010;
        sel = 0;
        rd  = 1;
        ld_ir = 0;
        #10;
        
        $finish;
    end

    // In ra thông tin các tín hiệu để theo dõi quá trình mô phỏng
    initial begin
        $monitor("Time=%0t | rst=%b sel=%b rd=%b wr=%b ld_ir=%b address=%b | data_e=%h data_out=%h", 
                 $time, rst, sel, rd, wr, ld_ir, address, data_e, data_out);
    end

endmodule