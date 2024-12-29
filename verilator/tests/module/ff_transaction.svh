`timescale 1ns/1ns

class transaction;
	bit [31:0] data_in;
  bit reset_in;
	bit [31:0] data_out;

	function void set_inputs(bit dut_reset, bit [31:0] dut_in);
		data_in = dut_in;
    reset_in = dut_reset;
	endfunction

  function void clock();
    if (reset_in == 1'b1) begin
      data_out = 'b0;
    end else begin
      data_out = data_in;
    end
  endfunction

  function bit check_output(bit [31:0] dut_out);
		return (dut_out == data_out);
	endfunction

endclass
