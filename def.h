`define ENABLE 1'b1
`define DISABLE 1'b0
`define ENABLE_N 1'b0
`define DISABLE_N 1'b1

`define PICTURE_H 80
`define PICTURE_W 64

`define PIC_W_BYTE `PICTURE_W*3

`define DATA_W 8
`define ADDR_W 16
`define DEPTH 65536

`define HEAD 16'h36
`define FILE_END 16'h3c36

`define SHUFFLENUM 0
`define THIN 20