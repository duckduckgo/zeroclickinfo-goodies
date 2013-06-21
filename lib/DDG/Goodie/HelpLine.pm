package DDG::Goodie::Helpline;

use DDG::Goodie;

triggers any => 'suicide';
zci answer_type => 'helpline';

primary_example_queries 'suicide hotline';
description 'Checks if a query with the word "suicide" was made in the U.S. and returns a 24 hr suicide hotline.';
attribution github => ['https://github.com/conorfl', 'conorfl'],
twitter => '@areuhappylucia';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Helpline.pm';
topics 'everyday';
category 'assistance';

handle remainder => sub {
    if($loc->country_code eq "US"){
        return "24 Hour Suicide Hotline: 1-800-273-TALK (8255)"
    }
    return;
};

1;