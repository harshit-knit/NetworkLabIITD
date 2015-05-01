set terminal png     
set output  "throughput.png"
set title "Throughput "
set xlabel "Time (in sec)"
set ylabel "Throughput (in Kb/sec)"
plot    "arq.dat" using 1:2  
    

