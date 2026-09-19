// tb.v

module tb;

    // Inputs to DUT are changed by the testbench,
    // so they are declared as reg.
    reg t_i0, t_i1, t_s;

    // DUT drives the output, so testbench sees it as a wire.
    wire t_y;

    // Instantiate DUT
    DUT UUT (
        .I0 (t_i0),
        .I1 (t_i1),
        .S  (t_s),
        .Y  (t_y)
    );

    // Waveform dump configuration
    string vcd_file;

    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) begin
            $dumpfile(vcd_file);
            $dumpvars(0, tb);
        end
    end

    initial begin

        // I0 I1 S
        t_i0 = 0; t_i1 = 0; t_s = 0;
        #5;

        t_i0 = 0; t_i1 = 0; t_s = 1;
        #5;

        t_i0 = 0; t_i1 = 1; t_s = 0;
        #5;

        t_i0 = 0; t_i1 = 1; t_s = 1;
        #5;

        t_i0 = 1; t_i1 = 0; t_s = 0;
        #5;

        t_i0 = 1; t_i1 = 0; t_s = 1;
        #5;

        t_i0 = 1; t_i1 = 1; t_s = 0;
        #5;

        t_i0 = 1; t_i1 = 1; t_s = 1;
        #5;

        $finish;
    end

    initial
        $monitor($time,
                 " I0=%b I1=%b S=%b | Y=%b",
                 t_i0, t_i1, t_s, t_y);

endmodule