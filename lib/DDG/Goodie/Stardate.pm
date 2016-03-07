package DDG::Goodie::Stardate;
# ABSTRACT: Returns stardate (see Star Trek)

use DDG::Goodie;
use strict;
use POSIX 'strftime';

zci answer_type => 'stardate';
zci is_cached => 0;

triggers start => 'stardate';

handle remainder => sub {
    my $answer = strftime("%Y%m%d.", gmtime). int(time%86400/86400 * 100000);
    return $answer,
        structured_answer => {
            id => 'stardate',
            name => 'Answer',
            data => {
              title => $answer,
              subtitle => "Stardate",
            },
            templates => {
                group => "text",
            }
        };
};

1;
