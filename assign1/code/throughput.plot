set terminal png     
set output  "throughput.png"
set title "Throughput of Bottleneck Nodes"
set xlabel "Time (in sec)"
set ylabel "Throughput (in Kb/sec)"
plot    "parameters1.dat" using 1:2  title "500 & 500Kbps" with linespoints,\
    "parameters2.dat" using 1:2  title "100 & 1000Kbps" with linespoints,\
    "parameters3.dat" using 1:2  title "10 & 2000Kbps" with linespoints,\
    "parameters4.dat" using 1:2  title "400 & 100Kbps" with linespoints

