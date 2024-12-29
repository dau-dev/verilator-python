`timescale 1ns/1ns

module ff #(parameter SIZE = 32)(
  input bit clk,
  input bit reset,
  input bit valid_i,
  input logic [SIZE-1:0] data_i,
  output logic [SIZE-1:0] data_o,
  output logic valid_o
);

reg valid;
reg [SIZE-1:0] data;

assign data_o = data;
assign valid_o = valid;

always_ff @(posedge clk) begin
  if(reset) begin
    data <= 'b0;
    valid <= 1'b0;
  end else if (valid_i) begin
    data <= data_i;
    valid <= 1'b1;
  end else begin
    valid <= 1'b0;
  end
end


`ifndef SYNTHESIS
initial begin
  $display("[%0t]\tTracing to logs/dump.vcd...", $time);
  $dumpfile("logs/dump.vcd");
  $dumpvars();
  $display("[%0t]\tModel running...", $time);
end
`endif

endmodule
