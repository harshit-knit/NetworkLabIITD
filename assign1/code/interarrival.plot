set terminal png     
set output  "interarrival.png"
set title "InterArrival Time of Bottleneck Nodes"
set xlabel "Time (in sec)"
set ylabel "InterArrival Time(in sec)"
plot    "parameters1.dat" using 1:3  title "500 & 500Kbps" with linespoints,\
    "parameters2.dat" using 1:3  title "100 & 1000Kbps" with linespoints,\
    "parameters3.dat" using 1:3  title "10 & 2000Kbps" with linespoints,\
    "parameters4.dat" using 1:3  title "400 & 100Kbps" with linespoints
