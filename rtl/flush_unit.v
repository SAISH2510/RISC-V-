module flush_unit(

    input branch_taken,

    output reg ifid_flush,
    output reg idex_flush
);

always @(*)
begin

    if(branch_taken)
    begin

        ifid_flush = 1;
        idex_flush = 1;

    end

    else
    begin

        ifid_flush = 0;
        idex_flush = 0;

    end

end

endmodule