`timescale 1ns/1ns
`include "ff_transaction.svh"
`include "ff_testing_env.svh"

program ff_tb(ff_ifc.bench ds);
  transaction t;
  testing_env v;
  bit result;
  bit pass;

  initial begin
    t = new();
    v = new();
    v.read_config("config.txt");
    pass = 1;

    /* flush hardware */
    repeat(2) begin
      ds.reset = 1'b1;
      @(posedge ds.clk);
    end
    /* end flush */

    /* begin testing */
    repeat(v.iter) begin
      int _ = v.randomize();

      ds.reset = 1'b0;
      ds.valid_i = 1'b1;
      ds.data_i = v.a % 100;
      t.set_inputs(0, v.a % 100);

      @(posedge ds.clk);

      t.clock();
      result = t.check_output(ds.data_o);
      $display("[%0t]\texpected[%0d] == actual[%0d]\t%s", $realtime, t.data_out, ds.data_o, result ? "PASS": "FAIL");
      pass = pass & result;
    end
    /* end testing */

    assert (pass == 1) else $fatal(1, "Test failed");
    $finish;
  end
endprogram
