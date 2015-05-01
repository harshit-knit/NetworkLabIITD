set terminal png     
set output  "link_throughput.png"
set title "Throughput of Bottleneck Links"
set xlabel "Time (in sec)"
set ylabel "Throughput (in Kb/sec)"
plot    "link1_parameters.dat" using 1:2  title "100Kbps B1-B3" with linespoints,\
    "link2_parameters.dat" using 1:2  title "1000Kbps B2-B3" with linespoints,\
"parameters2.dat" using 1:2  title "Overall system" with linespoints

