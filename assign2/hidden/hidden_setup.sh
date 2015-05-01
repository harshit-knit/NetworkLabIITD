ns hiddenNode.tcl
ns hiddenNodeRemoved.tcl
rm hidden_results;
echo "Performance Analysis of All Protocols">>hidden_results;

echo "Simulation result of Hidden Node Problem without RTS/CTS" >>hidden_results;

awk -f hidden_file.awk <hiddenNode.tr  >hiddenNode.dat
echo "Simulation result of Hidden Node Prolem with RTS/CTS" >>hidden_results;
awk -f hidden_file.awk <hiddenNodeRemoved.tr  >hiddenNodeRemoved.dat


gnuplot hidden_throughput.gp 
gnuplot hidden_interarrival.gp


