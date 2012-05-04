package DDG::Goodie::DuckDuckGo;
# ABSTRACT: Return hard-coded descriptions for DuckDuckGo terms

use DDG::Goodie;

my %data = (
    zeroclickinfo       => "Zero Click Info is the term DuckDuckGo uses for these boxes, which often provide useful instant answers above traditional results.",
    zeroclick           => \"zeroclickinfo",
    '0click'            => \"zeroclickinfo",
    '0clickinfo'        => \"zeroclickinfo",
    help                => "DuckDuckGo's help website: http://help.duckduckgo.com/",
    help_html           => "DuckDuckGo's help website: <a href='http://help.duckduckgo.com/'>http://help.duckduckgo.com/</a>",
);

triggers start => keys %data, qw/zero 0/;

zci is_cached => 1;

handle query_nowhitespace_nodash => sub {
    $_ = lc;
    s/\W//g;
    return unless exists $data{$_};
    my $answer = $data{$_};
    my $answerhtml = exists $data{"${_}_html"} ? $data{"${_}_html"} : 0;

    if (ref $answer eq 'SCALAR') {
        $answer = $data{$$answer};
        $answerhtml = exists $data{"${answer}_html"} ? $data{"${answer}_html"} : 0;
    }

    return $answer unless $answerhtml;
    return $answer, html => $answerhtml;
};

1;
