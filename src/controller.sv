`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HCMUT
// Engineer: 
// 
// Create Date: 03/20/2025 11:01:28 AM
// Design Name: Controller
// Module Name: controller
// Project Name: RISC 8 bit Multicycle
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


module controller(
        input clk, rst,
        input [2:0] op_in,
        input is_zero,
        output logic [2:0] op_out,
        output logic sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e,            //default control signals
        output logic load, addr_mux,                                                                     //added control signals
        output [3:0] phasestate
    );
    
    enum logic [3:0] {
        INIT,
        INST_ADDR,
        INST_FETCH,
        INST_LOAD,
        IDLE,
        OP_ADDR,
        OP_FETCH,
        ALU_OP,
        STORE
    } phase;
    assign phasestate = phase;
    enum logic [2:0] {
        HLT,    
        SKZ,
        ADD_,
        AND_,
        XOR_,
        LDA_,
        STO,
        JMP
    } OPCODE;
    
    always @(posedge clk) begin
        if (rst) begin
                 {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 'd0;
                 {load, addr_mux} <= 'd0;
                 phase <= INIT;
        end
        else begin
                case(phase)
                        INIT: begin
                                phase <= INST_ADDR;
                        end
                        INST_ADDR: begin
                                {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b1_0000_0000;
                                {load, addr_mux} <= 2'b00;
                                phase <= INST_FETCH;
                        end
                        
                        INST_FETCH: begin
                                {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b1_1000_0000;
                                {load, addr_mux} <= 2'b00;
                                phase <= INST_LOAD;
                        end
                        
                        INST_LOAD: begin
                                {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b1_1100_0000;
                                {load, addr_mux} <= 2'b00;
                                phase <= IDLE;
                        end
                        
                        IDLE: begin
                                {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b1_1100_0000;
                                {load, addr_mux} <= 2'b00;
                                op_out <= op_in;
                                phase <= OP_ADDR;
                        end
                        
                        OP_ADDR: begin
                                if (op_out == HLT) begin
                                        {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b0_0011_0000;
                                        {load, addr_mux} <= 2'b00;
                                end
                                else if (op_out inside {ADD_, AND_, XOR_, LDA_}) begin
                                        {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b0_0001_0000;
                                        {load, addr_mux} <= 2'b01;
                                end

                                else begin
                                        {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b0_0001_0000;
                                        {load, addr_mux} <= 2'b00;
                                end
                                phase <= OP_FETCH;
                        end
                        
                        OP_FETCH: begin
                                if (op_out inside {ADD_, AND_, XOR_, LDA_}) begin
                                        {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b0_1000_0000;
                                        {load, addr_mux} <= 2'b11;
                                end
                                else if (op_out == STO) begin
                                        {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b0_0000_0000;
                                        {load, addr_mux} <= 2'b01;
                                end
                                else begin
                                        {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b0_0000_0000;
                                        {load, addr_mux} <= 2'b00;
                                end
                                phase <= ALU_OP;
                        end
                        
                        ALU_OP: begin
                                //ARTH
                                if (op_out inside {ADD_, AND_, XOR_, LDA_}) begin
                                        {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b0_1000_0000;
                                        {load, addr_mux} <= 2'b00;
                                end
                                //SKZ
                                else if (op_out == SKZ) begin
                                        if (is_zero) begin
                                                {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b0_0001_0000;
                                                {load, addr_mux} <= 2'b00;
                                        end
                                end
                                //JMP
                                else if (op_out == JMP) begin
                                                {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b0_0000_0100;
                                                {load, addr_mux} <= 2'b00;
                                end
                                //STO 
                                else if (op_out == STO) begin
                                                {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b0_0000_0001;
                                                {load, addr_mux} <= 2'b00;
                                end
                                //Default
                                else begin
                                        {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b0_0000_0000;
                                        {load, addr_mux} <= 2'b00;
                                end
                                phase <= STORE;
                        end
                        
                        STORE: begin
                                //ARTH
                                if (op_out inside {ADD_, AND_, XOR_, LDA_}) begin
                                        {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b0_1000_1000;
                                        {load, addr_mux} <= 2'b00;
                                end
                                
                                //JMP
                                else if (op_out == JMP) begin
                                                {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b0_0000_0100;
                                                {load, addr_mux} <= 2'b00;
                                end
                                //STO 
                                else if (op_out == STO) begin
                                                {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b0_0000_0011;
                                                {load, addr_mux} <= 2'b00;
                                end
                                
                                //Default
                                else begin
                                        {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b0_0000_0000;
                                        {load, addr_mux} <= 2'b00;
                                end
                                phase <= INST_ADDR;
                        end
                endcase
        end     
    end
    
endmodule
