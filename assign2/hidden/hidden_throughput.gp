set terminal png    
set output  "hidden_throughput.png"
set grid
set title "Throughput at Receiver Nodes"
set xlabel "Time (in sec)"
set ylabel "Throughput (in Kb/sec)"
plot    "hiddenNode.dat" using 1:2  title "with Hidden Node" with lines ,\
"hiddenNodeRemoved.dat" using 1:2  title "without Hidden Node" with lines



