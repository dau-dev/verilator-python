`timescale 1ns/1ns

module ff_top (input bit clk);

ff_ifc IFC(clk);
ff dut (
  IFC.dut.clk,
  IFC.dut.reset,
  IFC.dut.valid_i,
  IFC.dut.data_i,
  IFC.dut.data_o,
  IFC.dut.valid_o
);
ff_tb bench (IFC.bench);

endmodule
