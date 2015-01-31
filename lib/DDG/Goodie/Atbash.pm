package DDG::Goodie::Atbash;
# ABSTRACT: A simple substitution cipher using a reversed alphabet

use DDG::Goodie;

primary_example_queries 'atbash hello';
secondary_example_queries 'atbash svool';
description 'A simple substitution cipher using a reversed alphabet';
name 'Atbash';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Atbash.pm';
category 'transformations';
topics 'cryptography';

attribution web     => ['http://kyokodaniel.com/tech/',      'Daniel Davis'],
            github  => ['https://github.com/tagawa',         'Daniel Davis'],
            twitter => ['https://twitter.com/ourmaninjapan', 'Daniel Davis'];

triggers start => 'atbash';

zci answer_type => 'atbash';
zci is_cached   => 1;

handle remainder => sub {

    my $in_string = $_;

    return unless $in_string;

    my $operation = 'Atbash';

    my $result;
    foreach my $char (split //, $in_string) {
        if ($char =~ /([a-z])/) {
            # Substitute lowercase characters
            $char = chr(219 - ord $1);
        } elsif ($char =~ /([A-Z])/) {
            # Substitute uppercase characters
            $char = chr(155 - ord $1);
        }
        $result .= $char;
    }

    return "$operation: $result",
      structured_answer => {
        input     => [html_enc($in_string)],
        operation => $operation,
        result    => html_enc($result),
      };
};

1;
