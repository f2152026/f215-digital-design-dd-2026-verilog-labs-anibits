module tb;

    reg  [1:0] t_a;
    reg  [1:0] t_b;

    wire t_gt;
    wire t_lt;
    wire t_eq;

    reg exp_gt;
    reg exp_lt;
    reg exp_eq;

    integer i;
    integer j;
    integer errors;
    integer total;

    // DUT instantiation
    comp2 U1 (
        .A  (t_a),
        .B  (t_b),
        .GT (t_gt),
        .LT (t_lt),
        .EQ (t_eq)
    );

    // Waveform dump
    string vcd_file;

    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) begin
            $dumpfile(vcd_file);
            $dumpvars(0, U1);
        end
    end

    initial begin

        errors = 0;
        total  = 0;

        // Test all 4 x 4 = 16 combinations
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin

                t_a = i;
                t_b = j;

                #5;

                // Compute expected outputs independently
                exp_gt = (t_a > t_b);
                exp_lt = (t_a < t_b);
                exp_eq = (t_a == t_b);

                total = total + 1;

                if ({t_gt, t_lt, t_eq} !==
                    {exp_gt, exp_lt, exp_eq}) begin

                    $display(
                        "FAIL at time %0t: A=%b B=%b got GT=%b LT=%b EQ=%b expected GT=%b LT=%b EQ=%b",
                        $time,
                        t_a, t_b,
                        t_gt, t_lt, t_eq,
                        exp_gt, exp_lt, exp_eq
                    );

                    errors = errors + 1;
                end
            end
        end

        $write("SUMMARY: ");
        $display("%0d passed out of %0d",
                 total - errors, total);

        $finish;
    end

    initial begin
        $monitor(
            $time,
            " A=%b B=%b | GT=%b LT=%b EQ=%b",
            t_a, t_b, t_gt, t_lt, t_eq
        );
    end

endmodule