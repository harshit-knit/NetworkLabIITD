
#creating Simulator Object
set ns [new Simulator]

#Define different colors for data flows (for NAM)
$ns color 1 Blue
$ns color 2 Red
$ns color 3 Green
$ns color 4 Purple
$ns color 5 Yellow
$ns color 6 Pink

#opening trace files
set f [open mm1.tr w]
$ns trace-all $f

set nf [open mm1.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish {} {
        global ns f nf
        $ns flush-trace
        #Close the NAM trace file

	close $f
        close $nf
        #Execute NAM on the trace file
	
       exec nam mm1.nam &
        exit 0
}



#defining nodes
set N0 [$ns node]
set N1 [$ns node]
set N2 [$ns node]
set N3 [$ns node]


#defining links between nodes
set link1 [$ns duplex-link $N1 $N0 100Kb 5ms DropTail]
set link2 [$ns duplex-link $N2 $N0 100Kb 5ms DropTail]
set link2 [$ns duplex-link $N3 $N0 100Kb 5ms DropTail]



#Set Queue Size of link 
$ns queue-limit $N1 $N0 100000
$ns queue-limit $N2 $N0 100000
$ns queue-limit $N3 $N0 100000

set lambda 30.0
set mu     33.0

#Give node position (for NAM)
$ns duplex-link-op $N1 $N0 orient right-down
$ns duplex-link-op $N2 $N0 orient right
$ns duplex-link-op $N3 $N0 orient right-up





#Monitor the queue for link (n2-n3). (for NAM)
$ns duplex-link-op $N1 $N0 queuePos 0.5
$ns duplex-link-op $N2 $N0 queuePos 0.5
$ns duplex-link-op $N3 $N0 queuePos 0.5

# generate random interarrival times and packet sizes
set InterArrivalTime [new RandomVariable/Exponential]
$InterArrivalTime set avg_ [expr 1/$lambda]

set pktSize [new RandomVariable/Exponential]
$pktSize set avg_ [expr 100000.0/(8*$mu)]



#Setup a UDP connection1
set udp1 [new Agent/UDP]
$udp1 set class_ 2
$ns attach-agent $N1 $udp1

set null1 [new Agent/Null]
$ns attach-agent $N0 $null1
$ns connect $udp1 $null1
$udp1 set fid_ 1



#Setup a UDP connection2
set udp2 [new Agent/UDP]
$udp2 set class_ 2
$ns attach-agent $N2 $udp2

set null2 [new Agent/Null]
$ns attach-agent $N0 $null2
$ns connect $udp2 $null2
$udp2 set fid_ 2



#Setup a UDP connection3
set udp3 [new Agent/UDP]
$udp3 set class_ 2
$ns attach-agent $N3 $udp3
set null3 [new Agent/Null]
$ns attach-agent $N0 $null3
$ns connect $udp3 $null3
$udp3 set fid_ 3

# queue monitoring


set qmon1 [$ns monitor-queue $N1 $N0 [open qm1.out w] 1]



# queue monitoring
set qmon2 [$ns monitor-queue $N2 $N0 [open qm2.out w]  1]
# queue monitoring
set qmon3 [$ns monitor-queue $N3 $N0 [open qm3.out w] 1]
[$ns link $N1 $N0] queue-sample-timeout
[$ns link $N2 $N0] queue-sample-timeout
[$ns link $N3 $N0] queue-sample-timeout
#$link3 queue-sample-timeout
#$link2 queue-sample-timeout

proc sendpacket1 {} {
    global ns udp1 InterArrivalTime pktSize 
    set time [$ns now]
    $ns at [expr $time + [$InterArrivalTime value]] "sendpacket1"
    set bytes [expr round ([$pktSize value])]
    $udp1 send [expr rand()*$bytes]
}
proc sendpacket2 {} {
    global ns udp2 InterArrivalTime pktSize 
    set time [$ns now]
    $ns at [expr $time + [$InterArrivalTime value]] "sendpacket2"
    set bytes [expr round ([$pktSize value])]
    $udp2 send [expr rand()*$bytes+100]
}
proc sendpacket3 {} {
    global ns udp3 InterArrivalTime pktSize 
    set time [$ns now]
    $ns at [expr $time + [$InterArrivalTime value]] "sendpacket3"
    set bytes [expr round ([$pktSize value])]
    $udp3 send [expr rand()*$bytes+100]
}





#Schedule events for  FTP agents
$ns at 0.1 "sendpacket1"
$ns at 0.1 "sendpacket2"
$ns at 0.1 "sendpacket3"


#Detach tcp and sink agents (not really necessary)
$ns at 300.1 "$ns detach-agent $N1 $udp1 ; $ns detach-agent $N0 $null1"
$ns at 300.1 "$ns detach-agent $N1 $udp2 ; $ns detach-agent $N0 $null2"
$ns at 300.1 "$ns detach-agent $N3 $udp3 ; $ns detach-agent $N0 $null3"



#Call the finish procedure after 35 seconds of simulation time
$ns at 300.5 "finish"



#Run the simulation
$ns run



