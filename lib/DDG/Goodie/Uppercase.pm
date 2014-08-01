package DDG::Goodie::Uppercase;
use DDG::Goodie;

use HTML::Entities;

triggers startend => 'uppercase', 'upper case', 'allcaps', 'all caps', 'strtoupper', 'toupper';
# leaving out 'uc' because of queries like "UC Berkley", etc

zci is_cached => 1;
zci answer_type => "uppercase";

primary_example_queries   'uppercase this';
secondary_example_queries 'upper case that';

name        'Uppercase';
description 'Make a string uppercase.';
code_url    'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Uppercase.pm';
category    'conversions';
topics      'programming';

attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC' ;

my $css = share("style.css")->slurp();
sub append_css {
    my $html = shift;
    return "<style type='text/css'>$css</style>\n" . $html;
};

handle remainder => sub {
    return unless $_;
    my $upper = uc $_;
    my $text = $upper;
    
    # Encode the variable before putting it in HTML.
    # There's no need to encode the $text variable because that gets encoded internally.
    $upper = encode_entities($upper);
    
    my $html = qq(<div class="zci--uppercase"><span class="text--primary">$upper</span></div>);
    $html = append_css($html);

    return $text, html => $html;

    return;
};

1;