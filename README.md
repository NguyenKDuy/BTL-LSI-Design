# RISC 8-bit Multicycle Architecture

Đây là dự án thiết kế bộ xử lý RISC 8-bit với kiến trúc đa chu kỳ, được triển khai bằng Verilog.

Dự án bao gồm hai nhánh chính:

- **risc_8b**: Hỗ trợ các phép toán số nguyên.
- **risc_8b_extend**: Mở rộng hỗ trợ phép cộng số thực (floating point) trong ALU.

## Cấu trúc dự án

```
BTL-LSI-Design/
├── RISC8b.xpr                 # Dự án chính của Vivado
├── src/                       # Thư mục chứa mã nguồn Verilog
├── sim/                       # Thư mục chứa tệp mô phỏng
│   └── sim1/
│       └── behav/
│           └── xsim/
│               ├── rmem.bin  # Tệp chứa mã máy (instruction memory)
│               └── wmem.bin  # Tệp chứa dữ liệu bộ nhớ sau khi chạy
```

## Hướng dẫn sử dụng

### 1. Mở dự án

- Mở tệp `RISC8b.xpr` bằng Xilinx Vivado.
- Thêm thư mục `src/` và `sim/` vào dự án để truy cập mã nguồn và tệp mô phỏng.

### 2. Chỉnh sửa mã máy (Assembly)

- Để chỉnh sửa mã máy, mở tệp `rmem.bin` tại đường dẫn:

```
RISC8b.sim/sim1/behav/xsim/rmem.bin
```

- Sau khi chỉnh sửa, đảm bảo biên dịch lại để cập nhật thay đổi.

### 3. Xem dữ liệu bộ nhớ sau khi chạy

- Sau khi chạy mô phỏng, dữ liệu bộ nhớ sẽ được lưu tại tệp `wmem.bin`:

```
RISC8b.sim/sim1/behav/xsim/wmem.bin
```

- Mở tệp này để kiểm tra kết quả mô phỏng.
