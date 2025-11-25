module layer1(P, G, CIN, OUTP1, OUTG1, CIN1);
    input [27:0] P, G;
    input CIN;
    output CIN1;
    output [27:1] OUTP1;
    output [27:0] OUTG1;

    buffer b1(
        .A(CIN),
        .Y(CIN1)
    );

    gray_cell gc1(
        .G21(G[0]),
        .P21(P[0]),
        .G10(CIN),
        .G20(OUTG1[0])      
    );

    genvar i; 
    generate  
        for(i = 1; i < 28; i = i + 1) begin : black_cell_loop
            black_cell inst(
                .G21(G[i]),
                .P21(P[i]),
                .G10(G[i-1]),
                .P10(P[i-1]),
                .G20(OUTG1[i]),
                .P20(OUTP1[i])
            );
        end
    endgenerate
endmodule
