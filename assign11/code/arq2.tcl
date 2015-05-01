# usage: ns <scriptfile> <err_rate> <num_rtx>
SimpleLink instproc link-arq { limit } {
    $self instvar link_ link_errmodule_ queue_ drophead_ head_
    $self instvar tARQ_ acker_ nacker_
 
    set tARQ_ [new ARQTx]
    set acker_ [new ARQAcker]
    set nacker_ [new ARQNacker]
    $tARQ_ set retry_limit_ $limit
    $acker_ attach-ARQTx $tARQ_
    $nacker_ attach-ARQTx $tARQ_
    $tARQ_ target [$queue_ target]
    $tARQ_ drop-target $drophead_
    $queue_ target $tARQ_
    $acker_ target [$link_errmodule_ target]
    $link_errmodule_ target $acker_
    $link_errmodule_ drop-target $nacker_
}

Simulator instproc link-arq {limit from to} {
    set link [$self link $from $to]
    $link link-arq $limit
}

proc show_tcp_seqno {} {
    global tcp ns x
    puts "At [$ns now], The tcp sequence number is [$tcp set t_seqno_]"
}

proc finish {} {
global ns tracefile1 namefile1
$ns flush-trace
close $tracefile1
close $namefile1
exec nam out.nam &
exit 0
}
#=== Create the Simulator, Nodes, and Links ===
set ns [new Simulator]
# Open the tracefile #
set tracefile1 [open tcp_arq.tr w]
$ns trace-all $tracefile1

#open nam trace
set namefile1 [open out.nam w] 
$ns namtrace-all $namefile1
set n1 [$ns node]

set n3 [$ns node]

$ns duplex-link $n1 $n3 5M 2ms DropTail

#=== Create error and ARQ module ===
set em [new ErrorModel]
$em set rate_ [lindex $argv 0]

$em set enable_ 1
$em unit pkt
$em set bandwidth_ 5M
$em ranvar [new RandomVariable/Uniform]
$em drop-target [new Agent/Null]

$ns link-lossmodel $em $n1 $n3


$ns link-arq 10 $n1 $n3

#=== Set up a TCP connection ===
set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]
set ftp [new Application/FTP]
$ns attach-agent $n1 $tcp
$ns attach-agent $n3 $sink
$ftp attach-agent $tcp
$ns connect $tcp $sink

$ns at 0.0 "$ftp start"
$ns at 100.0 show_tcp_seqno
$ns at 100.1 "finish"
$ns run
