module gray_cell(G21, P21, G10, G20);
    input G21, P21, G10;
    output G20;
    wire T;

    assign T = P21 & G10;
    assign G20 = T | G21;
endmodule