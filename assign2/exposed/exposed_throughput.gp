set terminal png    
set output  "exposed_throughput.png"
set grid
set title "Throughput at Receiver Nodes"
set xlabel "Time (in sec)"
set ylabel "Throughput (in Kb/sec)"
plot    "exposedNode.dat" using 1:2  title "with Exposed Node" with lines ,\
"exposedNodeRemoved.dat" using 1:2  title "without Exposed Node" with lines



