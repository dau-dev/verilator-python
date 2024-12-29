`timescale 1ns/1ns

class testing_env;
    rand int unsigned rn;
    rand bit [31:0] a;

    int reset_prob;
    int iter;

  function new ();
    rn = 'b0;
    a = 'b0;
    reset_prob = 'b0;
    iter = 'b0;
  endfunction

  function void read_config(string filename);
    int file;
    int value;
    string param;

    file = $fopen(filename, "r");

    while(!$feof(file)) begin
        $fscanf(file, "%s %d", param, value);
        if("ITERATIONS" == param) begin
            iter = value;
        end else if("RESET_PROB" == param) begin
            reset_prob = value;
        end
    end
  endfunction

  function get_reset();
    return ((rn%100)<reset_prob);
  endfunction
endclass

