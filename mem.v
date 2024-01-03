`include "def.h"

module mem (
 input [`ADDR_W-1:0] a,
 output [`DATA_W-1:0] rd);

    integer file,num;
	reg [`DATA_W-1:0] mem[0:`DEPTH-1];

	assign rd = mem[a];

	initial begin
        file = $fopen("waka_normal.bmp","rb");
        num = $fread(mem, file);
    end

endmodule
