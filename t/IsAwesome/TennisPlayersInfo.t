#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_tennis_players_info";
zci is_cached   => 1;
my $FedReturn = "Born: August 8, 1981 (age 33), Basel, Switzerland \n
                Grand slams won (singles): 17 \n
                Height: 1.85 m \n
                Spouse: Mirka Federer (m. 2009) \n
                Children: Myla Rose Federer, Leo Federer, Charlene Riva Federer, Lenny Federer \n
                Parents: Lynette Federer, Robert Federer \n";
                
my $DjoReturn = "Born: May 22, 1987 (age 27), Belgrade, Serbia";                


ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::TennisPlayersInfo
    )],
        'roger federer' => test_zci("$FedReturn"),
        'federer'       => test_zci("$FedReturn"),
        'roger'         => test_zci("$FedReturn"),

        'novak'         => test_zci("$DjoReturn"),
        'novak djokovic'=> test_zci("$DjoReturn"),
        'djokovic'      => test_zci("$DjoReturn"),
    
);

done_testing;
