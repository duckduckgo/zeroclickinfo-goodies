package DDG::Goodie::CCTLD;

use DDG::Goodie;

my %triggers = share('cctld.txt')->slurp;

triggers any => keys(%triggers);

zci answer_type => 'ccTLD';
zci is_cached => 1;

primary_example_queries '.us';
description 'Shows the country corresponding to a ccTLD.';
attribution github => ['https://github.com/ehsan', 'ehsan'];
            github => ['https://github.com/javathunderman', 'Thomas Denizou'];
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CCTLD.pm';
topics 'special_interest';
category 'special';
source 'https://en.wikipedia.org/wiki/List_of_Internet_top-level_domains';

handle query_lc => sub {
    return unless exists $triggers{"$_\n"};
    my $code = $_;
    my $country = $triggers{$code."\n"};
    $country =~ s/\n$//;
    my $country_wp = $country;
    $country_wp =~ s/ /_/g;

    my $text = "$code is the country code top-level domain for $country.";
    my $html = "<code>$code</code> is the <a href=\"https://en.wikipedia.org/wiki/Country_code_top-level_domain\">"
        . "country code top-level domain</a> for <a href=\"https://en.wikipedia.org/wiki/$country_wp\">$country</a>.";

    return ($text, html => $html);
};

1;
