BEGIN {
		
	init=0;
	bytes_received=0;
	
	packet_count=0;
	
	end_time=0;
	
}

/^r/&&($3==7)&& $4==8 {
	action = $1;
	received_time = $2;
	start_node = $3;
	end_node = $4;
	packet_type = $5;
	packet_size = $6;
	flow_id = $8;
	source_node = $9;
	destination_node = $10;
	sequence_no = $11;
	packet_id = $12;
   
	bytes_received=bytes_received+ packet_size;
	if(init==0) {
		start_time = received_time;
		init = 1;
	}
		
	end_time = received_time;
	packet_count= packet_count+1;
	interval=end_time-start_time;
	if(interval!=0)
	{
		throughput=(bytes_received*8/interval)/1024;
		interarrival_time=interval/packet_count;		
		printf ("%.4f\t%.4f\t%.4f\n",end_time,throughput,interarrival_time);
	}
}
END {

	
}
