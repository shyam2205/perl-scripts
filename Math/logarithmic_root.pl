#!/usr/bin/perl

# Author: Daniel "Trizen" Șuteu
# License: GPLv3
# Date: 17 July 2016
# Website: https://github.com/trizen

# Logarithmic root of n.

# Solves c = x^x, where "c" is known.
# (based on Newton's method for the nth-root)

# Example: 100 = x^x
#          x = lgrt(100)
#          x =~ 3.59728502354042

use 5.010;
use strict;
use warnings;

use Math::BigNum qw(:constant);

sub lgrt {
    my ($c) = @_;

    my $p = 1 / 10**($Math::BigNum::PREC / 4);
    my $d = log($c);

    my $x = 1;
    my $y = 0;

    while (abs($x - $y) > $p) {
        $y = $x;
        $x = ($x + $d)->fdiv(1 + log($x));
    }

    $x;
}

say lgrt(100);    # 3.59728502354041750549765225178228606913554305488658
