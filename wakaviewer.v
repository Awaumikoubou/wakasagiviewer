// MAX height 254
// MAX 
`include "def.h"

module wakaviewer(
    input clk, rst_N
    );

    reg [7:0] counter; //0~255 for axis y (loading) and wave 
    reg [7:0] counter2; //0~255 for 

    wire [`PICTURE_H - 1: 0] waka; // EDIT > expand
    wire [`ADDR_W - 1: 0] addr;
    reg [`ADDR_W - 1: 0] addrbase;
    reg [`ADDR_W - 1: 0] addroffset;
    
    reg dot;

    assign addr = addrbase + addroffset; 
    wire [`DATA_W - 1: 0] readdata;

    mem mem0(.a(addr), .rd(readdata));

    generate
        genvar i;
        for (i=0; i<`PICTURE_H; i=i+1)
        begin: linesloop
            line #( .ID(i) ) line0 ( .clk(clk), .rst_N(rst_N), .data(readdata), .counter(counter), .picout(waka[i]));
        end
    endgenerate

    always @(posedge clk or negedge rst_N) begin
        if(!rst_N) begin
            counter <= 0;
            counter2 <= 0;
            addrbase <= `HEAD;
            addroffset <= 0;
            dot <= 0;
        end

        else begin
            counter <= counter + 1;
            addrbase <= addrbase + `PIC_W_BYTE;
            if (counter == 255) begin
                counter2 <= counter2 + 1;
                addroffset <= addroffset + 3;
                addrbase <= `HEAD;
                dot <= ~dot;
            end
        end
    end
endmodule

module line#(
    parameter ID = 0
)(
    input clk,
    input rst_N,
    input [7:0] data,
    input [7:0] counter,
    output reg picout
);
    reg [7:0] loadbuf;
    reg [7:0] picdata;
    reg [4:0] cngcnt;
    //------------------ボツ----------------
    // cngcnt / (counter + 1) * 256 < picdata
    // cngcnt << 8 < picdata * (counter + 1)

    //assign less = (cngcnt << 8) < picdata * (counter + 1);
    // だが乗算は使いたくない
    // ここでpicdataを16諧調に離散化?
    //--------------------------------------

    wire [7:0] shuffle;
    wire change;

    // counter = counter[0] counter[7:1]

    // 変化を1,変化なしを0とする。111110000000000000みたいな信号だと実装は楽。
    // counter < picdata の時だけ変化させればよい。ダサいけど。
    // そこで信号をシャッフルする。カウンタを
    assign shuffle = {counter[`SHUFFLENUM:0], counter[7:`SHUFFLENUM+1]};
    //assign shuffle = {counter[3], counter[7:4], counter[2:0]};
    // することでトランプのシャッフルと同等の効果が得られる
    assign change = shuffle < picdata;


    always @(posedge clk or negedge rst_N) begin
        if(!rst_N) begin
            loadbuf <= 0;
            picdata <= 0;
            picout <= 0;
        end
        else begin
            // load data to "picdata"
            if (counter == ID)
                loadbuf <= data;
            if (counter == 255) begin
                picdata <= loadbuf;
                picout <= 0;
                cngcnt <= 0;
            end
            //
            //if (change)
            //    picout = ~picout;
            if (change) begin
                if (cngcnt >= `THIN) begin
                    picout <= ~picout;
                    cngcnt <= 0;
                end
                else
                    cngcnt <= cngcnt + 1;
            end
        end

    end
endmodule