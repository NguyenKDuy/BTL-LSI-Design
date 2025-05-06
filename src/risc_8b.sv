`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2025 10:37:41 PM
// Design Name: 
// Module Name: risc_8b
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


module risc_8b#(
        parameter DATA_WIDTH = 8,                  // Độ rộng dữ liệu
        parameter ADDR_WIDTH = 5                  // Độ rộng địa chỉ (cho 2^5 = 32 ô)
)(
        input clk, rst, 
        output [ADDR_WIDTH-1:0] pc_counter,
        output  [DATA_WIDTH-1:0] alu_out,
        output halt
    );
    logic [ADDR_WIDTH-1:0] address_top;
    tri [DATA_WIDTH-1:0] bidr_top, data_out_top;
    logic [DATA_WIDTH-1:0] in_A_top, in_B_top;
    logic [2:0] opcode_top;
    logic [3:0] phase_top;
    program_counter PC 
        (.rst (rst),          
        .clk (clk & !halt),            
        .sel (sel_top),             
        .inc (inc_pc_top),             
        .ld (ld_pc_top),               
        .jmp (data_out_top[4:0]),        
        .out(pc_counter));
    
      memory Memory
      (.clk (clk),        
       .rst(rst),        
       .sel(sel_top),         
       .rd (rd_top),          
       .wr(wr_top),        
       .ld_ir(ld_ir_top),      
       .data_e(data_e_top),     
       .address(address_top),   
       .bidr(bidr_top));
       
       Register Regis
       (.clk(clk),          // Clock
        .rst(rst),          // Reset
        .load(load_top),         // Signal Load dữ liệu ra output
        .data_in(data_out_top), // input 8-bit
        .inB(in_B_top));
    
        alu ALU (
                .opcode(opcode_top),
                .inA(in_A_top),
                .inB(in_B_top),
                .res(alu_out),
                .is_zero(is_zero_top));   
                
        accumulator Acc(
                .clk(clk),            
                .rst(rst),
                .ld_ac(ld_ac_top),
                .data_in(alu_out),
                .data_out(in_A_top)
);
                
        ADD_MUX add_mux 
        (.instr_address (pc_counter),   
        .operand_address(data_out_top[4:0]), 
        .select(addr_mux_top),       
        .address_out(address_top)   
        );
        
        controller Controller(
                .clk(clk), 
                .rst(rst),
                .op_in(data_out_top[7:5]),
                .is_zero(is_zero_top),
                .op_out(opcode_top),
                .sel(sel_top), 
                .rd(rd_top), 
                .ld_ir(ld_ir_top), 
                .halt(halt), 
                .inc_pc(inc_pc_top), 
                .ld_ac(ld_ac_top), 
                .ld_pc(ld_pc_top), 
                .wr(wr_top), 
                .data_e(data_e_top),            //default control signals
                .load(load_top), 
                .addr_mux(addr_mux_top),
                .phasestate(phase_top));

        bus_control BS (
                .ctrl_signal (ctrl_signal_top|| data_e_top),
                .data_tx(in_A_top),
                .data_rx(data_out_top),
                .bidr(bidr_top)
        );
        
        assign ctrl_signal_top = {sel_top,rd_top,ld_ir_top} inside {3'b110, 3'b111, 3'b000, 3'b010, 3'b100} ? 0 : 1;
endmodule

