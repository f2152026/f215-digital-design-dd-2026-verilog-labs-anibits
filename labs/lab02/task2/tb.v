module tb;

    reg  [2:0] t_sel;
    wire [7:0] t_dout;

    // Parameter override
    lut #(
        .WIDTH(8),
        .DEPTH(8)
    ) U1 (
        .sel  (t_sel),
        .dout (t_dout)
    );

    // Waveform dump configuration
    string vcd_file;

    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) begin
            $dumpfile(vcd_file);
            $dumpvars(0, U1);
        end
    end

    integer i;

    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            t_sel = i;
            #5;

            if (t_dout !== i * i)
                $display("ERROR: sel=%d expected=%d got=%d",
                         i, i*i, t_dout);
            else
                $display("PASS: sel=%d dout=%d",
                         i, t_dout);
        end

        $finish;
    end

    initial begin
        $monitor($time, " sel=%d | dout=%d", t_sel, t_dout);
    end

endmodule