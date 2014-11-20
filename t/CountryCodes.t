#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => "country_codes";
zci is_cached   => 1;

my $text = '</div><div class="zci__subheader">ISO 3166 Country code for';

ddg_goodie_test(
        [ 'DDG::Goodie::CountryCodes' ],
        "country code Japan"                     => test_zci(qq(ISO 3166: Japan - jp),  html => qq(<div class="zci__caption">jp$text Japan</div>)),
        "3 letter country code Japan"            => test_zci(qq(ISO 3166: Japan - jpn), html => qq(<div class="zci__caption">jpn$text Japan</div>)),
        "3 letter country code of China"         => test_zci(qq(ISO 3166: China - chn), html => qq(<div class="zci__caption">chn$text China</div>)),
        "Japan 3 letter country code"            => test_zci(qq(ISO 3166: Japan - jpn), html => qq(<div class="zci__caption">jpn$text Japan</div>)),
        "Russia two letter country code"         => test_zci(qq(ISO 3166: Russia - ru), html => qq(<div class="zci__caption">ru$text Russia</div>)),
        "two letter country code Japan"          => test_zci(qq(ISO 3166: Japan - jp),  html => qq(<div class="zci__caption">jp$text Japan</div>)),
        "three letter country code for Japan"    => test_zci(qq(ISO 3166: Japan - jpn), html => qq(<div class="zci__caption">jpn$text Japan</div>)),
        "numerical iso code japan"               => test_zci(qq(ISO 3166: Japan - 392), html => qq(<div class="zci__caption">392$text Japan</div>)),
        "iso code for spain"                     => test_zci(qq(ISO 3166: Spain - es),  html => qq(<div class="zci__caption">es$text Spain</div>)),
        "country code jp"                        => test_zci(qq(ISO 3166: Japan - jp),  html => qq(<div class="zci__caption">jp$text Japan</div>)),
        "japan numerical iso 3166"               => test_zci(qq(ISO 3166: Japan - 392), html => qq(<div class="zci__caption">392$text Japan</div>)),
        "united states of america iso code"      => test_zci(qq(ISO 3166: United states of america - us), html => qq(<div class="zci__caption">us$text United states of america</div>)),
        "3 letter iso code isle of man"          => test_zci(qq(ISO 3166: Isle of man - imn), html => qq(<div class="zci__caption">imn$text Isle of man</div>)),
        'country code for gelgamek' => undef,
        'iso code for english'     => undef,
);

done_testing;
