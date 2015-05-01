set terminal png    
set output  "csma_interarrival.png"
set grid
set title "Interarrival at Receiver Nodes"
set xlabel "Time (in sec)"
set ylabel "Interarrival Time (in sec)"
plot  "csmaRTS.dat" using 1:3  title "CSMA/CA with RTS/CTS" with lines ,\
	"csma.dat" using 1:3  title "CSMA/CA without RTS/CTS" with lines

