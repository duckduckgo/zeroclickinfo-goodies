package DDG::Goodie::Regexp;

# ABSTRACT: Parse a regexp and list the matches

use strict;
use warnings;
use DDG::Goodie;

use Safe;

zci answer_type => "regexp";
zci is_cached   => 1;

triggers start => 'regex', 'match', 'regexp';
triggers any   => '=~';

sub compile_re {
    my ($re, $modifiers, $compiler) = @_;
    $compiler->($re, $modifiers);
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
    my ($regexp, $str, $modifiers) = @_;
    my $compiler = Safe->new->reval(q { sub { qr/(?$_[1])$_[0]/ } }) or return;
    BEGIN {
        $SIG{'__WARN__'} = sub {
            warn $_[0] if $_[0] !~ /Use of uninitialized value in regexp compilation/i;
        }
    }

    my @numbered = $str =~ compile_re($regexp, $modifiers, $compiler) or return;
    @numbered = real_number_matches($1, @numbered);
    my $matches = {};
    $matches->{'Full Match'} = get_full_match($str);
    foreach my $match (keys %+) {
        $matches->{"Named Capture <$match>"} = $+{$match};
    };
    my $i = 1;
    foreach my $match (@numbered) {
        $matches->{"Subpattern Match $i"} = $match;
        $i++;
    };
    return $matches;
}

my $regex_re = qr/\/(?<regex>.+)\/(?<modifiers>i)?/;

sub extract_regex_text {
    my $query = shift;
    $query =~ /^(?<text>.+) =~ $regex_re$/;
    ($+{regex} && $+{text}) || ($query =~ /^(?:match\s*regexp?|regexp?)\s*$regex_re\s+(?<text>.+)$/);
    return unless defined $+{regex} && defined $+{text};
    my $modifiers = $+{modifiers} // '';
    return ($+{regex}, $+{text}, $modifiers);
}

sub get_match_keys { return sort (keys %{$_[0]}) }

handle query => sub {
    my $query = $_;
    my ($regexp, $str, $modifiers) = extract_regex_text($query) or return;
    my $matches = get_match_record($regexp, $str, $modifiers) or return;
    my @key_order = get_match_keys($matches);
    return unless $matches->{'Full Match'} ne '';

    return $matches,
        structured_answer => {
            data => {
                title       => "Regular Expression Match",
                subtitle    => "Match regular expression /$regexp/$modifiers on $str",
                record_data => $matches,
                record_keys => \@key_order,
            },
            meta => {
                signal => 'high',
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
