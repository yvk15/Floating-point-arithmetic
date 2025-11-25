// Here we use the generate to loop through a 16 bits and 
// compute the corresponding P (propagation) & G (generate) bits
// This is the first layer of a Kogge-Stone adder

module layer_pg(A, B, P_OUT, G_OUT);
    input [15:0] A, B;
    output [15:0] P_OUT, G_OUT;
    
    genvar i; 
    generate  
        for(i=0;i<16;i=i+1) begin : pg_gen
            pg_gen inst(
                .A(A[i]),
                .B(B[i]),
                .P(P_OUT[i]),
                .G(G_OUT[i])
            );
        end
    endgenerate
endmodule


