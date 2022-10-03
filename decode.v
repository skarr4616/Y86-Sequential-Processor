module decode(
    input clk, cnd,
    input [3:0] icode,
    input [3:0] rA, rB,
    input [63:0] valE, valM,
    output reg[63:0] valA, valB
);

    reg [63:0] reg_array[0:15];
    integer i;

    initial begin
        for (i = 0; i < 16; i = i+1) begin
          reg_array[i] <= 0; 
        end

        $dumpfile("dump.vcd");
        $dumpvars(0, reg_array[0], reg_array[1], reg_array[2], reg_array[3], reg_array[4], reg_array[5], reg_array[6], reg_array[7], reg_array[8], reg_array[9], reg_array[10], reg_array[11], reg_array[12], reg_array[13], reg_array[14], reg_array[15]);
    end

    always @(posedge clk) begin
        
        if (icode == 2 && cnd == 1) begin
            reg_array[rB] <= valE;
        end
        else if (icode == 3) begin
            reg_array[rB] <= valE;
        end
        else if (icode == 5) begin
            reg_array[rA] <= valM;
        end
        else if (icode == 6) begin
            reg_array[rB] <= valE;
        end
        else if (icode == 8) begin
            reg_array[4] <= valE;
        end
        else if (icode == 9) begin
            reg_array[4] <= valE;
        end
        else if (icode == 10) begin
            reg_array[4] <= valE;
        end
        else if (icode == 11) begin
            reg_array[4] <= valE;
            reg_array[rA] <= valM;
        end
    end

    always @(*) begin

        if (icode == 2) begin
            valA <= reg_array[rA];
        end
        else if (icode == 4) begin
            valA <= reg_array[rA];
            valB <= reg_array[rB];
        end
        else if (icode == 5) begin
            valB <= reg_array[rB];
        end
        else if (icode == 6) begin
            valA <= reg_array[rA];
            valB <= reg_array[rB];
        end
        else if (icode == 8) begin
            valB <= reg_array[4];
        end
        else if (icode == 9) begin
            valA <= reg_array[4];
            valB <= reg_array[4];
        end
        else if (icode == 10) begin
            valA <= reg_array[rA];
            valB <= reg_array[4];
        end
        else if (icode == 11) begin
            valA <= reg_array[4];
            valB <= reg_array[4];
        end
    end

endmodule