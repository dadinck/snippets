#! /usr/bin/perl

$interval = shift @ARGV || 10;
%lastone=();

while (1) {
    open(NET, "ip -s link|");
    @info=<NET>;
    close NET;
    for $line (0..$#info) {
       next if $info[$line] !~ /^(\S+:)\s+(\S+:)/;
       $iface = $2;
       $rx = $info[$line+3];
       $tx = $info[$line+5];
       ($txb, $txp) = split(' ', $tx);
       ($rxb, $rxp) = split(' ', $rx);
       $txrate=$rxrate="";
       if(defined($last{$iface}{txb})) {
           $txrate = ($txb - $last{$iface}{txb})/$interval;
       }
       if(defined($last{$iface}{rxb})) {
           $rxrate = ($rxb - $last{$iface}{rxb})/$interval;
       }
       print "$iface rx $rxrate $rxb tx $txrate $txb\n";
       $last{$iface}{txb} = $txb;
       $last{$iface}{rxb} = $rxb;
    }
    sleep $interval;
}
