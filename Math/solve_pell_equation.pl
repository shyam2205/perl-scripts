#!/usr/bin/perl

# Daniel "Trizen" Șuteu
# Date: 31 August 2016
# License: GPLv3
# https://github.com/trizen

# Find a minimum solution to a Pell equation: x^2 - d*y^2 = 1, where `d` is known.

# See also:
#   https://en.wikipedia.org/wiki/Pell%27s_equation
#   https://projecteuler.net/problem=66

use 5.010;
use strict;
use warnings;

use Math::AnyNum qw(isqrt is_square);

sub sqrt_convergents {
    my ($n) = @_;

    my $x = isqrt($n);
    my $y = $x;
    my $z = 1;

    my @convergents = ($x);

    do {
        $y = int(($x + $y) / $z) * $z - $y;
        $z = int(($n - $y * $y) / $z);
        push @convergents, int(($x + $y) / $z);
    } until (($y == $x) && ($z == 1));

    return @convergents;
}

sub continued_frac {
    my ($i, $c) = @_;
    $i < 0 ? 0 : ($c->[$i] + continued_frac($i - 1, $c))->inv;
}

sub solve_pell {
    my ($d) = @_;

    my ($k, @c) = sqrt_convergents($d);

    my @period = @c;
    for (my $i = 0 ; ; ++$i) {
        if ($i > $#c) { push @c, @period; $i = 2 * $i - 1 }

        my $x = continued_frac($i, [$k, @c])->denominator;
        my $p = 4 * $d * ($x * $x - 1);

        if (is_square($p)) {
            return ($x, isqrt($p) / (2 * $d));
        }
    }
}

foreach my $d (2 .. 20) {
    is_square($d) && next;
    my ($x, $y) = solve_pell($d);
    printf("x^2 - %2dy^2 = 1 \t minimum solution: x=%4s and y=%4s\n", $d, $x, $y);
}

__END__
x^2 -  2y^2 = 1      minimum solution: x=   3 and y=   2
x^2 -  3y^2 = 1      minimum solution: x=   2 and y=   1
x^2 -  5y^2 = 1      minimum solution: x=   9 and y=   4
x^2 -  6y^2 = 1      minimum solution: x=   5 and y=   2
x^2 -  7y^2 = 1      minimum solution: x=   8 and y=   3
x^2 -  8y^2 = 1      minimum solution: x=   3 and y=   1
x^2 - 10y^2 = 1      minimum solution: x=  19 and y=   6
x^2 - 11y^2 = 1      minimum solution: x=  10 and y=   3
x^2 - 12y^2 = 1      minimum solution: x=   7 and y=   2
x^2 - 13y^2 = 1      minimum solution: x= 649 and y= 180
x^2 - 14y^2 = 1      minimum solution: x=  15 and y=   4
x^2 - 15y^2 = 1      minimum solution: x=   4 and y=   1
x^2 - 17y^2 = 1      minimum solution: x=  33 and y=   8
x^2 - 18y^2 = 1      minimum solution: x=  17 and y=   4
x^2 - 19y^2 = 1      minimum solution: x= 170 and y=  39
x^2 - 20y^2 = 1      minimum solution: x=   9 and y=   2
