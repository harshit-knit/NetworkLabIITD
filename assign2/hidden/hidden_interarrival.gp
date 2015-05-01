set terminal png    
set output  "hidden_interarrival.png"
set grid
set title "Interarrival at Receiver Nodes"
set xlabel "Time (in sec)"
set ylabel "Interarrival Time (in sec)"
plot  "hiddenNode.dat" using 1:3  title "with Hidden Node" with lines ,\
	"hiddenNodeRemoved.dat" using 1:3  title "without Hidden Node" with lines

