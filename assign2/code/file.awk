
BEGIN { 
	
	throughput=0;
	interarrival=0;
	tot_byte=0;
	no_of_packet=0;
}
{
	if($1=="r" && ($3 == "_2_"))
	{
	no_of_packet=no_of_packet+1;
	time=$2;
	tot_byte=tot_byte+$8;
	print time," ",tot_byte*8/((time-0.1)*1024)," ",(time-0.1)/no_of_packet;;
	}
}

END {	
	throughput=tot_byte*8/((time - 0.1)*1024);
	interarrival=(time-0.1)/no_of_packet;
	print "\n Throughput \t:",throughput," bps \n Interarrival Time\t:",interarrival," sec\n\n" >> "results";
}
