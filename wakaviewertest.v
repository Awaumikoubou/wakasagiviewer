`include "def.h"
/* test bench */
`timescale 1ns/1ps

module wakaviewertest;
   parameter STEP = 4;
   reg rst_N, clk;

   wakaviewer wakaviewer0 (.clk(clk), .rst_N(rst_N));
   
   always #(STEP/2) begin
      clk <= ~clk;
   end

   initial begin
      $dumpfile("wakaviewer.vcd");
      $dumpvars();
      
      clk <= `DISABLE;
      rst_N <= `ENABLE_N;
      #(STEP*1/4)
      rst_N <= `DISABLE_N;
      #STEP
      rst_N <= `DISABLE_N;
      #(STEP*17000)
      #STEP
      $finish;
   end 
endmodule
