#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_juarezpaf";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::juarezpaf )],
    'duckduckhack juarezpaf' => test_zci(html=>"<div class='zci_main'>" .
                                         "<div class='zci__img-wrap'><a href='http://twitter.com/juarezpaf'><img class='zci__img' src='https://pbs.twimg.com/profile_images/511615958297747456/dLEI9Ioo.jpeg'></a></div>".
                                         "<div class='zci__body'>".
                                         "<h1 class='zci__header has-sub'>Juarez Filho <span class='zci__header__sub'>completed DuckDuckHack Goodie tutorial</span></h1>".
                                         "<div class='zci__content'>A enthusiastic Front end Engineer with over 7 years of experience, started his career as PHP Developer, he tried to learn Java and after surrendered to Ruby and Rails but with his first CSS class he devoted completly to Front End and UX. Worked with several Startups, including Eadbox, Amanaie, Enjoei and recently Gabstr Inc.</div>".
                                         "<div class='zci__links'><a href='http://linkedin.com/in/juarezpaf' class='zci__more-at--info'>More at Linkedin</a></div>".
                                         "</div>".
                                         "</div>"),
    'duckduckhack juarezpaf is awesome' => undef,
);

done_testing;
