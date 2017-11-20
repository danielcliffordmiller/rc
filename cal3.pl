#!/usr/bin/perl -w

use strict;
use v5.12;

my (undef, undef, undef, $cur_day, $cur_month, $cur_year) = localtime;

$cur_month += 1;
$cur_year += 1900;

# at this point, the month and the year are absolute

my ($rev, $off) = (`tput rev`, `tput sgr0`);

my $mon = $ARGV[0] || $cur_month;
my $yr = $ARGV[1] || $cur_year;

die "invalid month '$mon'" if $mon < 1 || $mon > 12;

my @cals = map {
	my @cal = qx( cal $_->[0], $_->[1] );
	map{s/$cur_day/$rev$cur_day$off/ unless /$cur_year/} @cal if $_->[0] == $cur_month && $_->[1] == $cur_year;
	foreach my $l (@cal) { chomp($l) }
	[ @cal ];
} (
	$mon == 1 ? [ 12, $yr - 1 ] : [ $mon - 1, $yr ], 
	[ $mon, $yr ],
	$mon == 12 ? [ 1, $yr + 1 ] : [ $mon + 1, $yr ],
);

my @lines;
for(my $i=0; $i < scalar @cals; $i++) {
	for(my $j=0; $j < scalar @{$cals[$i]}; $j++) {
		$lines[$j][$i] = $cals[$i][$j];
	}
}

foreach my $line (@lines) {
	say join '', map {
		my $r = " ".sprintf("%-21s", $_);
		$r .= " " if index($r, $rev) > -1;
		$r
	} @$line;
}
