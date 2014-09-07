package DDG::Goodie::Regexp;
# ABSTRACT: Parse a regexp.

use DDG::Goodie;

use Safe;

zci answer_type => "regexp";

primary_example_queries 'regexp /(.*)/ ddg';
description 'Regular expressions';
name 'regexp';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Regexp.pm';
category 'computing_tools';
topics 'programming', 'sysadmin';
attribution web => [ 'https://www.duckduckgo.com', 'DuckDuckGo' ],
            github => [ 'https://github.com/duckduckgo', 'duckduckgo'],
            twitter => ['http://twitter.com/duckduckgo', 'duckduckgo'];

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
