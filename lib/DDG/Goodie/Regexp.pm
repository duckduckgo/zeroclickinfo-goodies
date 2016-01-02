package DDG::Goodie::Regexp;
# ABSTRACT: Parse a regexp.

use strict;
use DDG::Goodie;

use Safe;

zci answer_type => "regexp";
zci is_cached   => 1;

triggers start => 'regex', 'match', 'regexp';

sub compile_re {
    my ($re, $compiler) = @_;
    $compiler->($re);
}

# Using $& causes a performance penalty, apparently.
sub get_full_match {
    return substr(shift, $-[0], $+[0] - $-[0]);
}

# Ensures that the correct numbered matches are being produced.
sub real_number_matches {
    my ($one, @numbered) = @_;
    # If the first match isn't defined then neither are the others!
    return defined $one ? @numbered : ();
}

sub get_match_record {
    my ($regexp, $str) = @_;
    my $compiler = Safe->new->reval(q{ sub { qr/$_[0]/ } });
    my @numbered = $str =~ compile_re($regexp, $compiler) or return;
    @numbered = real_number_matches($1, @numbered);
		my $matches = {};
		$matches->{'Full Match'} = get_full_match($str);
    foreach my $match (keys %+) {
		    $matches->{"Named Match ($match)"} = $+{$match};
    };
    my $i = 1;
    foreach my $match (@numbered) {
        $matches->{"Number Match ($i)"} = $match;
        $i++;
    };
    return $matches;
}

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
