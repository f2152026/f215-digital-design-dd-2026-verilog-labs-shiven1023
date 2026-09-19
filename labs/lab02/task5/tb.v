
module tb;

    reg [3:0] t_a;
    reg [3:0] t_b;
    reg t_op;
    wire [3:0] t_result;
    reg [3:0] expected;
    integer i , j ,errors;
    alu DUT(
        .a(t_a),
        .b(t_b),
        .op(t_op),
        .result(t_result)
    );
    string vcd_file;

    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) begin
            $dumpfile(vcd_file);
            $dumpvars(0, DUT);
        end
    end

    initial begin
        errors = 0;

        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                t_a = i;
                t_b = j;

                // Test addition
                t_op = 0;
                expected = t_a + t_b;
                #1;

                if (t_result !== expected) begin
                    $display(
                        "ADD ERROR: a=%d b=%d | result=%d expected=%d",
                        t_a, t_b, t_result, expected
                    );
                    errors = errors + 1;
                end
                t_op = 1;
                expected = t_a - t_b;
                #1;

                if (t_result !== expected) begin
                    $display(
                        "SUB ERROR: a=%d b=%d | result=%d expected=%d",
                        t_a, t_b, t_result, expected
                    );
                    errors = errors + 1;
                end
            end
        end
        if (errors == 0)
            $display("PASS: All tests passed.");
        else
            $display("FAIL: %0d errors detected.", errors);

        $finish;
    end

endmodule


