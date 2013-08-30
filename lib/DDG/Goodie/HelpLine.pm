package DDG::Goodie::HelpLine;

use DDG::Goodie;

my @triggers = (
    'suicide',
    'kill myself',
    'suicidal thoughts',
    'end my life',
);

my @skip_triggers = (
    'lyrics',
);

triggers any => @triggers;

zci answer_type => 'helpline';

primary_example_queries 'suicide hotline';
description 'Checks if a query with the word "suicide" was made in the U.S. and returns a 24 hr suicide hotline.';
attribution github => ['https://github.com/conorfl', 'conorfl'],
twitter => '@areuhappylucia';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Helpline.pm';
topics 'everyday';
category 'special';

my %helpline = (
    AU => '08 9381 5555',
    BE => '02/6499555',
    CN => '(852) 2896 0000',
    CY => '77777267',
    ES => '902 88 35 35',
    FR => '01 46 21 46 46',
    GB => '0 987 654 3210',
    HU => '06 80 820 111',
    IN => '04 42 464 0050',
    IT => '800 860022',
    KE => '(020) 205 1323',
    LT => '8 800 2 8888',
    MY => '607 331 2300',
    NO => '00 47 815 33 300',
    NZ => '06 368 3096',
    PT => '00 351 225 50 60 70',
    SE => '(46) (0) 31 711 24 00',
    SG => '1 800 221 4444',
    TH => '27136793',
    US => '1-800-273-TALK (8255)',
);

handle query_lc => sub {
    my $query = shift;
    return if grep {$query =~ /$_/} @skip_triggers;
    return "24 Hour Suicide Hotline: $helpline{$loc->country_code}"
        if exists $helpline{$loc->country_code};
};

1;
