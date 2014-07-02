package DDG::Goodie::HexToDec;
# ABSTRACT: Convert hexidecimal to decimal

use DDG::Goodie;
use bignum;

triggers query_raw => qr/\b0x[0-9a-fA-F]+\b/;

zci answer_type => 'conversion';
zci is_cached   => 1;

primary_example_queries '0x44696f21';
description 'convert hexidecimal to decimal';
name 'HexToDec';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/HexToDec.pm';
category 'conversions';
topics 'math', 'programming';
attribution cpan   => 'majuscule',
            github => 'nospampleasemam',
            web    => ['https://dylansserver.com', 'Dylan Lloyd'] ;

my $css = share("style.css")->slurp;

sub wrap_html {
    my ($decimal, $octal, $bin) = @_;
    return "<style type='text/css'>$css</style>" .
           "<div class='zci--conversions text--primary'>" .
               "$decimal <sub>10</sub>" .
               "<div style='font-size:75%'>" .
                   "<span class='text--secondary'>Binary: </span> $bin " .
                   "<span class='text--secondary'>Octal: </span> $octal" .
               "</div>";
           "</div>";
}

handle query_raw => sub {
    m/\b0x([0-9a-fA-F]+)\b/;
    my $hex = $1;
    my $decimal = sprintf "%lu", hex $hex;
    my $octal = sprintf "%lo", hex $hex;
    my $bin = sprintf "%b", hex $hex;
    return "$hex base 16 = $decimal base 10 == " .
           "$octal base 8 == " .
           "$bin base 2",
           html => wrap_html($decimal, $octal, $bin);
};

0x41414141;
