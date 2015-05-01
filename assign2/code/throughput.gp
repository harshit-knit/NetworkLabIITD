set terminal png    
set output  "throughput.png"
set grid
set title "Throughput at Receiver Nodes"
set xlabel "Time (in sec)"
set ylabel "Throughput (in Kb/sec)"
plot    "aodv.dat" using 1:2  title "Static ADOV" with lines ,\
		"dsdv.dat" using 1:2  title "Static DSDV" with lines,\
    "aodv_dy.dat" using 1:2  title "Dynamic AODV" with lines,\
    "dsdv_dy.dat" using 1:2  title "Dynamic DSDV" with lines



