module layer16(
    input  [27:0] G,          // full G range 0..27
    input  [27:16] P,         // propagate bits 16..27
    input         CIN,

    output        CIN16,
    output [27:0] OUTG16,
    output [27:16] OUTP16
);

    // Forward CIN
    buffer b1(.A(CIN), .Y(CIN16));

    //----------------------------------------------------
    // Bits 0–15: no prefix possible (j-16 < 0)
    //----------------------------------------------------
    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin : g_low
            buffer gbuf(.A(G[k]), .Y(OUTG16[k]));
        end
    endgenerate

    //----------------------------------------------------
    // Bit 16: prefix with CIN only
    //----------------------------------------------------
    gray_cell gc16(
        .G21(G[16]),
        .P21(P[16]),
        .G10(CIN),
        .G20(OUTG16[16])
    );

    //----------------------------------------------------
    // Bits 17–27: prefix distance = 16
    //----------------------------------------------------
    genvar j;
    generate
        for (j = 17; j < 28; j = j + 1) begin : g_high
            gray_cell inst(
                .G21(G[j]),
                .P21(P[j]),
                .G10(G[j-16]),  // previous prefix
                .G20(OUTG16[j])
            );
        end
    endgenerate

    //----------------------------------------------------
    // Propagate for bits 16..27
    //----------------------------------------------------
    genvar m;
    generate
        for (m = 16; m < 28; m = m + 1) begin : p_out
            buffer pbuf(.A(P[m]), .Y(OUTP16[m]));
        end
    endgenerate

endmodule
