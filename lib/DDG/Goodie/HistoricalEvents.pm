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
    my $event_obj = $events->{$event};
    my $article = $event_obj->{article};
    foreach my $prefix ( keys %{$event_obj->{prefixes}} ) {
        if (defined $event_obj->{prefixes}->{$prefix}) {
            push @triggers, map {"$prefix $article $event $_"} @{$event_obj->{prefixes}->{$prefix}};
        }
        else {
            push @triggers, "$prefix $article $event";
        }
    }
};

triggers startend => @triggers;

handle remainder => sub {

    return if $_;

    my $query = $req->matched_trigger;

    my ($prefix, $article, $event, $post) = $query =~ m/^(is|was|did) (the|we) (.+?)(?: (real|true|(really |actually )?happen))?\??$/;
    my $link = $events->{$event}->{link};

    my $output = "$prefix $article $event";
    $output .= " $post" if $post;
    $output .= "?";

    return "Yes: $link",
        structured_answer => {

            data => {
                title => 'Yes',
                subtitle => $output,
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
