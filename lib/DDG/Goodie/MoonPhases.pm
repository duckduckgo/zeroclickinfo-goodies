package DDG::Goodie::MoonPhases;

use DDG::Goodie;
use Astro::MoonPhase;

primary_example_queries "lunar phase";

secondary_example_queries
    "moon phase",
    "phase of the moon",
    "what is the current lunar phase";

description  "Lunar phase";

name "MoonPhases";

topics "special_interest", "everyday";

category "random";

attribution
    github => ['https://github.com/rpicard', 'rpicard'],
    twitter => ['https://twitter.com/__rlp', '__rlp'],
    web => ['http://robert.io', 'Robert Picard'];


triggers any => 'moon', 'lunar';

my %triggerQueries = (
    'moon phase' => 1,
    'lunar phase' => 1,
    'phase of the moon' => 1,
    'current moon phase' => 1,
    'current phase of the moon' => 1,
    'what is the phase of the moon' => 1,
    'whats the phase of the moon' => 1,
    'what is the current phase of the moon' => 1,
    'whats the current phase of them moon' => 1,
    'current lunar phase' => 1,
    'whats the lunar phase' => 1,
    'what is the lunar phase' => 1,
    'whats the current lunar phase' => 1,
    'what is the current lunar phase' => 1,
    'what phase is the moon in' => 1,
    'what lunar phase is the moon in' => 1,
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
    
    return "The current lunar phase is: $phase", html => qq(The current lunar phase is: <a href="?q=$phaseUrl">$phase</a>);
};

zci is_cached => 0;

1;
