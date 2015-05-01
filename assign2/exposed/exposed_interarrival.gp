set terminal png    
set output  "exposed_interarrival.png"
set grid
set title "Interarrival at Receiver Nodes"
set xlabel "Time (in sec)"
set ylabel "Interarrival Time (in sec)"
plot  "exposedNode.dat" using 1:3  title "with Exposed Node" with lines ,\
	"exposedNodeRemoved.dat" using 1:3  title "without Exposed Node" with lines

