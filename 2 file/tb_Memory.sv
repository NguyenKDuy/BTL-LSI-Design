    `timescale 1ns / 1ps
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 03/11/2025 03:01:56 PM
    // Design Name: 
    // Module Name: tb_Memory
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
    
    
module tb_memory_5x8;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 5;
    parameter MEM_DEPTH  = (1 << ADDR_WIDTH);

    // Inputs to DUT
    reg clk;
    reg rst;
    reg sel;
    reg rd;
    reg wr;
    reg ld_ir;
    reg data_e;
    reg [ADDR_WIDTH-1:0] address;

    // Bidirectional data signal
    wire [DATA_WIDTH-1:0] data_out;

    // Internal driver to simulate data writing (tristate buffer)
    reg [DATA_WIDTH-1:0] data_driver;
    assign data_out = (wr && sel && data_e) ? data_driver : {DATA_WIDTH{1'bz}};

    // For observing data during read
    wire [DATA_WIDTH-1:0] data_read;
    assign data_read = data_out;

    // Instantiate the memory module
    memory_5x8 uut (
        .clk(clk),
        .rst(rst),
        .sel(sel),
        .rd(rd),
        .wr(wr),
        .ld_ir(ld_ir),
        .data_e(data_e),
        .address(address),
        .data_out(data_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Clock period = 10ns
    end

    // Main stimulus
    initial begin
        $display("----- MEMORY TEST START -----");

        // Initial values
        rst = 1; sel = 0; rd = 0; wr = 0; ld_ir = 0; data_e = 0;
        address = 0; data_driver = 0;

        #12;  // Wait some time then release reset
        rst = 0;

        // === Write test ===
        sel = 1; wr = 1; rd = 0; data_e = 1;

        // Write 0xAB to address 3
        address = 5'd3;
        data_driver = 8'hAB;
        #10;

        // Write 0x55 to address 10
        address = 5'd10;
        data_driver = 8'h55;
        #10;

        // === Read test ===
        wr = 0; rd = 1; ld_ir = 1;

        // Read from address 3
        address = 5'd3;
        #10;
        $display("Read from address 3: 0x%0h (expected: 0xAB)", data_read);

        // Read from address 10
        address = 5'd10;
        #10;
        $display("Read from address 10: 0x%0h (expected: 0x55)", data_read);

        // === Test read from unwritten address ===
        address = 5'd20;
        #10;
        $display("Read from address 20 (unwritten): 0x%0h (expected: undefined or 0)", data_read);

        // === Test disabled select signal ===
        sel = 0;  // Disable memory
        address = 5'd3;
        #10;
        $display("Read with sel=0 (should be high-Z or no change): 0x%0h", data_read);

        // === Test simultaneous rd and wr ===
        sel = 1; rd = 1; wr = 1; data_driver = 8'hFF; address = 5'd15;
        #10;
        $display("Simultaneous rd & wr at address 15, read: 0x%0h", data_read);

        // === Final Reset and check ===
        rst = 1;
        #10;
        rst = 0;
        rd = 1; wr = 0; sel = 1; address = 5'd3;
        #10;
        $display("After reset, read address 3: 0x%0h (expected: 0)", data_read);

        $display("----- MEMORY TEST END -----");
        $stop;
    end

endmodule