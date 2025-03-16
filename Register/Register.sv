`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2025 01:00:57 PM
// Design Name: 
// Module Name: Register
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


module Register(
    input  logic clk,          // Clock
    input  logic rst,          // Reset
    input  logic load,         // Signal Load dữ liệu ra output
    input  logic [7:0] data_in, // input 8-bit
    output logic [7:0] inA      // ouput 8-bit
);

//    logic [7:0] reg_buffer;  // Thanh ghi tạm lưu dữ liệu

    always @(posedge clk) begin
        if (rst) begin
//            reg_buffer <= 8'b0;  // Reset thanh ghi về 0
            inA   <= 8'b0;  // Reset đầu ra về 0
        end 
        else begin      //truyền trực tiếp ko dùng buffer
            if (load)
                inA <= data_in;
        end  
  
      
   //Dùng buffer     
         //Trường hợp này sai khi input và load cùng 1 thời điểm thì output ko bằng input vì input chỉ load được vào buffer khi load = 0
//        else begin
//            if (!load) 
//                reg_buffer <= data_in;  // Ghi vào thanh ghi tạm khi load = 0
//            if (load)
//                inA <= reg_buffer;
//        end
        
        //Trường hợp này sai vì khi input và load cùng một thời điểm thì sau 1 clock output mới cập nhật = input
//        else begin
//            if (load)
//                reg_buffer <= data_in;
//                inA <= reg_buffer;
//        end
        
        

    end

endmodule
