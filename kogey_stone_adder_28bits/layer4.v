module layer4(P, G, CIN, OUTP4, OUTG4, CIN4);
    input [27:0] G;
    input [27:3] P;
    input CIN;
    output [27:7] OUTP4;
    output [27:0] OUTG4;
    output CIN4;

    buffer b1(
        .A(CIN),
        .Y(CIN4)
    );

    genvar k;
    generate
        for(k = 0; k < 3; k = k + 1) begin : buffer_loop
            buffer inst1(
                .A(G[k]),
                .Y(OUTG4[k])
            );
        end
    endgenerate

    gray_cell inst1(
        .G21(G[3]),
        .P21(P[3]),
        .G10(CIN),
        .G20(OUTG4[3])
    );

    genvar j;
    generate
        for(j = 4; j < 7; j = j + 1) begin : gray_cell_loop
            gray_cell inst(
                .G21(G[j]),
                .P21(P[j]),
                .G10(G[j-4]),
                .G20(OUTG4[j])
            );
        end
    endgenerate

    genvar i; 
    generate  
        for(i = 7; i < 28; i = i + 1) begin : black_cell_loop
            black_cell inst(
                .G21(G[i]),
                .P21(P[i]),
                .G10(G[i-4]),
                .P10(P[i-4]),
                .G20(OUTG4[i]),
                .P20(OUTP4[i])
            );
        end
    endgenerate

endmodule
