`timescale 1ns/1ps

module ks24_TB;

    reg CLK, RST_N;
    reg [27:0] A, B;
    reg CIN;

    wire [27:0] SUM;
    wire        COUT;

    // DUT
    ks24 dut (
        .A(A),
        .B(B),
        .CIN(CIN),
        .CLK(CLK),
        .RST_N(RST_N),
        .SUM(SUM),
        .COUT(COUT)
    );

    // Clock – 10ns period
    always #5 CLK = ~CLK;

    // Apply vector safely on posedge clock
    task apply_vec(input [27:0] a_in,
                   input [27:0] b_in,
                   input        cin_in);
    begin
        @(posedge CLK);
        A   <= a_in;
        B   <= b_in;
        CIN <= cin_in;
    end
    endtask

    initial begin

        $dumpfile("ks28_waveforms.vcd");
        $dumpvars(0, ks24_TB);

        // Initialize
        CLK   = 0;
        RST_N = 0;
        A     = 0;
        B     = 0;
        CIN   = 0;

        // Apply reset for 2 cycles
        @(posedge CLK);
        @(posedge CLK);
        RST_N = 1;

        // Wait one more cycle
        @(posedge CLK);

        // --------------------------
        // TEST CASES
        // --------------------------

        // Test 1
        apply_vec(28'h000001, 28'h000001, 1'b1);

        // Test 2: overflow
        apply_vec(28'h0FFFFFF, 28'h0FFFFFF, 1'b1);

        // Test 3
        apply_vec(28'h1234567, 28'h7654321, 1'b0);

        // Test 4 boundary
        apply_vec(28'h8000000, 28'h7FFFFFF, 1'b0);

        // Test 5: random
        repeat(20) begin
            apply_vec($random, $random, $random);
        end

        // Pipeline flush
        repeat (5) @(posedge CLK);

        $finish;
    end

    initial begin
        $display("TIME\t\tA\t\tB\t\tCIN\tSUM\tCOUT");
        $monitor("%0t\t%h\t%h\t%b\t%h\t%b",
                 $time, A, B, CIN, SUM, COUT);
    end

endmodule
