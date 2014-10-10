package DDG::Goodie::Hiragana;
# ABSTRACT: translates syllables into hiragana

use DDG::Goodie;

triggers startend =>'japanese hiragana','japanese','hiragana';
zci answer_type => 'hiragana';

zci is_cached => 1;
primary_example_queries "hiragana a";
description "Translates syllables into hiragana";
name "Hiragana";

code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Hiragana.pm';
attribution github => "mintsoft";

my %hiragana = (
    a => 'あ',     i => 'い',     u => 'う',     e => 'え',     o => 'お',
    ka => 'か',    ki => 'き',    ku => 'く',    ke => 'け',    ko => 'こ',
    sa => 'さ',    si => 'し',    su => 'す',    se => 'せ',    so => 'そ',
    ta => 'た',    ti => 'ち',    tu => 'つ',    te => 'て',    to => 'と',
    na => 'な',    ni => 'に',    nu => 'ぬ',    ne => 'ね',    no => 'の',
    ha => 'は',    hi => 'ひ',    hu => 'ふ',    he => 'へ',    ho => 'ほ',
    ma => 'ま',    mi => 'み',    mu => 'む',    me => 'め',    mo => 'も',
    ya => 'や',                   yu => 'ゆ',                   yo => 'よ',    
    ra => 'ら',    ri => 'り',    ru => 'る',    re => 'れ',    ro => 'ろ',    
    wa => 'わ',    wi => 'ゐ',                   we => 'ゑ',    wo => 'を',
    n => 'ん'
);

=for

        a   i   u   e   o
    ∅   あ  い  う  え  お
    k   か  き  く  け  こ
    s   さ  し  す  せ  そ
    t   た  ち  つ  て  と
    n   な  に  ぬ  ね  の
    h   は  ひ  ふ  へ  ほ
    m   ま  み  む  め  も
    y   や      ゆ      よ
    r   ら  り  る  れ  ろ
    w   わ  ゐ      ゑ  を
    ん (N)

=cut

handle remainder => sub {
    return $hiragana{lc $_} if defined $hiragana{lc $_};
};

1;