# wakasagiviewer
わかさぎちゃんをGTKwaveで表示するだけ

# how to use
iverilog .\wakaviewertest.v .\wakaviewer.v .\mem.v  
vvp .\a.out   
gtkwave .\wakaviewer.vcd  
