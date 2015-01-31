package DDG::Goodie::Uppercase;
# ABSTRACT: uppercase a provided string.

use DDG::Goodie;

triggers start => 'uppercase', 'upper case', 'allcaps', 'all caps', 'strtoupper', 'toupper';
# leaving out 'uc' because of queries like "UC Berkley", etc
# 2014-08-10: triggers to "start"-only  to make it act more like a "command"
#   resolves issue with queries like "why do people type in all caps"

zci answer_type => "uppercase";
zci is_cached   => 1;

primary_example_queries   'uppercase this';
secondary_example_queries 'upper case that';

name        'Uppercase';
description 'Make a string uppercase.';
code_url    'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Uppercase.pm';
category    'conversions';
topics      'programming';

attribution twitter => ['crazedpsyc', 'Michael Smith'],
            cpan    => ['CRZEDPSYC', 'Michael Smith'];

handle remainder => sub {
    my $input = shift;

    return unless $input;

    my $upper = uc $input;

    return $upper,
      structured_answer => {
        input     => [html_enc($input)],
        operation => 'Uppercase',
        result    => html_enc($upper),
      };
};

1;
