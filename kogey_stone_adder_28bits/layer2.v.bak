module layer2(P, G, CIN, OUTP2, OUTG2, CIN2);
    input [15:0] G;
    input [15:1] P;
    input CIN;
    output CIN2; 
    output [15:3] OUTP2;
    output [15:0] OUTG2;

    buffer b1(
        .A(CIN),
        .Y(CIN2)
    );

    buffer b2(
        .A(G[0]),
        .Y(OUTG2[0])
    );

    gray_cell inst1(
        .G21(G[1]),
        .P21(P[1]),
        .G10(CIN),
        .G20(OUTG2[1])
    );

    gray_cell inst(
        .G21(G[2]),
        .P21(P[2]),
        .G10(G[0]),
        .G20(OUTG2[2])
    );

    genvar i; 
    generate  
        for(i=3;i<16;i=i+1) begin : black_cell_loop
            black_cell inst(
                .G21(G[i]),
                .P21(P[i]),
                .G10(G[i-2]),
                .P10(P[i-2]),
                .G20(OUTG2[i]),
                .P20(OUTP2[i])
            );
        end
    endgenerate

endmodule