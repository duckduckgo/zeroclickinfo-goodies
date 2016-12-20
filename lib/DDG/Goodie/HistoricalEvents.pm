package DDG::Goodie::HistoricalEvents;

use strict;
use warnings;
use DDG::Goodie;
use YAML::XS 'LoadFile';

zci answer_type => 'historical_events';

zci is_cached => 1;

my $events = LoadFile(share('events.yml'));

my @triggers;

# build triggers array by mapping query suffixes to prefixes
foreach my $event ( keys %$events ) {
    my @suffix = map { "the $event $_" } qw(real true);
    push @triggers, map { ("is $_"), ("was $_") } @suffix;

    @suffix = map { "the $event $_" } ("happen", "really happen", "actually happen");
    push @triggers, map { "did $_" } @suffix;
};

triggers startend => @triggers;

handle remainder => sub {

    return if $_;

    my $query = $req->matched_trigger;

    my ($pre, $event, $post) = $query =~ m/^(is|was|did) the (.+?) (real|true|(really |actually )?happen)\??$/;
    my $link = $events->{$event}->{link};

    ($pre, $event) = map { ucfirst } ($pre, $event);

    return "Yes: $link",
        structured_answer => {

            data => {
                title => 'Yes',
                subtitle => "$pre the $event $post?",
                url => $link
            },
            meta => {
                sourceUrl => $link,
                sourceName => "Wikipedia"
            },
            templates => {
                group => 'info'
            }
        };
};

1;
