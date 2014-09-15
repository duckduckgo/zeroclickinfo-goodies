package DDG::Goodie::TwelveOclock;
# ABSTRACT: Determine whether 12:00 is midnight or noon.

use DDG::Goodie;

primary_example_queries "is 12:00am noon?", "is 1200pm midnight?";
description "Succinct explanation of what this instant answer does";
name "TwelveOclock";
code_url "https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Spice/TwelveOclock.pm";
category "reference";
topics "everyday";
attribution github => ['https://github.com/duckduckgo', 'duckduckgo'];

# Triggers
triggers any => "midnight", "noon";

my $twelve_oclock_re = qr/\b12(?:00|:00)?\s?(?<mer>[ap]m)\b/;
my %answers          = (
    am => 'midnight',
    pm => 'noon',
);

# Handle statement
handle query => sub {
    my $query = lc shift;

    $query =~ s/\.//g;    # Strip any dots.
    return unless ($query =~ $twelve_oclock_re);
    my $meridian = $+{'mer'};
    my $answer   = $answers{$meridian};
    return unless $answer;

    my $noon     = ($query =~ qr/\bnoon\b/);
    my $midnight = ($query =~ qr/\bmidnight\b/);

    my $guess = ($noon && !$midnight) ? 'noon' : ($midnight && !$noon) ? 'midnight' : '';
    my $guess_status = (!$guess) ? '' : ($guess eq $answer) ? 'Yes. ' : 'No. ';

    return $guess_status . '12:00' . $meridian . ' is ' . $answer . '.';
};

1;
