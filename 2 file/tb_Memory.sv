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
    
    
module memory_5x8_tb;
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 5;
    
    // Khai báo tín hiệu testbench
    reg                     clk;
    reg                     rst;
    reg                     sel;
    reg                     rd;
    reg                     wr;
    reg                     ld_ir;
    reg                     data_e;
    reg [ADDR_WIDTH-1:0]    address;
    
    // Các tín hiệu cho driver bên ngoài của cổng bidirectional:
    reg                     tb_write_enable;
    reg [DATA_WIDTH-1:0]    tb_data_driver;
    // Tín hiệu data_out được kết nối giữa module và testbench.
    wire [DATA_WIDTH-1:0]   data_out;
    
    // Driver cho bidirectional port:
    // Khi tb_write_enable = 1, testbench sẽ điều khiển data_out,
    // còn khi bằng 0 thì data_out sẽ là high impedance (để module điều khiển khi đọc).
    assign data_out = tb_write_enable ? tb_data_driver : {DATA_WIDTH{1'bz}};
    
    // Instantiate module memory_5x8
    memory_5x8 #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) uut (
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
    
    // Tạo xung clk: chu kỳ 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Chu trình test
    initial begin
        // Khởi tạo giá trị ban đầu
        rst = 1;
        sel = 0;
        rd = 0;
        wr = 0;
        ld_ir = 0;
        data_e = 0;
        address = 0;
        tb_write_enable = 0;
        tb_data_driver = 0;
        
        // Áp dụng reset trong 20ns
        #20;
        rst = 0;
        
        // --- Test ghi ---
        // Ghi giá trị 8'hA5 vào địa chỉ 5'b00101
        sel = 1;
        wr = 1;
        rd = 0;
        data_e = 1;
        address = 5'b00101;
        // Bật driver của testbench để đưa dữ liệu vào cổng bidirectional
        tb_write_enable = 1;
        tb_data_driver = 8'hA5;
        
        // Chờ một xung clk để thực hiện ghi
        #10;
        
        // Tắt driver của testbench để chuyển sang chế độ đọc
        tb_write_enable = 0;
        tb_data_driver = 8'h00;
        
        // --- Test đọc ---
        // Đọc dữ liệu từ địa chỉ 5'b00101
        sel = 1;
        wr = 0;
        rd = 1;
        data_e = 1;
        // address giữ nguyên giá trị vừa ghi
        
        // Chờ một xung clk để đọc dữ liệu
        #10;
        
        // In ra kết quả đọc được
        $display("Time %0t: Đọc giá trị: %h (mục tiêu: A5)", $time, data_out);
        
        // Kết thúc mô phỏng sau vài xung clk
        #20;
        $finish;
    end
endmodule