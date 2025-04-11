#Custom 8-bit Floating Point Format (`1|3|4`)

##Format Structure

This floating point format is custom-designed with a total of 8 bits, divided as:

- **Sign (1 bit)**:
  
  - `0`: Positive number
    
  - `1`: Negative number

- **Exponent (3 bits)**:
  
  - Biased exponent (Bias = 3) → So actual exponent **E = e - 3**
    
  - Range: `000` (E = -3) to `111` (E = +4)

- **Mantissa (4 bits)**:
  - Stored as the fractional part of `1.xxxx` (implicit leading 1)
    
  - Actual mantissa: `1.m`
      
  - Ex: `0110` → `1.0110` = 1.375

Bias = 3 (since exponent is 3 bits → 2^(3−1) = 4 → bias = 3)

Range: (−31.0,−0.1328125)∪(0.1328125,31.0)

      In this part, I use 8'b00000000 to represent zero for handling opcodes.

      Therefore, we will start with 8'b00000001 and end with 8'b01111111 in the case of positive numbers. For negative numbers, we use the same range but with the sign bit set to 1, resulting in values from 8'b10000001 to 8'b11111111.

Exponent Gap Issue

- If exponent difference > 4, smaller operand is shifted out completely
  
  → Value is lost → result ≈ larger operand
  
  - Ex: 31.0 + 0.1328125 ≈ 31.0 (0.1328125 is lost)

Low Precision

- Only 4-bit mantissa → ~1 decimal digit of precision
  
- Cannot accurately represent numbers like `2.34`, `0.1`, etc.
