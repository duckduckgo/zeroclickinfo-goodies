package DDG::Goodie::Uppercase;
# ABSTRACT: uppercase a provided string.

use strict;
use DDG::Goodie;

triggers start => 'uppercase', 'upper case', 'allcaps', 'all caps', 'strtoupper', 'toupper';
# leaving out 'uc' because of queries like "UC Berkley", etc
# 2014-08-10: triggers to "start"-only  to make it act more like a "command"
#   resolves issue with queries like "why do people type in all caps"

zci answer_type => "uppercase";
zci is_cached   => 1;

handle remainder => sub {
    my $input = shift;

    return unless $input;
    return if $input eq uc($input);

    my $upper = uc $input;

    return $upper, structured_answer => {
        data => {
            title => $upper,
            subtitle => "Uppercase: $input"
        },
        templates => {
            group => 'text'
        }
    };
};

1;
