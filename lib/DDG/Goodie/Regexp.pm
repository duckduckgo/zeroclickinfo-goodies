package DDG::Goodie::Regexp;

use DDG::Goodie;
use Safe;

zci is_cached => 1;
zci answer_type => "regexp";

primary_example_queries 'regexp /(.*)/ ddg';
description 'Regular expressions';
name 'regexp';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Regexp.pm';
category 'computing';
topics 'programming', 'sysadmin';
attribution web => [ 'https://www.duckduckgo.com', 'DuckDuckGo' ],
            github => [ 'https://github.com/duckduckgo', 'duckduckgo'],
            twitter => ['http://twitter.com/duckduckgo', 'duckduckgo'];

triggers query_lc => qr/^regexp [\/\\](.*?)[\/\\] (.*)$/i;

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

    return join( ' | ', @results );
};

1;