module memory(
    input clk,
    input [3:0] icode,
    input [63:0] valA, valE, valP,
    input imem_error, instr_valid,
    output reg[63:0] valM,
    output reg AOK_stat, HLT_stat, ADR_stat, INS_stat
);

    reg [63:0] Data_Mem[0:4095];
    reg [63:0] Mem_addr = 0;
    reg [63:0] Mem_data;
    reg Mem_read = 0, Mem_write = 0;
    reg dmem_error;
    integer i;

    initial begin
        for (i = 0; i < 4096; i = i+1) begin
            Data_Mem[i] <= 0;
        end

        $dumpvars(0, Data_Mem[0], Data_Mem[1], Data_Mem[2], Data_Mem[3], Data_Mem[4], Data_Mem[5], Data_Mem[6], Data_Mem[7], Data_Mem[8]);
    end

    always @(*) begin
        
        if (icode == 4) begin
            Mem_addr <= valE;
            Mem_data <= valA;
            Mem_write <= 1;
            Mem_read <= 0;
        end
        else if (icode == 5) begin
            Mem_addr <= valE;
            Mem_write <= 0;
            Mem_read <= 1;
        end
        else if (icode == 8) begin
            Mem_addr <= valE;
            Mem_data <= valP;
            Mem_write <= 1;
            Mem_read <= 0;
        end
        else if (icode == 9) begin
            Mem_addr <= valA;
            Mem_write <= 0;
            Mem_read <= 1;
        end
        else if (icode == 10) begin
            Mem_addr <= valE;
            Mem_data <= valA;
            Mem_write <= 1;
            Mem_read <= 0;
        end
        else if (icode == 11) begin
            Mem_addr <= valA;
            Mem_write <= 0;
            Mem_read <= 1;
        end

        if (Mem_addr >= 0 && Mem_addr < 4096) begin
            dmem_error <= 0;
        end
        else begin
            dmem_error <= 1;
        end
    end

    always @(*) begin
        
        HLT_stat <= (icode == 1) ? 1:0;
        ADR_stat <= imem_error || dmem_error;
        INS_stat <= ~instr_valid;
        AOK_stat <= ~(HLT_stat || ADR_stat || INS_stat);
    end



    always @(*) begin

        if (Mem_read == 1) begin

            valM <= Data_Mem[Mem_addr];
        end
        else begin
            valM <= 0;
        end
    end

    always @(posedge clk) begin

        Data_Mem[Mem_addr] <= Mem_data;
    end
endmodule