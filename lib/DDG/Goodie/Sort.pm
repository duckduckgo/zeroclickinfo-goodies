package DDG::Goodie::Sort;
# ABSTRACT: Sort a sequence of signed numbers

use strict;

use DDG::Goodie;

use List::MoreUtils qw( all );
use Scalar::Util qw( looks_like_number );

# Used to restrict long inputs
use constant MAX_LIST_SIZE => 32;

triggers start => 'sort';

zci answer_type => 'sort';
zci is_cached   => 1;

primary_example_queries 'sort -3 -10 56 10';
secondary_example_queries 'sort descending 10, -1, +5.3, -95, 1';
description 'Return the given numbers list in a sorted order.';
name 'Sort';
code_url 'http://github.com/koosha--';
category 'computing_tools';
topics 'programming';
attribution github  => ['https://github.com/koosha--', 'koosha--'],
            twitter => '_koosha_';

my $delim = ', ';

handle remainder => sub {
    my $input = $_;
    $input =~ s/[\(\{\[]
                |
                [\}\)\]]$//gx;
    my $ascending = 1;
    if ($input =~ /^(?:asc|desc)(?:ending(?:ly)?)?/i) {
        $ascending = 0 if $input =~ /^desc/i;
        $input =~ s/^(?:asc|desc)(?:ending(?:ly)?)?\s*//i;
    }

    my @numbers = split /[\s,;]+/, $input;

    return unless all { looks_like_number($_) } @numbers;

    my $count = 0;
    @numbers = map { 0 + $_ } grep { ++$count <= MAX_LIST_SIZE } @numbers;    # Normalize and limit list size.

    my $unsorted_list = join($delim, @numbers);
    my $sorted_list = join($delim, sort { $ascending ? $a <=> $b : $b <=> $a } @numbers);
    my $dir = $ascending ? 'ascendingly' : 'descendingly';

    return "$sorted_list (Sorted $dir)",
      structured_answer => {
        input     => [$unsorted_list],
        operation => 'sort ' . $dir,
        result    => $sorted_list
      };
};

1;
