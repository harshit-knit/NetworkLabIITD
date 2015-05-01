ns mm1.tcl
rm results
echo "Performance Analysis of M/D/1 Queue">>results;

echo "Simulation Result at Bottleneck Server">>results;
 awk -f awk_script.awk < mm1.tr  >parameter.dat

echo "Simulation result of Queue1" >>results;
 awk -f file.awk < qm1.out  >q1.dat
echo "Simulation result of Queue2" >>results;
 awk -f file.awk < qm2.out  >q2.dat
echo "Simulation result of Queue3" >>results;
 awk -f file.awk < qm3.out  >q3.dat



 gnuplot queueLength.plot
gnuplot interarrival.plot
gnuplot throughput.plot


