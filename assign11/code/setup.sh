../ns arq1.tcl 0.1 10
rm results
echo "Performance Analysis ">>results;

echo "Simulation Result ">>results;
 awk -f awk_script.awk < tcp_arq.tr  >arq.dat






gnuplot interarrival.plot
gnuplot throughput.plot


