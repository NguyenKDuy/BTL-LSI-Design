`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2025 08:51:53 PM
// Design Name: 
// Module Name: controller_tb
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

module controller_tb(

    );
    
       logic clk, rst;
       logic [2:0] op_in;
       logic is_zero;
       logic [2:0] op_out;
       logic sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e;           //default control signals
       logic load, addr_mux;
        
        controller dut (clk, rst,op_in,is_zero,op_out, sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e,load, addr_mux);
        parameter logic [2:0] 
                        HLT  = 3'b000,
                        SKZ  = 3'b001,
                        ADD_ = 3'b010,
                        AND_ = 3'b011,
                        XOR_ = 3'b100,
                        LDA_ = 3'b101,
                        STO  = 3'b110,
                        JMP  = 3'b111;
        initial begin
               rst = 0;
               clk = 0; 
       end
       always #10 clk = ~clk;
       initial begin
                // Reset to initial values
                rst = 1;
                #20;
                rst = 0;
                
                // HLT
                #60;
                op_in = HLT;
                is_zero =  0;
                #100;        
                
                //SKZ
                #60;
                op_in = SKZ;
                is_zero =  0;
                #100;   
                
                //SKZ
                #60;
                op_in = SKZ;
                is_zero =  1;
                #100;   
                
                //ADD_
                #60;
                op_in = ADD_;
                is_zero =  0;
                #100;   
                
                //AND_
                #60;
                op_in = AND_;
                is_zero =  0;
                #100;  
                
                //XOR_
                #60;
                op_in = XOR_;
                is_zero =  0;
                #100;   
                
                //LDA_
                #60;
                op_in = LDA_;
                is_zero =  0;
                #100;   
                
                //STO
                #60;
                op_in = STO;
                is_zero =  0;
                #100;   
                
                 //JMP
                #60;
                op_in = JMP;
                is_zero =  0;
                #100;   
                
       end
       
       
endmodule       
