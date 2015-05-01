
BEGIN { 
	
	count=0;
	
	no_of_packet=0;
}
{
	
	no_of_packet+=$6-$7;
	count++;
		etime=$1;
	print etime," ",no_of_packet/count,$6-$7;
	
	
}

END {	
	QueLenInPacket=no_of_packet/count;
	
	print "\n Avg Queue Length in Packets \t:",QueLenInPacket  >> "results";
}
