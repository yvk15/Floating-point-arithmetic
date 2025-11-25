`timescale 1ns/1ps

module ks24(
    input  [27:0] A,
    input  [27:0] B,
    input  CIN,
    input  CLK,
    input  RST_N,
    output [27:0] SUM,     // 28-bit SUM only
    output        COUT     // separate final carry
);

    //-----------------------------------------
    // Pipeline registers
    //-----------------------------------------
    reg  [56:0] INPUT_REG;     // A(28) + B(28) + CIN(1) = 57 bits
    reg  [28:0] OUTPUT_REG;    // SUM(28) + COUT(1) = 29 bits
    wire [28:0] OUT_WIRE;

    //-----------------------------------------
    // Prefix wires
    //-----------------------------------------
    wire [27:0] T0P, T0G;
    wire [27:1] T1P;
    wire [27:0] T1G;
    wire [27:3] T2P;
    wire [27:0] T2G;
    wire [27:7] T3P;
    wire [27:0] T3G;
    wire [27:16] T4P;
    wire [27:0] T4G;
    wire [27:0] C;    // final carries from layer16

    wire C1, C2, C4, C8, C16;

    //-----------------------------------------
    // PIPELINE INPUT
    //-----------------------------------------
    always @(posedge CLK or negedge RST_N) begin
        if (!RST_N) begin
            INPUT_REG  <= 57'd0;
            OUTPUT_REG <= 29'd0;
        end
        else begin
            INPUT_REG  <= {A, B, CIN};
            OUTPUT_REG <= OUT_WIRE;
        end
    end

    //-----------------------------------------
    // LAYER 0 – PG generator
    //-----------------------------------------
    layer_pg u_pg (
        .A(INPUT_REG[56:29]),   // A[27:0]
        .B(INPUT_REG[28:1]),    // B[27:0]
        .P_OUT(T0P),
        .G_OUT(T0G)
    );

    //-----------------------------------------
    // LAYER 1 (span = 1)
    //-----------------------------------------
    layer1 u_l1 (
        .P(T0P),
        .G(T0G),
        .CIN(INPUT_REG[0]),
        .OUTP1(T1P),
        .OUTG1(T1G),
        .CIN1(C1)
    );

    //-----------------------------------------
    // LAYER 2 (span = 2)
    //-----------------------------------------
    layer2 u_l2 (
        .P(T1P),
        .G(T1G),
        .CIN(C1),
        .OUTP2(T2P),
        .OUTG2(T2G),
        .CIN2(C2)
    );

    //-----------------------------------------
    // LAYER 4 (span = 4)
    //-----------------------------------------
    layer4 u_l4 (
        .P(T2P),
        .G(T2G),
        .CIN(C2),
        .OUTP4(T3P),
        .OUTG4(T3G),
        .CIN4(C4)
    );

    //-----------------------------------------
    // LAYER 8 (span = 8)
    //-----------------------------------------
    layer8 u_l8 (
        .P(T3P),
        .G(T3G),
        .CIN(C4),
        .OUTG8(T4G),
        .OUTP8(T4P),
        .CIN8(C8)
    );

    //-----------------------------------------
    // LAYER 16 (span = 16)
    //-----------------------------------------
    layer16 u_l16 (
        .P(T4P),       // P[27:16]
        .G(T4G),       // G[27:0]
        .CIN(C8),
        .OUTG16(C),
        .OUTP16(),     // propagate not needed at top
        .CIN16(C16)
    );

    //-----------------------------------------
    // SUM LAYER
    //-----------------------------------------
    sum_layer u_sum (
        .P(T0P),
        .C(C),
        .P23(T4P[27]),         // highest propagate bit
        .CIN(INPUT_REG[0]),
        .SUM(OUT_WIRE[27:0]),
        .COUT(OUT_WIRE[28])
    );

    //-----------------------------------------
    // OUTPUTS
    //-----------------------------------------
    assign SUM  = OUTPUT_REG[27:0];
    assign COUT = OUTPUT_REG[28];

endmodule
