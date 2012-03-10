package DDG::Goodie::Unicode;

use DDG::Goodie;
use Unicode::UCD qw/charinfo/;

triggers query_raw => qr/^\s*u\+[a-f0-9]{4,6}\s*$/i;

zci is_cached => 1;

zci answer_type => 'unicode';

handle sub {
    /([a-f0-9]+)/i or return;
    my $c = hex $1;
    my %i = %{ charinfo($c) };
    return unless $i{name};

    my $info_str = join ' ', chr($c), 'U+' . $i{code}, $i{name};
    my %extra;
    if (defined $i{script}) {
        my $s = $i{script};
        $s =~ tr/_/ /;
        if ($s ne 'Common' && $s ne 'Inherited' && $s  ne 'Unknown'
                    && $i{name} !~ /$s/i) {
            $extra{script} = $i{script};
        }
    }
    if ($i{decomposition}) {
        ($extra{decomposition} = $i{decomposition}) =~ s/\b([0-9a-fA-F]{4,6})\b/U+$1/;
    }
    $extra{block} = $i{block};

    delete $i{title} if $i{title} eq $i{upper};

    for (qw/upper title lower/) {
        $extra{$_} = 'U+' . $i{$_} if length $i{$_};
    }

    for (qw/script block decomposition title upper lower/) {
        $info_str .= ", $_: $extra{$_}" if exists $extra{$_};
    }
    return $info_str;
};

1;
