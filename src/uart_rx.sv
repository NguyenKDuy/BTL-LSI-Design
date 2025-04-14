`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2025 10:35:17 AM
// Design Name: 
// Module Name: uart_rx
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


module uart_rx #( parameter
  CLK_HZ = 200_000_000,
  BAUD = 9600,
  bit [15:0] BAUD_DIVISOR_2 = CLK_HZ / BAUD / 2
)(
  input clk,
  input nrst,

  output logic [7:0] rx_data = '0,
  output logic rx_busy = 1'b0,
  output logic rx_done,         // read strobe
  output logic rx_err,
  input rxd
);


// synchronizing external rxd pin to avoid metastability
logic rxd_s;
delay #(
  .LENGTH( 2 ),
  .WIDTH( 1 )
) rxd_synch (
  .clk( clk ),
  .nrst( nrst ),
  .ena( 1'b1 ),
  .in( rxd ),
  .out( rxd_s )
);


logic start_bit_strobe;
edge_detect rxd_fall_detector (
  .clk( clk ),
  .anrst( nrst ),
  .in( rxd_s ),
  .falling( start_bit_strobe )
);


logic [15:0] rx_sample_cntr = (BAUD_DIVISOR_2 - 1'b1);

logic rx_do_sample;
assign rx_do_sample = (rx_sample_cntr[15:0] == '0);


// {rx_data[7:0],rx_data_9th_bit} is actually a shift register
logic rx_data_9th_bit = 1'b0;
always_ff @ (posedge clk) begin
  if( ~nrst ) begin
    rx_busy <= 1'b0;
    rx_sample_cntr <= (BAUD_DIVISOR_2 - 1'b1);
    {rx_data[7:0],rx_data_9th_bit} <= '0;
  end else begin
    if( ~rx_busy ) begin
      if( start_bit_strobe ) begin

        // wait for 1,5-bit period till next sample
        rx_sample_cntr[15:0] <= (BAUD_DIVISOR_2 * 3 - 1'b1);
        rx_busy <= 1'b1;
        {rx_data[7:0],rx_data_9th_bit} <= 9'b10000000_0;

      end
    end else begin

      if( rx_sample_cntr[15:0] == '0 ) begin
        // wait for 1-bit-period till next sample
        rx_sample_cntr[15:0] <= (BAUD_DIVISOR_2 * 2 - 1'b1);
      end else begin
        // counting and sampling only when 'busy'
        rx_sample_cntr[15:0] <= rx_sample_cntr[15:0] - 1'b1;
      end

      if( rx_do_sample ) begin
        if( rx_data_9th_bit == 1'b1 ) begin
          // early asynchronous 'busy' reset
          rx_busy <= 1'b0;
        end else begin
          {rx_data[7:0],rx_data_9th_bit} <= {rxd_s, rx_data[7:0]};
        end
      end

    end // ~rx_busy
  end // ~nrst
end

always_comb begin
  // rx_done and rx_busy fall simultaneously
  rx_done <= rx_data_9th_bit && rx_do_sample && rxd_s;
  rx_err <= rx_data_9th_bit && rx_do_sample && ~rxd_s;
end

endmodule
