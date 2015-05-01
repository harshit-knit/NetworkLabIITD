set terminal png     
set output  "throughput.png"
set title "Throughput of Server"
set xlabel "Time (in sec)"
set ylabel "Throughput (in Kb/sec)"
plot    "parameter.dat" using 1:2  title "Central Server" with lines
    

