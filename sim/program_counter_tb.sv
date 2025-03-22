`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: BACH NGUYEN DUY
// 
// Create Date: 03/12/2025 03:21:18 PM
// Design Name: 
// Module Name: proggram_counter_tb
// Project Name: Design simple RISC CPU
// Target Devices: 
// Tool Versions: Vivado 2024.2
// Description: 
// 
// Dependencies: 
// 
// Revision:0.02 - Synchronous CLOCK
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module program_counter_tb;  
    reg rst = 0;  
    reg clk = 0;  
    reg sel = 0;  
    reg inc = 0;  
    reg ld = 0;  
    reg [4:0] jmp = 0;  
    wire [4:0] out;  

    // Tạo xung clock với chu kỳ 20ns (50MHz)
    always #10 clk = ~clk;  

    // Instance của module program_counter
    program_counter UUT (  
        .rst(rst),  
        .clk(clk),  
        .sel(sel),  
        .ld(ld),  
        .inc(inc),  
        .jmp(jmp),  
        .out(out)  
    );  

    // Test scenarios
    initial begin  
        $monitor("Time = %0t | rst = %b | clk = %b | sel = %b | ld = %b | inc = %b | jmp = %b | out = %b", 
                  $time, rst, clk, sel, ld, inc, jmp, out);

        
        // inc and sel change output data
        for (int i = 0; i < 31; i = i + 1) begin
            inc = 1;  // Kích hoạt tín hiệu inc
            #10;      // Chờ trong 10 đơn vị thời gian
            inc = 0;  // Tắt tín hiệu inc
            #5;      // Chờ thêm 10 đơn vị thời gian
            sel = 1;  // Kích hoạt tín hiệu inc
            #10;      // Chờ trong 10 đơn vị thời gian
            sel = 0;  // Tắt tín hiệu inc
            #5;      // Chờ thêm 10 đơn vị thời gian
        end
        
        sel = 1;
        #10;
        sel = 0;

        // Kiểm tra tăng giá trị (inc)
        inc = 1;
        #10;
        inc = 0;
        
        // Kiểm tra reset
        rst =1;
        #5;
        sel = 0;
        rst = 0;
        sel = 1;
        #10;
        sel = 0;
        
        // Kiểm tra load giá trị nhảy
        ld = 1;
        jmp = 5'b11111;// Giá trị jump 1f
        #20;
        ld = 0;
        rst =1;
        #5;
        sel = 0;
        rst =0;
        // Kiểm tra load giá trị nhảy nếu không có load
        jmp = 5'b00111;// Giá trị jump 1f
        sel = 1;
        #5;
        sel = 0;
        #5;
         // Kiểm tra load giá trị nhảy nếu load = 1 nhưng sel = 0
        ld=1 ;
        #5;
        //
        sel = 1; //Chọn giá trị vừa jump đến = 7
        
       
        
        #50;  
        $finish;  
    end  
endmodule  







