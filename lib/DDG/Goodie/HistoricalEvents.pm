package DDG::Goodie::HistoricalEvents;

use strict;
use warnings;
use DDG::Goodie;
use YAML::XS 'LoadFile';

zci answer_type => 'historical_events';

zci is_cached => 1;

my $events = LoadFile(share('events.yml'));

my %queries;

# build query/answer hash by iterating over events YAML
foreach my $event ( keys %$events ) {
    my $event_obj = $events->{$event};
    my $link = $event_obj->{link};

    while ( my($query, $answer) = each %{$event_obj->{queries}} ) {
        if ($query =~ m/_event_/) {
            # replace _event_ with $article $event
            my $article = $event_obj->{article};
            $query =~ s/_event_/$article $event/;
            $answer =~ s/_event_/$article $event/;
            $queries{lc $query} = {
                link => $link,
                answer => $answer
            };
            # additional trigger without '$article ' for triggering flexibiilty
            $query =~ s/$article //;
            $queries{lc $query} = {
                link => $link,
                answer => $answer
            };
        }
        else {
            $queries{$query} = {
                link => $link,
                answer => $answer
            };
        }
    }
};

my @triggers = map { ("$_", "$_?") } keys %queries;

triggers start => @triggers;

handle remainder_lc => sub {

    # ensure no remainder, query == trigger
    return if $_;

    my $query = lc $req->matched_trigger;
    $query =~ s/\?//;
    my $answer = $queries{$query}{answer};
    my $link = $queries{$query}{link};

    return "Yes, $answer: $link",
        structured_answer => {

            data => {
                title => 'Yes',
                subtitle => $answer,
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
