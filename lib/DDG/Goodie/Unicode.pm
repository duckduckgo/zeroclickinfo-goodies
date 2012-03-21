package DDG::Goodie::Unicode;

use DDG::Goodie;
use Unicode::UCD qw/charinfo/;
use Encode qw/encode_utf8/;

triggers query_raw => qr/^\s*u\+[a-f0-9]{4,6}\s*$/i;

zci is_cached => 1;

zci answer_type => "Unicode";

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
    $extra{decimal} = $c;
    $extra{HTML}    = "&#$c;";
    $extra{'UTF-8'} = join ' ',
                      map { sprintf '0x%02X', ord $_ }
                      split //, encode_utf8(chr($c));

    if ($i{decomposition}) {
        ($extra{decomposition} = $i{decomposition}) =~ s/\b(?<!<)([0-9a-fA-F]{4,6})\b(?!>)/U+$1/g;
    }
    $extra{block} = $i{block};

    delete $i{title} if $i{title} eq $i{upper};

    for (qw/upper title lower/) {
        $extra{$_} = 'U+' . $i{$_} if length $i{$_};
    }

    for (qw/decimal HTML UTF-8 script block decomposition title upper lower/) {
        $info_str .= ", $_: $extra{$_}" if exists $extra{$_};
    }
    return $info_str;
};

1;
