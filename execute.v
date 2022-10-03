`include "ALU.v"

module execute(
    input clk,
    input [3:0] icode, ifun,
    input [63:0] valA, valB, valC,
    output reg cnd,
    output [63:0] valE
);

    reg Z, S, Ov;
    reg [63:0] aluA, aluB;
    wire [3:0] alu_fun;

    always @(*) begin
        
        if (icode == 2) begin
            aluA <= valA;
            aluB <= 0;
        end
        else if (icode == 3) begin
            aluA <= valC;
            aluB <= 0;
        end
        else if (icode == 4) begin
            aluA <= valC;
            aluB <= valB;
        end
        else if (icode == 5) begin
            aluA <= valC;
            aluB <= valB;
        end
        else if (icode == 6) begin
            aluA <= valB;
            aluB <= valA;
        end
        else if (icode == 8) begin
            aluA <= -8;
            aluB <= valB;
        end
        else if (icode == 9) begin
            aluA <= 8;
            aluB <= valB;
        end
        else if (icode == 10) begin
            aluA <= -8;
            aluB <= valB;
        end
        else if (icode == 11) begin
            aluA <= 8;
            aluB <= valB;
        end
    end

    assign alu_fun = (icode == 6) ? ifun : 0;
    
    ALU OPq(.A(aluA), .B(aluB), .s(alu_fun), .Out(valE));

    always @(posedge clk) begin
        if (icode == 6) begin
            Z <= (valE == 0) ? 1 : 0;
            S <= (valE[63] == 1) ? 1 : 0;

            if (alu_fun == 0) begin
                Ov <= ((aluA[63] == 1 && valB[63] == 1 && valE[63] == 0) || (aluA[63] == 0 && valB[63] == 0 && valE[63] == 1)) ? 1 : 0;
            end
            else if (alu_fun == 1) begin
                Ov <= ((aluA[63] == 1 && valB[63] == 0 && valE[63] == 0) || (aluA[63] == 0 && valB[63] == 1 && valE[63] == 1)) ? 1 : 0;
            end
            else begin
                Ov <= 0;
            end
        end
    end

    always @(*) begin
        if (ifun == 0) begin
            cnd <= 1;
        end
        else if (ifun == 1) begin
            cnd <= (S ^ Ov) | Z;
        end
        else if (ifun == 2) begin
            cnd <= (S ^ Ov);
        end
        else if (ifun == 3) begin
            cnd <= Z;
        end
        else if (ifun == 4) begin
            cnd <= ~Z;
        end
        else if (ifun == 5) begin
            cnd <= ~(S ^ Ov);
        end
        else if (ifun == 6) begin
            cnd <= ~(S ^ Ov) & ~Z;
        end
        else begin
            cnd <= 1;
        end
    end
    
endmodule