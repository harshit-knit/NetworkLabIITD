set terminal png     
set output  "interarrival.png"
set title "InterArrival Time of Server"
set xlabel "Time (in sec)"
set ylabel "InterArrival Time(in sec)"
plot    "parameter.dat" using 1:3  title "Central Server" with lines
    
