module sum_layer(
    input  [27:0] P,      // propagate bits from PG layer
    input  [27:0] C,      // carry prefixes from layer16
    input         CIN,    // original carry-in
    input         P23,    // propagate for the highest big-span stage
    output [27:0] SUM,    // final 28-bit sum
    output        COUT    // final carry out (bit 28)
);

    //-----------------------------------------
    // SUM BIT-0
    //-----------------------------------------
    assign SUM[0] = P[0] ^ CIN;

    //-----------------------------------------
    // SUM BITS 1–27
    //-----------------------------------------
    genvar i;
    generate
        for (i = 1; i < 28; i = i + 1) begin : sum_loop
            assign SUM[i] = P[i] ^ C[i-1];
        end
    endgenerate

    //-----------------------------------------
    // FINAL COUT using gray_cell
    // COUT = G + P*C_in
    // Here:
    //   G21  = C[23]   → comes from layer16
    //   P21  = P23     → propagate for block at MSB group
    //   G10  = CIN     → original input carry
    //-----------------------------------------
// final carry-out = C[27]
assign COUT = C[27];


endmodule
