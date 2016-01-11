package DDG::Goodie::Regexp;
# ABSTRACT: Parse a regexp.

use strict;
use DDG::Goodie;

use Safe;

zci answer_type => "regexp";
zci is_cached   => 1;

triggers query_lc => qr/^regex[p]? [\/\\](.+?)[\/\\] (.+)$/i;

handle query => sub {
    my $regexp = $1;
    my $str    = $2;

    my $compiler = Safe->new->reval(q{ sub { qr/$_[0]/ } });

    sub compile_re {
        my ( $re, $compiler ) = @_;
        $compiler->($re);
    }

    my @results = ();
    eval {
		@results = $str =~ compile_re($regexp, $compiler);
    };

    return join( ' | ', @results ), heading => 'Regexp Result' if @results;
    return;
};

1;
