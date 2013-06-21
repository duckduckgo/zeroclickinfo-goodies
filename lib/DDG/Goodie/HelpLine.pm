package DDG::Goodie::HelpLine;

use DDG::Goodie;

triggers any => 'suicide';
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

handle remainder => sub {
    return "24 Hour Suicide Hotline: $helpline{$loc->country_code}"
        if exists $helpline{$loc->country_code};
};

1;
