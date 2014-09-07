package DDG::Goodie::Uppercase;
# ABSTRACT: uppercase a provided string.

use DDG::Goodie;

triggers start => 'uppercase', 'upper case', 'allcaps', 'all caps', 'strtoupper', 'toupper';
# leaving out 'uc' because of queries like "UC Berkley", etc
# 2014-08-10: triggers to "start"-only  to make it act more like a "command"
#   resolves issue with queries like "why do people type in all caps"

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
    $upper = html_enc($upper);
    
    my $html = qq(<div class="zci--uppercase"><span class="text--primary">$upper</span></div>);
    $html = append_css($html);

    return $text, html => $html;

    return;
};

1;
