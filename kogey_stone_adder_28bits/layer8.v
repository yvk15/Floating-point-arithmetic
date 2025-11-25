// layer8.v (28-bit Kogge–Stone) – prefix span = 8
module layer8(
    input  [27:0] G,           // G[0..27]
    input  [27:8] P,           // P[8..27]
    input         CIN,

    output [27:0] OUTG8,
    output [27:16] OUTP8,      // propagate needed for layer16
    output        CIN8
);

    // Pass CIN forward
    buffer bcin(.A(CIN), .Y(CIN8));

    //----------------------------------------------------
    // Bits 0–7: no prefix possible → forward G
    //----------------------------------------------------
    genvar k;
    generate
        for (k = 0; k < 8; k = k + 1) begin : g_low
            buffer b(.A(G[k]), .Y(OUTG8[k]));
        end
    endgenerate

    //----------------------------------------------------
    // Bit 8: prefix with CIN
    //----------------------------------------------------
    gray_cell gc8(
        .G21(G[8]),
        .P21(P[8]),
        .G10(CIN),
        .G20(OUTG8[8])
    );

    //----------------------------------------------------
    // Bits 9–23: prefix with G[i-8]
    //----------------------------------------------------
    genvar j;
    generate
        for (j = 9; j <= 23; j = j + 1) begin : gray_high
            gray_cell gc(
                .G21(G[j]),
                .P21(P[j]),
                .G10(G[j-8]),
                .G20(OUTG8[j])
            );
        end
    endgenerate

    //----------------------------------------------------
    // Bits 24–27: cannot prefix by 8 → forward G
    //----------------------------------------------------
    genvar t;
    generate
        for (t = 24; t < 28; t = t + 1) begin : g_forward
            buffer bf(.A(G[t]), .Y(OUTG8[t]));
        end
    endgenerate

    //----------------------------------------------------
    // Propagate outputs for next stage (layer16):
    // We must output P[16..27]
    //----------------------------------------------------
    genvar m;
    generate
        for (m = 16; m < 28; m = m + 1) begin : p_out
            buffer pb(.A(P[m]), .Y(OUTP8[m]));
        end
    endgenerate

endmodule
