package DDG::Goodie::Regexp;
# ABSTRACT: Parse a regexp.

use strict;
use DDG::Goodie;

use Safe;

zci answer_type => "regexp";
zci is_cached   => 1;

triggers start => 'regex', 'match', 'regexp';

handle query => sub {
    my $regexp = $1;
    my $str    = $2;

    my $compiler = Safe->new->reval(q{ sub { qr/$_[0]/ } });

handle query => sub {
    my $query = $_;
    $query =~ s/^(?:match)?(?:\s*regexp?)?\s*//;
    $query =~ /(?:\/(.+)\/)\s+(.+)/;
    my $regexp = $1;
    my $str    = $2;
    return unless defined $regexp && defined $str;

    my $matches = get_match_record($regexp, $str) or return;

    return $matches,
        structured_answer => {
            id   => 'regexp',
            name => 'Answer',
            data => {
                title       => "Regular Expression Match",
                subtitle    => "Match regular expression /$regexp/ on $str",
                record_data => $matches,
            },
            templates => {
                group   => 'list',
                options => {
                    content => 'record',
                },
                moreAt  => 0,
            },
        };
};

1;
