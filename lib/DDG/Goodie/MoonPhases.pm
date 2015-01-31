package DDG::Goodie::MoonPhases;
# ABSTRACT: answer queries for the current phase of the moon.

use DDG::Goodie;
use Astro::MoonPhase;

zci answer_type => 'moon_phase';
zci is_cached   => 0;

primary_example_queries "lunar phase";
secondary_example_queries "moon phase", "phase of the moon", "what is the current lunar phase";
description "Lunar phase";
name "MoonPhases";
topics "special_interest", "everyday";
category "random";

attribution github  => ['rpicard', 'Robert Picard'],
            twitter => ['__rlp', 'Robert Picard'],
            web     => ['http://robert.io', 'Robert Picard'];


triggers any => 'moon', 'lunar';

my %triggerQueries = map { $_ => 1 } (
    'moon phase',
    'lunar phase',
    'phase of the moon',
    'current moon phase',
    'current phase of the moon',
    'what is the phase of the moon',
    'whats the phase of the moon',
    'what is the current phase of the moon',
    'whats the current phase of them moon',
    'current lunar phase',
    'whats the lunar phase',
    'what is the lunar phase',
    'whats the current lunar phase',
    'what is the current lunar phase',
    'what phase is the moon in',
    'what lunar phase is the moon in',
);

handle query_lc => sub {

    # Make sure the query is on the list
    my $queryStripped = $_;
    $queryStripped =~ s/[^a-zA-z\s]//g;

    return unless exists $triggerQueries{$queryStripped};

    # Get the phase angle
    my $phaseAngle = int(phase() * 100);

    # Figure out what phase the moon is in from the phase angle
    my $phase;

    $phase = 'Waxing Crescent' if $phaseAngle > 0 && $phaseAngle < 25;
    $phase = 'Waxing Gibbous' if $phaseAngle > 25 && $phaseAngle < 50;
    $phase = 'Waning Gibbous' if $phaseAngle > 50 && $phaseAngle <75;
    $phase = 'Waning Crescent' if $phaseAngle > 75 && $phaseAngle < 100;
    $phase = 'New Moon' if $phaseAngle == 0 || $phaseAngle == 100;
    $phase = 'First Quarter' if $phaseAngle == 25;
    $phase = 'Full Moon' if $phaseAngle == 50;
    $phase = 'Third Quarter' if $phaseAngle == 75;

    my $phaseUrl = $phase;
    $phaseUrl =~ s/\s+/+/g;

    return "The current lunar phase is: $phase",
      structured_answer => {
        input     => [],
        result    => $phase,
        operation => 'Current lunar phase'
      };
};


1;
