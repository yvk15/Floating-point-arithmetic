module black_cell(G21, P21, G10, P10, G20, P20);
    input G21, P21, G10, P10;
    output G20, P20;
    wire T;

    assign T = P21 & G10;
    assign G20 = T | G21;
    assign P20 = P21 & P10;
endmodule