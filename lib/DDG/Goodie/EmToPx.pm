package DDG::Goodie::EmToPx;

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "conversion";
triggers any => "em", "px";

handle query_raw => sub {
    s/(?![\.\s])\W//g;
    return unless /^(?:convert|change|what\s*(?:s|is|are)\s+)?(\d+\.\d*|\d*\.\d+|\d+)\s*(em|px)\s+(?:in|to)\s+(em|px)(?:\s+(?:with|at|using|assuming)(?:\s+an?)?\s+(\d+\.\d*|\d*\.\d+|\d+)\s*px)?/i;
    my $target = lc($3);
    my $num = $1;
    my $source = lc($2);

    my $fontsize = ( defined $4 ) ? $4 : 16;

    my $result;
    $result = $num * $fontsize if $target eq 'px' && $source eq 'em';
    $result = $num / $fontsize if $target eq 'em' && $source eq 'px';
    my $plur = $result == 1 ? "is" : "are";

    return "There $plur $result $target in $num $source (assuming a ${fontsize}px font size)";
    return;
};

1;
