ns csma.tcl
ns csmaRTS.tcl
rm csma_results;
echo "Performance Analysis of All Protocols">>csma_results;

echo "Simulation result of  CSMA/CA protocol without RTS" >>csma_results;

awk -f csma.awk <csma.tr  >csma.dat
echo "Simulation result of CSMA/CA protocol with RTS" >>csma_results;
awk -f csma.awk <csmaRTS.tr  >csmaRTS.dat


gnuplot csma_throughput.gp 
gnuplot csma_interarrival.gp


