package DDG::Goodie::Sort;
# ABSTRACT: Sort a sequence of signed numbers

use strict;

use DDG::Goodie;
# Used to restrict long inputs
use constant MAX_LIST_SIZE => 32;

triggers start => 'sort';

zci is_cached => 1;
zci answer_type => 'sort';

primary_example_queries 'sort -3 -10 56 10';
secondary_example_queries 'sort descending 10, -1, +5.3, -95, 1';
description 'Return the given numbers list in a sorted order.';
name 'Sort';
code_url 'http://github.com/koosha--';
category 'computing_tools';
topics 'programming';
attribution github => ['https://github.com/koosha--', 'koosha--'],
			twitter => '_koosha_';

handle remainder => sub {
    my $input = $_;
    $input =~ s/^\s+//;
    $input =~ s/[\s,;]+$//;
    my $number_re = qr/[-+]?(?:\d+|(?:\d*\.\d+))/;
    my $ascending = 1;
    if ($input =~ /^(?:asc|desc)(?:ending)?/i) {
        $ascending = 0 if $input =~ /^desc/i;
        $input =~ s/^(?:asc|desc)(?:ending)?\s*//i;
    }
    if ($input =~ /^$number_re(?:[\s,;]+$number_re)+$/) {
        my @numbers = split /[\s,;]+/, $input;
        if (scalar @numbers > MAX_LIST_SIZE) {
            @numbers = @numbers[0..MAX_LIST_SIZE - 1];
        }
        my @sorted = sort { $ascending ? $a <=> $b : $b <=> $a } @numbers;
        my $list = join(', ', @sorted);
        return sprintf("$list (Sorted %s)", $ascending ? 'ascendingly' : 'descendingly');
    }
    return;
};

1;
