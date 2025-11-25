module buffer(A, Y);
    input A;
    output Y;
    wire T;

    assign T = ~A;
    assign Y = ~T;
endmodule