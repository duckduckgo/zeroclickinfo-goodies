package DDG::Goodie::SigFigs;
# ABSTRACT: Count the significant figures in a number.

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

triggers start => 'sigfigs', 'sigdigs', 'sf', 'sd', 'significant';

zci answer_type => "sig_figs";
zci is_cached => 1;

sub get_sig_figs {
    my $num = shift;
    $num =~ s/^[-+]+//;
    # Leading digits NEVER contribute towards significant figures.
    $num =~ s/^0+//;
    $num =~ /^(?<int_part>\d*+)(\.(?<frac_part>\d*))?$/;
    my $int_part  = $+{'int_part'};
    my $frac_part = $+{'frac_part'};
    my $sigfigs = length $int_part;
    if (defined $frac_part) {
        # Leading zeros after decimal point aren't significant if there
        # was no integer part or the integer part consisted of only zeros.
        $frac_part =~ s/^0+// if $sigfigs == 0;
        return $sigfigs + length $frac_part;
    };
    # This isn't necessarily correct - significant figures can be
    # ambiguous when not using scientific notation.
    $int_part =~ s/0+$//;
    return length $int_part;
}

handle remainder => sub {
    my $query = $_;
    $query =~ s/^(figures|digits)\s*//i;
    $query =~ s/^of\s*//i;
    return if $query eq '';
    my $style = number_style_for($query);
    return unless $style;
    my $formatted_input = $style->for_display($query);
    my $to_compute = $style->for_computation($query);
    my $sigfigs = get_sig_figs $to_compute;
    return unless defined $sigfigs;

    return $sigfigs, structured_answer => {
        id   => 'sig_figs',
        name => 'Answer',
        data => {
            title    => "$sigfigs",
            subtitle => "Significant figures of $formatted_input",
        },
        templates => {
            group  => 'text',
            moreAt => 0,
        },
    };
};
1;
