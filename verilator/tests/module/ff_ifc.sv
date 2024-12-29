`timescale 1ns/1ns

interface ff_ifc #(parameter SIZE=32)(input bit clk);
  logic reset;
  logic valid_i;
  logic [SIZE-1:0] data_i;
  logic [SIZE-1:0] data_o;
  logic valid_o;

  modport bench (
        input clk,
        output reset,
        output valid_i,
        output data_i,
        input data_o,
        input valid_o
  );

  modport dut (
      input clk,
      input reset,
      input valid_i,
      input data_i,
      output data_o,
      output valid_o
);
endinterface
