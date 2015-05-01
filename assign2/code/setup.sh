ns aodv.tcl
ns aodv_dy.tcl
ns dsdv.tcl
ns dsdv_dy.tcl
rm results;
echo "Performance Analysis of All Protocols">>results;

echo "Simulation result of STATIC AODV" >>results;

 awk -f file.awk <aodv.tr  >aodv.dat
echo "Simulation result of DYNAMIC AODV" >>results;
 awk -f file.awk <aodv_dy.tr  >aodv_dy.dat
echo "Simulation result of STATIC DSDV" >>results;
 awk -f file.awk <dsdv.tr  >dsdv.dat
echo "Simulation result of DYNAMIC DSDV" >>results;
 awk -f file.awk <dsdv_dy.tr  >dsdv_dy.dat

 gnuplot throughput.gp 
gnuplot interarrival.gp


