package DDG::Goodie::SigFigs;
# ABSTRACT: Count the significant figures in a number.

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

triggers any => 'sigfigs', 'sig figs', 'significant';

zci answer_type => "sig_figs";
zci is_cached => 1;

sub get_sig_figs {
    my $num = shift;
    # Leading digits NEVER contribute towards significant figures.
    my $int_part = $num->integer_part;
    $int_part =~ s/^0+//;
    my $frac_part = $num->fractional_part;
    my $sigfigs = length $int_part;
    if (defined $frac_part) {
        # Leading zeros after decimal point aren't significant if there
        # was no integer part or the integer part consisted of only zeros.
        $frac_part =~ s/^0+// if $sigfigs == 0;
        return $sigfigs + length $frac_part;
    };
    # This isn't necessarily correct - significant figures can be
    # ambiguous when not using scientific notation.
    $int_part =~ s/0+$// unless $num->_has_decimal;
    return length $int_part;
}

handle query_raw => sub {
    my $query = $_;
    my $style = number_style_for($lang) or return;
    $query =~ s/.*?(sig(nificant)? ?(fig(ure)?|digit)s)[^,.\d]*+//i;
    return if $query eq '';
    my $number_re = $style->number_regex();
    $query =~ /^($number_re)\??$/ or return;
    my $number_match = $1;
    my $number = $style->parse_number($number_match);
    my $formatted_input = $number->formatted_raw();
    my $sigfigs = get_sig_figs $number;
    return unless defined $sigfigs;

    return $sigfigs, structured_answer => {
        data => {
            title    => "$sigfigs",
            subtitle => "Number of Significant Figures in $formatted_input",
        },
        templates => {
            group  => 'text',
            moreAt => 0,
        },
    };
};
1;
