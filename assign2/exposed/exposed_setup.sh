ns exposedNode.tcl
ns exposedNodeRemoved.tcl
rm exposed_results;
echo "Performance Analysis of All Protocols">>exposed_results;

echo "Simulation result of Exposed Node Problem" >>exposed_results;

awk -f exposed_file.awk <exposedNode.tr  >exposedNode.dat
echo "Simulation result of Exposed Node Problem Removed " >>exposed_results;
awk -f exposed_file.awk <exposedNodeRemoved.tr  >exposedNodeRemoved.dat


gnuplot exposed_throughput.gp 
gnuplot exposed_interarrival.gp


