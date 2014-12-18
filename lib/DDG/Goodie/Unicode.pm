package DDG::Goodie::Unicode;
# ABSTRACT: unicode character information lookup

use DDG::Goodie;

use Unicode::UCD qw/charinfo/;
use Unicode::Char ();              # For name -> codepoint lookup
use Encode qw/encode_utf8/;

attribution github => ['https://github.com/cosimo', 'cosimo'];
primary_example_queries 'U+590c';
secondary_example_queries 'unicode white smiling face';
description 'get information about a unicode character';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Unicode.pm';
name 'Unicode';
category 'computing_info';
topics 'programming';


use constant {
    CODEPOINT_RE => qr/^ \s* (?:U \+|\\(?:u|x{(?=.*}))) (?<codepoint> [a-f0-9]{4,6})}? \s* $/xi,
    NAME_RE      => qr/^ (?<name> [A-Z][A-Z\s]+) $/xi,
    CHAR_RE      => qr/^ \s* (?<char> .) \s* $/x,
    UNICODE_RE   => qr/^ unicode \s+ (.+) $/xi,
    CODEPOINT    => 1,
    NAME         => 2,
    CHAR         => 3,
};

triggers query_raw => CODEPOINT_RE;

# Also allows open-ended queries like: "LATIN SMALL LETTER X"
triggers query_raw => UNICODE_RE;

zci is_cached => 1;
zci answer_type => "unicode_conversion";

handle sub {
    my $term = $_[0];

    # Search term starts with "unicode "
    if ($term =~ UNICODE_RE) {
        return unicode_lookup($1);
    }

    return codepoint_description($term);
};

sub codepoint_description {
    my $term = $_[0];
    return unless $term;

    if ($term !~ m{([a-f0-9]+)}i) {
        return;
    }

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
    $extra{HTML}    = substr($i{category},0,1) eq 'C' ? "No visual representation" : "&#$c;";
    $extra{'UTF-8'} = join ' ',
    map { sprintf '0x%02X', ord $_ }
    split //, encode_utf8(chr($c));

    if ($i{decomposition}) {
        ($extra{decomposition} = $i{decomposition}) =~ s/\b(?<!<)([0-9a-fA-F]{4,6})\b(?!>)/U+$1/g;
    }
    $extra{block} = $i{block};

    delete $i{title} if $i{title} eq $i{upper};

    for (qw/upper title lower/) {
        $extra{$_} = 'U+' . $i{$_} if exists $i{$_} && length $i{$_};
    }

    for (qw/decimal HTML UTF-8 script block decomposition title upper lower/) {
        $info_str .= ", $_: $extra{$_}" if exists $extra{$_};
    }
    return $info_str;
}

sub char_to_codepoint {
    my $c = $_[0];

    my $u = Unicode::Char->new();
    return if ! defined $c or $c eq "";

    my $cp = unpack('H*', pack('N', ord($c)));
    $cp =~ s{^ 0+ }{}x;
    $cp = uc ('u+' . $cp);
    return $cp;
}

sub input_type ($) {
    my $input = $_[0] || q{};
    my $type;

    if ($input =~ CODEPOINT_RE) {
        $input = $+{codepoint};
        $type = CODEPOINT;
    }
    elsif ($input =~ NAME_RE) {
        $input = $+{name};
        $type = NAME;
    }
    elsif ($input =~ CHAR_RE) {
        $input = $+{char};
        $type = CHAR;
    }

    return ($input, $type);
                }

sub name_to_char {
    my $name = $_[0];
    my $u = Unicode::Char->new();
    return $u->n($name);
}

sub unicode_lookup {
    my $term = $_[0];

    if (! defined $term or $term eq "") {
        return;
    }

    my $result;
    my $type;

    ($term, $type) = input_type($term);
    if (! defined $type) {
        return;
    }

    if ($type == CODEPOINT) {
        $result = codepoint_description($term);
    }
    elsif ($type == NAME) {
        my $char = name_to_char($term);
        my $cp = char_to_codepoint($char);
        $result = codepoint_description($cp);
    }
    elsif ($type == CHAR) {
        my $cp = char_to_codepoint($term);
        $result = codepoint_description($cp);
    }

    return $result;
}

1;
