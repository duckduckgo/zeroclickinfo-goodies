package DDG::Goodie::EmToPx;

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "conversion";
triggers end => "em", "px";

handle query_parts => sub {
    my $target = lc($_[-1]);
    my $num = $_[0];

    my @lt = split(//,$num);
    my $source = ($num =~ /(px|em)$/i) ? lc(join('',@lt[-2,-1])) : lc($_[1]);
    $num =~ s/(em|px)//gi;
    return unless join(' ', @_) =~ /^(\d+[.]\d*|\d*[.]\d+|\d+)\s*(em|px)\s+(in|to)\s+(em|px)$/i;
    return unless $num && $target && $source;

    my $result;
    $result = $num * 16 if $target eq 'px' && $source eq 'em';
    $result = $num / 16 if $target eq 'em' && $source eq 'px';

    return "$result $target in $num $source" if $result;
    return;
};

1;
