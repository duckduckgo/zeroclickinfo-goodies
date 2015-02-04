package DDG::Goodie::Bmi;
# ABSTRACT: A bmi calculator
# 
use DDG::Goodie;

zci answer_type => "bmi";
zci is_cached   => 1;

name "Bmi";
description "Pops a bmi calculator";
primary_example_queries "bmi";
category "calculations";
topics "special_interest", "everyday";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Bmi.pm";
attribution github => ["jrenouard", "Julien Renouard"],
            twitter => "jurenouard";

triggers start => "bmi";

my $text = scalar share('bmi.txt')->slurp,
my $html = scalar share('bmi.html')->slurp;

handle sub {
    $text, html => $html;
};

1;
