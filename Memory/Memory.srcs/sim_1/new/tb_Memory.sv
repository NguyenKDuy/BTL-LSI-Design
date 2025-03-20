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
    // Tín hiệu testbench
    reg         clk;
    reg         rst;
    reg         sel;
    reg         rd;
    reg         wr;
    reg         ld_ir;
    reg  [4:0]  address;

    // Dùng reg + cờ drive_data để mô phỏng bus 2 chiều data_e
    reg  [7:0]  data_reg;    // Giá trị sẽ được ghi ra bus
    reg         drive_data;  // Cờ cho biết testbench có đang ghi ra bus không

    // Tín hiệu từ module
    wire [7:0]  data_e;      // Bus 2 chiều
    wire [7:0]  data_out;    // Đầu ra từ bộ nhớ (có thể là IR)

    // Kết nối tới mô-đun memory_5x8
    memory_5x8 uut (
        .clk      (clk),
        .rst      (rst),
        .sel      (sel),
        .rd       (rd),
        .wr       (wr),
        .ld_ir    (ld_ir),
        .data_e   (data_e),
        .address  (address),
        .data_out (data_out)
    );

    // Cơ chế ba trạng thái cho data_e trong testbench
    // Khi drive_data=1 => đưa data_reg ra bus
    // Khi drive_data=0 => bus ở trạng thái Z (nhường cho module đọc/ghi)
    assign data_e = drive_data ? data_reg : 8'bz;

    // Tạo xung clock 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Kịch bản test
    initial begin
        // Khởi tạo
        rst        = 1;
        sel        = 0;
        rd         = 0;
        wr         = 0;
        ld_ir      = 0;
        drive_data = 0;
        data_reg   = 8'd0;
        address    = 5'd0;

        // Bước 1: reset
        #10;
        rst = 0;   // Hết reset

        // Bước 2: Ghi dữ liệu vào bộ nhớ
        sel        = 1;       // Chọn bộ nhớ
        wr         = 1;       // Kích hoạt ghi
        rd         = 0;       // Không đọc
        address    = 5'd0;    // Ghi vào địa chỉ 0
        data_reg   = 8'hAA;   // Giá trị cần ghi
        drive_data = 1;       // Đưa data_reg lên bus
        #10;                  // Chờ 1 chu kỳ clock (posedge)
        #10;                  // Thêm 1 chu kỳ để hoàn tất ghi

        // Dừng ghi
        wr         = 0;
        drive_data = 0;
        #10;

        // Bước 3: Đọc dữ liệu vừa ghi
        rd         = 1;       // Kích hoạt đọc
        // Sau cạnh clock tới, module sẽ lấy mem[address] ra data_e
        #10;
        #10;
        $display("Read from address 0: data_e = 0x%h, data_out = 0x%h", data_e, data_out);

        // Bước 4: Nạp IR (ld_ir=1) để ghi vào data_out
        ld_ir = 1;
        #10;
        ld_ir = 0;
        #10;
        $display("After ld_ir, data_out = 0x%h", data_out);

        // Bước 5: Thử ghi vào địa chỉ 1
        rd         = 0;
        wr         = 1;
        address    = 5'd1;
        data_reg   = 8'h55;
        drive_data = 1;
        #10;
        #10;

        // Đọc lại địa chỉ 1
        wr         = 0;
        drive_data = 0;
        rd         = 1;
        address    = 5'd1;
        #10;
        #10;
        $display("Read from address 1: data_e = 0x%h, data_out = 0x%h", data_e, data_out);

        // Kết thúc mô phỏng
        #10;
        $stop;
    end

endmodule