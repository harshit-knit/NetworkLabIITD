set terminal png    
set output  "queuelength.png"
set grid
set title "QueLength at Receiver Nodes"
set xlabel "Time (in sec)"
set ylabel "QueLength(in Packets)"
plot    "q1.dat" using 1:3  title "Queue1" with lines ,\
		"q2.dat" using 1:3  title "Queue2" with lines,\
    "q3.dat" using 1:3  title "Queue3" with lines



