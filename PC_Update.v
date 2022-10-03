module PC_Update(
    input [3:0] icode,
    input cnd,
    input [63:0] valC, valM, valP,
    output reg[63:0] pc_next
);

    always @(*) begin
        
        if (icode == 8) begin
            pc_next <= valC;
        end
        else if (icode == 7 && cnd == 1) begin
            pc_next <= valC;
        end
        else if (icode == 9) begin
            pc_next <= valM;
        end
        else begin
            pc_next <= valP;
        end
    end

endmodule