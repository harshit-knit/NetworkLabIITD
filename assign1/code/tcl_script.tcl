
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
set f [open trace_output.tr w]
$ns trace-all $f

set nf [open nam_output.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish {} {
        global ns f nf
        $ns flush-trace
        #Close the NAM trace file

	close $f
        close $nf
        #Execute NAM on the trace file
	
       exec nam nam_output.nam &
        exit 0
}

#define topology

#defining nodes
set T1 [$ns node]
set T2 [$ns node]
set T3 [$ns node]
set T4 [$ns node]
set T5 [$ns node]
set T6 [$ns node]

set B1 [$ns node]
set B2 [$ns node]
set B3 [$ns node]

set R1 [$ns node]
set R2 [$ns node]
set R3 [$ns node]
set R4 [$ns node]
set R5 [$ns node]
set R6 [$ns node]

#defining links between nodes
$ns duplex-link $T1 $B1 200Kb 10ms RED
$ns duplex-link $T2 $B1 200Kb 10ms RED
$ns duplex-link $T3 $B1 200Kb 10ms RED

$ns duplex-link $T4 $B2 200Kb 10ms SFQ
$ns duplex-link $T5 $B2 200Kb 10ms SFQ
$ns duplex-link $T6 $B2 200Kb 10ms SFQ

$ns duplex-link $B1 $B3 500Kb 10ms DropTail
$ns duplex-link $B2 $B3 500Kb 10ms DropTail

$ns duplex-link $B3 $R1 200Kb 10ms DropTail
$ns duplex-link $B3 $R2 200Kb 10ms DropTail
$ns duplex-link $B3 $R3 200Kb 10ms DropTail
$ns duplex-link $B3 $R4 200Kb 10ms DropTail
$ns duplex-link $B3 $R5 200Kb 10ms DropTail
$ns duplex-link $B3 $R6 200Kb 10ms DropTail

#Set Queue Size of link 
$ns queue-limit $T1 $B1 1000
$ns queue-limit $T2 $B1 1000
$ns queue-limit $T3 $B1 1000

$ns queue-limit $T4 $B2 1000
$ns queue-limit $T5 $B2 1000
$ns queue-limit $T6 $B2 1000

$ns queue-limit $B1 $B3 2000
$ns queue-limit $B2 $B3 2000

$ns queue-limit $B3 $R1 1000
$ns queue-limit $B3 $R2 1000
$ns queue-limit $B3 $R3 1000
$ns queue-limit $B3 $R4 1000
$ns queue-limit $B3 $R5 1000
$ns queue-limit $B3 $R6 1000

#Give node position (for NAM)
$ns duplex-link-op $T1 $B1 orient right-down
$ns duplex-link-op $T2 $B1 orient right
$ns duplex-link-op $T3 $B1 orient right-up



$ns duplex-link-op $T4 $B2 orient right-down
$ns duplex-link-op $T5 $B2 orient right
$ns duplex-link-op $T6 $B2 orient right-up

$ns duplex-link-op $B1 $B3 orient right-down
$ns duplex-link-op $B2 $B3 orient right-up



$ns duplex-link-op $B3 $R1 orient right-up-up-up

$ns duplex-link-op $B3 $R2 orient right-up-up

$ns duplex-link-op $B3 $R3 orient right-up

$ns duplex-link-op $B3 $R4 orient right-down

$ns duplex-link-op $B3 $R5 orient right-down-down

$ns duplex-link-op $B3 $R6 orient right-down-down-down

#Monitor the queue for link (n2-n3). (for NAM)
$ns duplex-link-op $B1 $B3 queuePos 0.5
$ns duplex-link-op $B2 $B3 queuePos 0.5

#Setup a TCP connection1
set tcp1 [new Agent/TCP]
$tcp1 set class_ 2
$ns attach-agent $T1 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $R1 $sink1
$ns connect $tcp1 $sink1
$tcp1 set fid_ 1

#Setup a FTP over TCP connection
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP

#Setup a TCP connection2
set tcp2 [new Agent/TCP]
$tcp2 set class_ 2
$ns attach-agent $T2 $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $R2 $sink2
$ns connect $tcp2 $sink2
$tcp2 set fid_ 2

#Setup a FTP over TCP connection
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ftp2 set type_ FTP

#Setup a TCP connection3
set tcp3 [new Agent/TCP]
$tcp3 set class_ 2
$ns attach-agent $T3 $tcp3
set sink3 [new Agent/TCPSink]
$ns attach-agent $R3 $sink3
$ns connect $tcp3 $sink3
$tcp3 set fid_ 3

#Setup a FTP over TCP connection
set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp3
$ftp3 set type_ FTP

#Setup a TCP connection4
set tcp4 [new Agent/TCP]
$tcp4 set class_ 2
$ns attach-agent $T4 $tcp4
set sink4 [new Agent/TCPSink]
$ns attach-agent $R4 $sink4
$ns connect $tcp4 $sink4
$tcp4 set fid_ 4

#Setup a FTP over TCP connection
set ftp4 [new Application/FTP]
$ftp4 attach-agent $tcp4
$ftp4 set type_ FTP

#Setup a TCP connection5
set tcp5 [new Agent/TCP]
$tcp5 set class_ 2
$ns attach-agent $T5 $tcp5
set sink5 [new Agent/TCPSink]
$ns attach-agent $R5 $sink5
$ns connect $tcp5 $sink5
$tcp5 set fid_ 5

#Setup a FTP over TCP connection
set ftp5 [new Application/FTP]
$ftp5 attach-agent $tcp5
$ftp5 set type_ FTP

#Setup a TCP connection6
set tcp6 [new Agent/TCP]
$tcp6 set class_ 2
$ns attach-agent $T6 $tcp6
set sink6 [new Agent/TCPSink]
$ns attach-agent $R6 $sink6
$ns connect $tcp6 $sink6
$tcp6 set fid_ 6

#Setup a FTP over TCP connection
set ftp6 [new Application/FTP]
$ftp6 attach-agent $tcp6
$ftp6 set type_ FTP







#Schedule events for  FTP agents
$ns at 0.1 "$ftp1 start"
$ns at 0.2 "$ftp2 start"
$ns at 0.3 "$ftp3 start"
$ns at 0.1 "$ftp4 start"
$ns at 0.2 "$ftp5 start"
$ns at 0.3 "$ftp6 start"


$ns at 3.0 "$ftp1 stop"
$ns at 3.0 "$ftp2 stop"
$ns at 3.0 "$ftp3 stop"
$ns at 3.0 "$ftp4 stop"
$ns at 3.0 "$ftp5 stop"
$ns at 3.0 "$ftp6 stop"


#Detach tcp and sink agents (not really necessary)
$ns at 3.5 "$ns detach-agent $T1 $tcp1 ; $ns detach-agent $R1 $sink1"
$ns at 3.5 "$ns detach-agent $T1 $tcp2 ; $ns detach-agent $R2 $sink2"
$ns at 3.5 "$ns detach-agent $T3 $tcp3 ; $ns detach-agent $R3 $sink3"
$ns at 3.5 "$ns detach-agent $T4 $tcp4 ; $ns detach-agent $R4 $sink4"
$ns at 3.5 "$ns detach-agent $T5 $tcp5 ; $ns detach-agent $R5 $sink5"
$ns at 3.5 "$ns detach-agent $T6 $tcp6 ; $ns detach-agent $R6 $sink6"


#Call the finish procedure after 5 seconds of simulation time
$ns at 4.0 "finish"



#Run the simulation
$ns run



