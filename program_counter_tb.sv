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
// Revision:
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
        $monitor("Time = %0t | rst = %b | clk = %b | sel = %b | ld = %b | inc = %b | jmp = %d | out = %d", 
                  $time, rst, clk, sel, ld, inc, jmp, out);
        
        // Reset hệ thống
        rst = 1;  
        #20;  
        rst = 0;  
        
        sel = 1;
        #10;
        sel = 0;

        // Kiểm tra tăng giá trị (inc)
        inc = 1;
        #20;
        inc = 0;
        
        sel = 1;
        #10;
        sel = 0;
        
        // Kiểm tra load giá trị nhảy
        ld = 1;
        jmp = 5'b10101; // Giá trị jump
        #20;
        ld = 0;
        
        sel = 1;
        #10;
        sel = 0;
        
        #100;  
        $finish;  
    end  
endmodule  







