#!/usr/bin/perl -w

use strict;
use v5.12;

my (undef, undef, undef, undef, $mon, $yr) = localtime;

$mon = $ARGV[0] || $mon + 1;
$yr = $ARGV[1] || $yr + 1900;

# at this point, the month and the year are absolute

die "invalid month '$mon'" if $mon < 1 || $mon > 12;

my @cals = map {
	[ `cal $_->[0], $_->[1]` ]
} (
	$mon == 1 ? [ 12, $yr - 1 ] : [ $mon - 1, $yr ], 
	[ $mon, $yr ],
	$mon == 12 ? [ 1, $yr + 1 ] : [ $mon + 1, $yr ],
);

chomp @$_ foreach (@cals);

my @lines;
for(my $i=0; $i < scalar @cals; $i++) {
	for(my $j=0; $j < scalar @{$cals[$i]}; $j++) {
		$lines[$j][$i] = $cals[$i][$j];
	}
}

foreach my $line (@lines) {
	say join '', map { " ".sprintf("%-21s", $_) } @$line;
}
