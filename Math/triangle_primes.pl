#!/usr/bin/perl

# Author: Daniel "Trizen" Șuteu
# License: GPLv3
# Date: 10 April 2015
# http://github.com/trizen

# A number triangle, with the primes highlighted in blue
# (there are some lines that have more primes than others)

# Inspired by: https://www.youtube.com/watch?v=iFuR97YcSLM

use 5.010;
use strict;
use warnings;

use GD::Simple;
use Math::Prime::XS qw(is_prime);

my $i = 1;
my $j = 1;

my $n = shift(@ARGV) // 8000000;    # duration: about 45 seconds
my $limit = int(sqrt($n) - 1);

my %top;                            # count the number of primes on vertical lines
my $top = 10;                       # how many lines to display at the end

# create a new image
my $img = GD::Simple->new($limit * 2, $limit + 1);
$img->moveTo(0, 0);

my $white = 0;
for my $m (reverse(0 .. $limit)) {

    #print " " x $m;
    $img->moveTo($m, $i - 1);
    for my $n ($j .. $i**2) {

        #print $j;
        if (is_prime($j)) {
            $white = 0;
            $img->fgcolor('blue');
            my ($x) = $img->curPos;
            $top{$x}{count}++;
            $top{$x}{first} //= $j;
        }
        elsif (not $white) {
            $img->fgcolor('white');
            $white = 1;
        }
        $img->line(1);
        $j++;
    }
    ++$i;

    #print "\n";
}

say "=> Top vertical lines: ";
foreach my $i (sort { $top{$b}{count} <=> $top{$a}{count} } keys %top) {
    state $counter = 0;
    say "$i:\t$top{$i}{count} (first prime: $top{$i}{first})";
    last if ++$counter == $top;
}

open my $fh, '>:raw', 'triangle_primes.png';
print $fh $img->png;
close $fh;
