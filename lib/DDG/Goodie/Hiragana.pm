package DDG::Goodie::Hiragana;
# ABSTRACT: converts romaji syllables into hiragana

use DDG::Goodie;
triggers startend =>'japanese hiragana','hiragana', 'hiragana japanese';
zci answer_type => 'hiragana';

zci is_cached => 1;

primary_example_queries "hiragana a";
secondary_example_queries "nihon hiragana";

description "Converts romaji syllables into hiragana";
name "Hiragana";

category "language";
topics "special_interest";

code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Hiragana.pm';
attribution github => ['https://github.com/mintsoft', 'Rob Emery'];

my %hiragana = (
    # gojuuon
    a => 'あ',     i => 'い',     u => 'う',     e => 'え',     o => 'お',
    ka => 'か',    ki => 'き',    ku => 'く',    ke => 'け',    ko => 'こ',
    sa => 'さ',    shi => 'し',   su => 'す',    se => 'せ',    so => 'そ',
    ta => 'た',    chi => 'ち',   tsu => 'つ',   te => 'て',    to => 'と',
    na => 'な',    ni => 'に',    nu => 'ぬ',    ne => 'ね',    no => 'の',
    ha => 'は',    hi => 'ひ',    hu => 'ふ',    he => 'へ',    ho => 'ほ',
    ma => 'ま',    mi => 'み',    mu => 'む',    me => 'め',    mo => 'も',
    ya => 'や',                   yu => 'ゆ',                   yo => 'よ',    
    ra => 'ら',    ri => 'り',    ru => 'る',    re => 'れ',    ro => 'ろ',    
    wa => 'わ',    wi => 'ゐ',                   we => 'ゑ',    wo => 'を',
    # yooon
    kya => 'きゃ',                kyu => 'きゅ',                kyo => 'きょ',
    sha => 'しゃ',                shu => 'しゅ',                sho => 'しゅ',
    cha => 'ちゃ',                chu => 'ちゅ',                cho => 'ちょ',
    nya => 'にゃ',                nyu => 'にゅ',                nyo =>'にょ',
    mya => 'みゃ',                myu => 'みゅ',                myo =>'みょ',
    rya => 'りゃ',                ryu => 'りゅ',                ryo =>'りょ',
    # gojuuon with dakuten
    ga => 'が',    gi => 'ぎ',    gu => 'ぐ',    ge => 'げ',    go => 'ご',
    za => 'ざ',    zi => 'じ',    zu => 'ず',    ze => 'ぜ',    zo => 'ぞ',
    da => 'だ',    ji => 'ぢ',    du => 'づ',    de => 'で',    do => 'ど',
    ba => 'ば',    bi => 'び',    bu => 'ぶ',    be => 'べ',    bo => 'ぼ',
    pa => 'ぱ',    pi => 'ぴ',    pu => 'ぷ',    pe => 'ぺ',    po => 'ぽ',
    # yooon with dakuten
    gya => 'ぎゃ',    gyu => 'ぎゅ',    gyo => 'ぎょ',
    ja  => 'じゃ',    ju  => 'じゅ',    jo  => 'じょ',
#    ja  => 'ぢゃ',    ju  => 'ぢゅ',    jo  => 'ぢょ',
    bya => 'びゃ',    byu => 'びゅ',    byo => 'びょ',
    pya => 'ぴゃ',    pyu => 'ぴゅ',    pyo => 'ぴょ',
    vu => 'ゔ',
    n => 'ん'
);

my @keys_in_replace_order = sort { length ($b) <=> length ($a) } keys %hiragana;

handle remainder => sub {
    my $output_string = $_;
    return unless $output_string;
    foreach my $syllable ( @keys_in_replace_order ) {
        $output_string =~ s/$syllable/$hiragana{$syllable}/gi;
    }
    
    #If there were unconvertable syllables, then it's not valid romaji
    return if $output_string =~ /[A-Za-z]/;
    utf8::decode($output_string);
    return $output_string, html => "<div class='zci--hiragana text--primary'>".html_enc($output_string)."</div>";
};

1;
