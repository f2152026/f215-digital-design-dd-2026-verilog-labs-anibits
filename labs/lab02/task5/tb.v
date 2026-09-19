// tb.v

module tb;

    reg  [3:0] t_a;
    reg  [3:0] t_b;
    reg        t_op;

    wire [3:0] t_result;

    integer errors;
    integer total;

    reg [3:0] expected;

    alu U1 (
        .a      (t_a),
        .b      (t_b),
        .op     (t_op),
        .result (t_result)
    );

    // Waveform dump
    string vcd_file;

    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) begin
            $dumpfile(vcd_file);
            $dumpvars(0, tb);
        end
    end

    initial begin

        errors = 0;
        total  = 0;

        // ---------------------------------
        // Test 1: addition
        // ---------------------------------
        t_a  = 4'd7;
        t_b  = 4'd3;
        t_op = 1'b0;

        #5;

        expected = t_a + t_b;
        total = total + 1;

        if (t_result !== expected) begin
            $display("FAIL: a=%d b=%d op=%b got=%d expected=%d",
                     t_a, t_b, t_op, t_result, expected);
            errors = errors + 1;
        end


        // ---------------------------------
        // Test 2:
        // SAME operands, change ONLY op
        // Exposes sensitivity-list bug
        // ---------------------------------
        t_op = 1'b1;

        #5;

        expected = t_a - t_b;
        total = total + 1;

        if (t_result !== expected) begin
            $display("FAIL: a=%d b=%d op=%b got=%d expected=%d",
                     t_a, t_b, t_op, t_result, expected);
            errors = errors + 1;
        end


        // ---------------------------------
        // More subtraction tests
        // ---------------------------------

        t_a = 4'd12;
        t_b = 4'd5;
        t_op = 1'b1;

        #5;

        expected = t_a - t_b;
        total = total + 1;

        if (t_result !== expected) begin
            $display("FAIL: a=%d b=%d op=%b got=%d expected=%d",
                     t_a, t_b, t_op, t_result, expected);
            errors = errors + 1;
        end


        t_a = 4'd9;
        t_b = 4'd2;
        t_op = 1'b1;

        #5;

        expected = t_a - t_b;
        total = total + 1;

        if (t_result !== expected) begin
            $display("FAIL: a=%d b=%d op=%b got=%d expected=%d",
                     t_a, t_b, t_op, t_result, expected);
            errors = errors + 1;
        end


        // ---------------------------------
        // Operand-changing addition
        // ---------------------------------
        t_a = 4'd4;
        t_b = 4'd6;
        t_op = 1'b0;

        #5;

        expected = t_a + t_b;
        total = total + 1;

        if (t_result !== expected) begin
            $display("FAIL: a=%d b=%d op=%b got=%d expected=%d",
                     t_a, t_b, t_op, t_result, expected);
            errors = errors + 1;
        end


        $display("--------------------------------");
        $display("%0d passed out of %0d",
                 total - errors, total);

        $finish;
    end

    initial begin
        $monitor($time,
                 " a=%d b=%d op=%b | result=%d",
                 t_a, t_b, t_op, t_result);
    end

endmodule