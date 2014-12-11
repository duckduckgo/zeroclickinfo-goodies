#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => "sales_tax";
zci is_cached   => 1;

my $text = '</div><div class="zci__subheader">"Sales tax percent for"';

ddg_goodie_test(
        [ 'DDG::Goodie::SalesTax' ],
        "sales tax for Alaska"                     => test_zci(
            
            structured_answer => {
                input => ['Alaska'],
                operation => 'Sales tax per state',
                result => "0%"
            }
        )
        
);
done_testing;
