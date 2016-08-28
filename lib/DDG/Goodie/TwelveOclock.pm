package DDG::Goodie::TwelveOclock;
# ABSTRACT: Determine whether 12:00 is midnight or noon.

use strict;
use DDG::Goodie;

zci answer_type => "twelve_oclock";
zci is_cached   => 1;

# Triggers
triggers any => "midnight", "noon";

# 12am; 12:00PM; when is noon?; when is midnight
my $question_re = qr/(?:\b12(?:00|:00)?\s?(?<mer>[ap]m)\b|^when is (?<q>noon|midnight)\??$)/;
my %answers     = (
    am => 'midnight',
    pm => 'noon',
);
%answers = (%answers, reverse %answers);    # Point both ways to answer either direction.

# Handle statement
handle query => sub {
    my $query = lc shift;

    $query =~ s/\.//g;    # Strip any dots.
    return unless ($query =~ $question_re);
    my $included_mer = $+{'mer'};
    my $meridian     = $included_mer || $answers{$+{'q'}};    # No included meridian implies straight-forward question.
    my $to_show      = $answers{$meridian};
    return unless $to_show;

    my $guess_result = '';
    if ($included_mer) {
        # If they included a meridian with their 12 o'clock, we need to figure out if they were guessing.
        my $noon     = ($query =~ qr/\bnoon\b/);
        my $midnight = ($query =~ qr/\bmidnight\b/);

        # It's only a guess if they mention only one or the other.
        my $guess = ($noon && !$midnight) ? 'noon' : ($midnight && !$noon) ? 'midnight' : '';
        # If they guessed, we need to answer the question they asked.
        $guess_result = (!$guess) ? '' : ($guess eq $to_show) ? 'Yes, ' : 'No, ';
    }

    my $answer = "${guess_result}12:00$meridian is $to_show";

    return $answer, structured_answer => {
		data => {
			title => $answer,
			subtitle => 'Midnight or noon'
		},
		templates => {
			group => 'text'
		}
    };
};


1;
