package DDG::Goodie::Lowercase;
# ABSTRACT: Convert a string into lowercase.

use DDG::Goodie;

name "Lowercase";
description "Convert a string into lowercase.";
primary_example_queries "lowercase GitHub";
secondary_example_queries "lower case GitHub";
category 'conversions';
topics 'programming';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Lowercase.pm';
attribution github  => ["DavidMascio"];

zci is_cached => 1;
zci answer_type => "lowercase";

triggers start => 'lowercase', 'lower case', 'lc', 'strtolower', 'tolower';

my $css = share("style.css")->slurp();
sub append_css {
    my $html = shift;
    return "<style type='text/css'>$css</style>\n" . $html;
};

handle remainder => sub {
    return unless $_;
    my $lower = lc $_;
    my $text = $lower;
    
    # Encode the variable before putting it in HTML.
    # There's no need to encode the $text variable because that gets encoded internally.
    $lower = html_enc($lower);
    
    my $html = qq(<div class="zci--lowercase"><span class="text--primary">$lower</span></div>);
    $html = append_css($html);

    return $text, html => $html;

    return;
};

1;
