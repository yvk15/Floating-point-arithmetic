// First layer of a 24-bit Kogge-Stone adder
// Generate P (propagate) and G (generate) bits for each bit

module layer_pg(A, B, P_OUT, G_OUT);
    input [27:0] A, B;
    output [27:0] P_OUT, G_OUT;
    
    genvar i; 
    generate  
        for(i = 0; i < 28; i = i + 1) begin : pg_gen
            pg_gen inst(
                .A(A[i]),
                .B(B[i]),
                .P(P_OUT[i]),
                .G(G_OUT[i])
            );
        end
    endgenerate
endmodule
