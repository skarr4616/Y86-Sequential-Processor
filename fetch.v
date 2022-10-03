module fetch(
    input [63:0] pc_current,
    output reg[3:0] icode, ifun,
    output reg[3:0] rA, rB,
    output reg[63:0] valC,
    output reg[63:0] valP,
    output reg instr_valid, 
    output reg imem_error
);

    reg [7:0] inst_mem[0:4095];
    reg Need_valC;
    reg Need_regids;

    initial begin
        $readmemb("inst_mem.txt", inst_mem);
    end

    always @(*) begin

        if (pc_current >= 0 && pc_current < 4096) begin 
            icode <= inst_mem[pc_current][7:4];
            ifun <= inst_mem[pc_current][3:0];
            imem_error <= 0;
        end
        else begin
            icode <= 1;
            ifun <= 0;
            imem_error <= 1;
        end
    end

    always @(*) begin

        if (icode >= 0 && icode <= 11) begin
            instr_valid <= 1;
        end
        else begin
            instr_valid <= 0;
        end
    end

    always @(*) begin

        if (icode == 2 || icode == 6 || icode == 10 || icode == 11) begin

            rA <= inst_mem[pc_current + 1][7:4];
            rB <= inst_mem[pc_current + 1][3:0];
            valC <= 0;
            valP <= pc_current + 2;
        end
        else if (icode == 3 || icode == 4 || icode == 5) begin
            rA <= inst_mem[pc_current + 1][7:4];
            rB <= inst_mem[pc_current + 1][3:0];
            valC[7:0] <= inst_mem[pc_current + 2];
            valC[15:8] <= inst_mem[pc_current + 3];
            valC[23:16] <= inst_mem[pc_current + 4];
            valC[31:24] <= inst_mem[pc_current + 5];
            valC[39:32] <= inst_mem[pc_current + 6];
            valC[47:40] <= inst_mem[pc_current + 7];
            valC[55:48] <= inst_mem[pc_current + 8];
            valC[63:56] <= inst_mem[pc_current + 9];
            valP <= pc_current + 10;
        end
        else if (icode == 7 || icode == 8) begin
            rA <= 15;
            rB <= 15;
            valC[7:0] <= inst_mem[pc_current + 1];
            valC[15:8] <= inst_mem[pc_current + 2];
            valC[23:16] <= inst_mem[pc_current + 3];
            valC[31:24] <= inst_mem[pc_current + 4];
            valC[39:32] <= inst_mem[pc_current + 5];
            valC[47:40] <= inst_mem[pc_current + 6];
            valC[55:48] <= inst_mem[pc_current + 7];
            valC[63:56] <= inst_mem[pc_current + 8];
            valP <= pc_current + 9;
        end
        else begin
            rA <= 15;  
            rB <= 15; 
            valC <= 0;
            valP <= pc_current + 1;
        end
    end


    

endmodule