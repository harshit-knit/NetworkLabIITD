set terminal png    
set output  "interarrival.png"
set grid
set title "Interarrival at Receiver Nodes"
set xlabel "Time (in sec)"
set ylabel "Interarrival Time (in sec)"
plot [0:150][-1:5]  "aodv.dat" using 1:3  title "Static ADOV" with lines ,\
		"dsdv.dat" using 1:3  title "Static DSDV" with lines,\
    "aodv_dy.dat" using 1:3  title "Dynamic AODV" with lines,\
    "dsdv_dy.dat" using 1:3  title "Dynamic DSDV" with lines



