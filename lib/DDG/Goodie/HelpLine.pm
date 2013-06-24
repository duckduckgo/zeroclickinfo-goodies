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
    'US' => '1-800-273-TALK (8255)',
);

handle query_lc => sub {
    my $query = shift;
    return if grep {$query =~ /$_/} @skip_triggers;
    return "24 Hour Suicide Hotline: $helpline{$loc->country_code}"
        if exists $helpline{$loc->country_code};
};

1;
