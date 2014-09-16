package DDG::Goodie::UltimateAnswer;
# ABSTRACT: A Hitchhiker's Guide to the Galaxy easter egg.

use DDG::Goodie;
triggers start => 'what is the ultimate answer', 'what is the ultimate answer to life the universe and everything', 'what is the answer to the ultimate question of life the universe and everything';                                                                                                                                                            
primary_example_queries 'what is the answer to the ultimate question of life the universe and everything';                   

                                                                                                           
name 'Ultimate Answer';
description 'Hichhiker\'s Guide to the Galaxy reference.';
category 'special';
topics 'entertainment';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/UltimateAnswer.pm';
attribution github  => ['https://github.com/jfeeneywm/', 'jfeeneywm'],               
            twitter => ['https://twitter.com/jfeeneywm', 'jfeeneywm'];

zci answer_type => 'UltimateAnswer';

handle remainder => sub {
    return unless ($_ eq '' || $_ eq '?');
    return 'Forty-two', html => '<span class="zci--ultanswer">Forty-two</span>';

};
1;
