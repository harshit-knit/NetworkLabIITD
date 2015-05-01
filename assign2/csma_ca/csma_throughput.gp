set terminal png    
set output  "csma_throughput.png"
set grid
set title "Throughput at Receiver Nodes"
set xlabel "Time (in sec)"
set ylabel "Throughput (in Kb/sec)"
plot  "csmaRTS.dat" using 1:2 title "CSMA/CA with RTS/CTS"with lines ,\
	"csma.dat" using 1:2  title "CSMA/CA without RTS/CTS" with lines



