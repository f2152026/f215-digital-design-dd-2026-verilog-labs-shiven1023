module tb;

    reg [1:0] t_A;
    reg [1:0] t_B;

    wire t_GT;
    wire t_LT;
    wire t_EQ;

    integer i;
    integer j;
    integer errors;

    comp2 DUT (
        .A(t_A),
        .B(t_B),
        .GT(t_GT),
        .LT(t_LT),
        .EQ(t_EQ)
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

        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                t_A = i;
                t_B = j;

                #5;

                if (t_GT !== (t_A > t_B)) begin
                    $display(
                        "ERROR: A=%d B=%d | GT=%b, expected GT=%b",
                        t_A, t_B, t_GT, (t_A > t_B)
                    );
                    errors = errors + 1;
                end

                if (t_LT !== (t_A < t_B)) begin
                    $display(
                        "ERROR: A=%d B=%d | LT=%b, expected LT=%b",
                        t_A, t_B, t_LT, (t_A < t_B)
                    );
                    errors = errors + 1;
                end

                if (t_EQ !== (t_A == t_B)) begin
                    $display(
                        "ERROR: A=%d B=%d | EQ=%b, expected EQ=%b",
                        t_A, t_B, t_EQ, (t_A == t_B)
                    );
                    errors = errors + 1;
                end

                if (
                    ({t_GT, t_LT, t_EQ} !== 3'b100) &&
                    ({t_GT, t_LT, t_EQ} !== 3'b010) &&
                    ({t_GT, t_LT, t_EQ} !== 3'b001)
                ) begin
                    $display(
                        "ERROR: Outputs are not one-hot: A=%d B=%d | GT=%b LT=%b EQ=%b",
                        t_A, t_B, t_GT, t_LT, t_EQ
                    );
                    errors = errors + 1;
                end
            end
        end

        if (errors == 0)
            $display("PASS: All test cases passed.");
        else
            $display("FAIL: %0d errors detected.", errors);

        $finish;
    end

endmodule