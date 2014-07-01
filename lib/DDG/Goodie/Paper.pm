package DDG::Goodie::Paper;
# ABSTRACT: Return the dimensions of a defined paper size

use DDG::Goodie;

zci answer_type => "paper";
zci is_cached   => 1;

triggers any => 'paper size', 'dimensions', 'paper dimension', 'paper dimensions';

primary_example_queries 'letter paper size';
secondary_example_queries 'a1 paper size', 'a9 paper dimension';
description 'Lookup the size of standard paper sizes';
name 'Paper';
code_url
    'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Paper.pm';
category 'conversions';
topics 'special_interest';
attribution github => 'loganom',
            twitter => 'loganmccamon',
            github => 'mattlehnig';


handle query_lc => sub {
    return unless my ($s, $l, $n) = $_ =~ /^((?:(a|b|c)(\d{0,2}))|legal|letter|junior\s*legal|ledger|tabloid|hagaki)\s+paper\s+(?:size|dimm?ensions?)$/i;
    if ($n){
        last if($n > 10);
    }
    my $key = $s;
    my $value;

    my %hash = (
        "letter" => "210mm x 279mm  (8.27in x 11in)",
        "legal" => "216mm x 356mm  (8.5in x 14in)",
        "junior legal" => "203mm x 127mm  (8in x 5in)",
        "ledger" => "432mm x 279mm  (17in x 11in)",
        "tabloid" => "279mm x 432mm  (11in x 17in)",
        "hagaki" => "100mm x 148mm  (3.94in x 5.83in)",
        "a0" => "841mm x 1189mm  (33.11in x 46.81in)",
        "a1" => "594mm x 841mm  (23.39in x 33.11in)",
        "a2" => "420mm x 594mm  (16.54in x 23.39in)",
        "a3" => "297mm x 420mm  (11.69in x 16.54in)",
        "a4" => "210mm x 297mm  (8.27in x 11.69in)",
        "a5" => "148mm x 210mm  (5.83in x 8.27in)",
        "a6" => "105mm x 148mm  (4.13in x 5.83in)",
        "a7" => "74mm x 105mm  (2.91in x 4.13in)",
        "a8" => "52mm x 74mm  (2.05in x 2.91in)",
        "a9" => "37mm x 52mm  (1.46in x 2.05in)",
        "a10" => "26mm x 37mm  (1.02in x 1.46in)",
        "b0" => "1000mm x 1414mm  (39.37in x 55.67in)",
        "b1" => "707mm x 1000mm  (27.83in x 39.37in)",
        "b2" => "500mm x 707mm  (19.69in x 27.83in)",
        "b3" => "353mm x 500mm  (13.90in x 19.69in)",
        "b4" => "250mm x 353mm  (9.84in x 13.90in)",
        "b5" => "176mm x 250mm  (6.93in x 9.84in)",
        "b6" => "125mm x 176mm  (4.92in x 6.93in)",
        "b7" => "88mm x 125mm  (3.46in x 4.92in)",
        "b8" => "62mm x 88mm  (2.44in x 3.46in)",
        "b9" => "44mm x 62mm  (1.73in x 2.44in)",
        "b10" => "31mm x 44mm  (1.22in x 1.73in)",
        "c0" => "917mm x 1297mm  (36.10in x 51.06in)",
        "c1" => "648mm x 917mm  (25.51in x 36.10in)",
        "c2" => "458mm x 648mm  (18.03in x 25.51in)",
        "c3" => "324mm x 458mm  (12.76in x 18.03in)",
        "c4" => "229mm x 324mm  (9.02in x 12.76in)",
        "c5" => "162mm x 229mm  (6.38in x 9.02in)",
        "c6" => "114mm x 162mm  (4.49in x 6.38in)",
        "c7" => "81mm x 114mm  (3.19in x 4.49in)",
        "c8" => "57mm x 81mm  (2.24in x 3.19in)",
        "c9" => "40mm x 57mm  (1.57in x 2.24in)",
        "c10" => "28mm x 40mm  (1.10in x 1.57in)"
    );

    $value = $hash{$key};

    return $value;

};

1;
