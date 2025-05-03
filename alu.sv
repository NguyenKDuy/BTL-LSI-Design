`timescale 1ns / 1ps
module alu(
    input [2:0] opcode,
    input [7:0] inA,
    input [7:0] inB,
    output reg [7:0] res,
    output reg is_zero
);

    reg signA, signB, sign_res;
    reg [2:0] expA, expB, exp_res, exp_diff;
    reg [4:0] mA, mB;
    reg [5:0] m_tmp;
    reg [3:0] m_res;
    reg overflow_flag;

    always @(*) begin
        case (opcode)
            3'b000: res = inA; // HLT
            3'b001: res = inA; // SKZ
            3'b010: begin // ADD (floating point)
                signA = inA[7];
                signB = inB[7];
                expA  = inA[6:4];
                expB  = inB[6:4];
                mA    = {1'b1, inA[3:0]};
                mB    = {1'b1, inB[3:0]};
                overflow_flag = 0;


                // Special case: inA == -inB
                if (inA[6:0] == inB[6:0] && signA != signB) begin
                    res = 8'b00000000;
                end
                // Special case: inA == 0
                else if (inA == 8'b00000000) begin
                    res = inB;
                end
                // Special case: inB == 0
                else if (inB == 8'b00000000) begin
                    res = inA;
                end
                else begin
                    // Align exponent
                    if (expA > expB) begin
                        exp_diff = expA - expB;
                        mB = mB >> exp_diff;
                        exp_res = expA;
                    end else begin
                        exp_diff = expB - expA;
                        mA = mA >> exp_diff;
                        exp_res = expB;
                    end
                    
                    // Determine sign of result
                    if (signA == signB) begin
                        sign_res = signA;
                    end else begin
                        if (mA > mB) begin
                            sign_res = signA;
                        end else begin
                            sign_res = signB;
                        end
                    end

                    // Handle 2's complement if different sign
                    if (signA != signB) begin
                        mA = (signA == 1) ? (~mA + 1) : mA;
                        mB = (signB == 1) ? (~mB + 1) : mB;
                    end
                    // Add mantissas
                    m_tmp = mA + mB;
                    

                    // Normalize result if different signs
                    if (signA != signB) begin
                        if (m_tmp[5] == 0) begin
                            m_tmp = { m_tmp[5], ~m_tmp[3:0] };
                            m_tmp = m_tmp + 1;
                        end else begin
                            m_tmp = ~m_tmp + 1;
                        end
                    end
                    // Normalize (shift left if leading bits are 0)
                    if (m_tmp[5] == 1'b1) begin
                        m_tmp = m_tmp >> 1;
                        if (exp_res < 3'b111) begin
                            exp_res = exp_res + 1;
                        end else begin
                            overflow_flag = 1'b1; 
                        end
                    end else begin
                        while (m_tmp[4] == 0 && exp_res > 0 && m_tmp != 0) begin
                            m_tmp = m_tmp << 1;
                            exp_res = exp_res - 1;
                        end
                    end
                    
                    if (overflow_flag == 1'b1) begin m_res = 4'b1111; end
                    else begin m_res = m_tmp[3:0]; end
                    res = {sign_res, exp_res, m_res};
                end
            end

            3'b011: res = inA & inB; // AND
            3'b100: res = inA ^ inB; // XOR
            3'b101: res = inB;       // LDA
            3'b110: res = inA;       // STO
            3'b111: res = inA;       // JMP
            default: res = 8'b00000000;
        endcase

        is_zero = (inA == 8'b00000000) ? 1 : 0;
    end

endmodule
