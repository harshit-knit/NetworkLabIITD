set terminal png     
set output  "interarrival.png"
set title "InterArrival Time "
set xlabel "Time (in sec)"
set ylabel "InterArrival Time(in sec)"
plot    "arq.dat" using 1:3 
    
