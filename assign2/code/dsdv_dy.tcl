################################################################
# AODV wireless simulation related parameters                       #
################################################################
set val(chan)           Channel/WirelessChannel    ;# Channel Type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             3                          ;# number of mobilenodes
set val(rp)             DSDV                        ;# routing protocol
set val(x)		400
set val(y)		150


################################################################
# Initialization                                               #
# 1. create simulator                                          #
# 2. tracing                                                   #
# 3. define topography                                         #
################################################################
set ns		[new Simulator]

set tracefd     [open dsdv_dy.tr w]
$ns trace-all   $tracefd
set namtracefd    [open dsdv_dy.nam w]
$ns namtrace-all-wireless $namtracefd $val(x) $val(y)

set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

################################################################
# Define/create/initialize nodes                               #
# 1. define nodes                                              #
# 2. create nodes                                              #
# 3. disable random motion                                     #
# 4. coordinates of wilress nodes                              #
# 5. nam setting, size and position                            #
################################################################
$ns node-config -adhocRouting $val(rp) \
		-llType $val(ll) \
		-macType $val(mac) \
		-ifqType $val(ifq) \
		-ifqLen $val(ifqlen) \
		-antType $val(ant) \
		-propType $val(prop) \
		-phyType $val(netif) \
		-topoInstance $topo \
		-agentTrace ON \
		-routerTrace ON \
		-macTrace ON \
		-movementTrace ON\
		-channel [new $val(chan)]

set node_(0) [$ns node]
set node_(1) [$ns node]
set node_(2) [$ns node]

$node_(0) random-motion 0
$node_(1) random-motion 0
$node_(2) random-motion 0

$node_(0) set X_ 50.0
$node_(0) set Y_ 50.0
$node_(0) set Z_ 0.0
$node_(1) set X_ 0.0
$node_(1) set Y_ 50.0
$node_(1) set Z_ 0.0
$node_(2) set X_ 400.0
$node_(2) set Y_ 50.0
$node_(2) set Z_ 0.0

for {set i 0} {$i < $val(nn)} {incr i} {
	$ns initial_node_pos $node_($i) 50 
}

################################################################
# Create traffic: a cbr connection                             #
################################################################
set udp [new Agent/UDP]
set null [new Agent/Null]
$ns attach-agent $node_(0) $udp
$ns attach-agent $node_(2) $null
$ns connect $udp $null
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set random_ false
$cbr set rate_ .2Mb

################################################################
# Schedule events                                              #
################################################################

$ns at 0.1 "$node_(1) setdest 200.0 50.0 50.0"
$ns at 0.1 "$cbr start" 
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns at 200.0 "$node_($i) reset";
}
$ns at 150.01 "stop"
$ns at 150.02 "puts \"NS EXITING...\" ; $ns halt"

################################################################
# 'stop' procedure                                             #
################################################################
proc stop {} {
    global ns tracefd namtracefd
    $ns flush-trace
    close $tracefd
    close $namtracefd

    puts "running nam..."
    exec nam dsdv_dy.nam &
    exit 0
}

################################################################
# start the simulation                                         #
################################################################
$ns run


