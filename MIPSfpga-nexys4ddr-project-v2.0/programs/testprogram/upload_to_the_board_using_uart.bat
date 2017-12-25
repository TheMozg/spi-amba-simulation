set COMPORT=12
set TARGET=FPGA_Ram

mode com%COMPORT% baud=115200 parity=n data=8 stop=1 to=off xon=off odsr=off octs=off dtr=off rts=off idsr=off
type %TARGET%.rec >\\.\COM%COMPORT%
