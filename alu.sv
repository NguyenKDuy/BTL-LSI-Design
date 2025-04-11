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
    reg tmp;

    always @(*) begin
        case (opcode)
            3'b000: res = inA; // HLT
            3'b001: res = inA; // SKZ
            3'b010: begin
                    signA = inA[7];
                    signB = inB[7];
                    expA  = inA[6:4];
                    expB  = inB[6:4];
                    mA    = {1'b1, inA[3:0]};
                    mB    = {1'b1, inB[3:0]};
                    tmp = 0;
                    //STEP1: Special case relating to zero
                    //Case: inA = -inB
                    if (inA[6:0] == inB[6:0] && signA != signB) begin
                        res = 8'b00000000;
                        end
                    //Case: inA = 0
                    else if (inA == 8'b00000000) begin res = inB; end
                    //Case: inB = 0
                    else if (inB == 8'b00000000) begin res = inA; end
                    else begin
                    //STEP2: Align exponent      
                        if (expA > expB) begin
                            exp_diff = expA - expB;
                            mB = mB >> exp_diff;
                            exp_res = expA;
                        end else begin
                            exp_diff = expB - expA;
                            mA = mA >> exp_diff;
                            exp_res = expB;
                        end
                    //STEP3: Determining sign
                        if (signA == signB) begin
                            sign_res = signA;
                        end else begin
                            if (mA > mB) begin
                                sign_res = signA;
                            end else begin
                                sign_res = signB;
                            end
                        end
                    //STEP4: Add mA and mB
                        //Case: different sign
                        if (signA != signB) begin
                            mA = (signA == 1) ? (~mA + 1) : mA;
                            mB = (signB == 1) ? (~mB + 1) : mB;
                            //Case: abs of negative number > abs of another one
                            if (sign_res == 1) begin tmp = 1; end
                        end
                        //add operation in 2 case (same sign and different sign)
                        m_tmp = mA + mB;
                        //Case different sign: Two's complement
                        if (signA != signB) begin
                            m_tmp = ~m_tmp + 1;
                        end
                    //STEP5: Normalization
                        if (m_tmp[5] == 1'b1 && tmp == 0) begin
                            m_tmp = m_tmp >> 1;
                            exp_res = exp_res + 1;
                        end else begin
                            while (m_tmp[4] == 0 && exp_res > 0 && m_tmp != 0) begin
                                m_tmp = m_tmp << 1;
                                exp_res = exp_res - 1;
                            end
                        end
                        m_res = m_tmp[3:0];
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
