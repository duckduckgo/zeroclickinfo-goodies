package DDG::Goodie::Igem::Cat;
# ABSTRACT: Provide a list of the categories of biological parts
# present in the Registry of Standard Biological Parts http://parts.igem.org/Main_Page
# These categories an be used in the Igem Spice instant answers

use strict;
use DDG::Goodie;

zci answer_type => "igem_cat";
zci is_cached   => 1;

name "Igem Cat";
description "List the categories of http://parts.igem.org/Main_Page";
primary_example_queries "igem cat", "igemcat";
category "special";
topics "science", "special_interest";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Igem/Cat.pm";
attribution github => ["https://github.com/mcavallaro", "Massimo Cavallaro"];

triggers startend => "igemcat", "igem cat","igem categories";

my $HTML = share('igem_cat.html')->slurp(iomode => "<:encoding(UTF-8)");

handle remainder => sub {
    return 
        heading => 'iGem category list',
        html    => $HTML,
};

1;
