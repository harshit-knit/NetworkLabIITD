set terminal png     
set output  "link_interarrival.png"
set title "Interarrival Time of Bottleneck Links"
set xlabel "Time (in sec)"
set ylabel "InterArrival Time (in sec)"
plot    "link1_parameters.dat" using 1:3  title "100Kbps B1-B3" with linespoints,\
    "link2_parameters.dat" using 1:3  title "1000Kbps B2-B3" with linespoints,\
"parameters2.dat" using 1:3  title "Overall system" with linespoints

