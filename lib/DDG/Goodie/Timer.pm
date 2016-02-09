package DDG::Goodie::Timer;
# ABSTRACT: Shows a countdown timer

use strict;
use DDG::Goodie;

zci answer_type => 'timer';
zci is_cached   => 1;

my @triggers = qw(timer countdown alarm);
# Triggers that are valid in start only
my @startTringgers = qw(start begin set run);
# Beautifies the trigger can be appended in front/back of trigger
my @beautifierTringgers = qw(online);
#Joins the Timer Value
my @joiners = qw(for on at with);
# StartEndTriggers to trigger on startTringgers, beautifierTringgers and triggers
my @triggersStartEnd = (@triggers, @startTringgers, @beautifierTringgers);

triggers startend => @triggersStartEnd;

sub build_result {
    return '',
        structured_answer => {
            id     =>  'timer',
            name   => 'Timer',
            signal => 'high',
            meta => {
                sourceName => 'Timer',
                itemType   => 'timer',
            },
            templates => {
                detail      => 'DDH.timer.timer_wrapper',
                wrap_detail => 'base_detail',
            },
        };
}

handle remainder => sub {
    my $qry = $_;
    my $raw = lc($req->query_raw);
    my $trgx = join('|', @triggers);
    my $stTrgx = join('|', @startTringgers);
    my $stTrgxSize = @startTringgers;
    my $btfrTrgx = join('|', @beautifierTringgers);
    my $btfrTrgxSize = @beautifierTringgers;
    my $joinTrgx = join('|', @joiners);
    my $btfrTrigStart = $btfrTrgx.'|'.$stTrgx;
    my $btfrTrigSize = $stTrgxSize+$btfrTrgxSize;

    # Verify that the trigger words are wrapped with whitespace or that
    # the trigger is at the start or end of the string with white space
    # on either side of it. This prevents triggering on queries such as
    # "countdown.js", "timer.x", "five-alarm", etc
    if($raw !~ /(^|\s)($trgx)(\s|$)/i) {
        return;
    }

    # When the query is empty and we know that the trigger word matches
    # the trigger exactly (whitespace check) we can return a valid result
    if($qry eq '') {
        return build_result();
    }

    # Trim both sides of the raw query to have the raw regex work
    # properly. Since we need to make sure /^<trigger> for $/ doesn't
    # trigger. Additionally trims down the start triggers
    # <startTringgers> <specific time> <beautifierTringgers> <trigger> ------------- start 10 minute online timer
    # <startTringgers> <trigger> <beautifierTringgers> <specific time> ------------- begin timer online 10 minutes
    # <startTringgers> <trigger> <beautifierTringgers> <joiners> <specific time> --- set timer online for 10 min
    $raw =~ s/^\s*(\b(\s*($btfrTrigStart)\s*)\b){1,$btfrTrigSize}\s*//;
    $raw =~ s/\s*($btfrTrgx)\s*$//;

    # Parse the raw query to remove common terms. This allows us to
    # catch the more specific queries and handle them. We also strip
    # the extra bounding whitespace. The trigger is
    # set to startend, causing "online timer for ..." to trigger.
    #
    #
    # Note: Beautifiers surrounds the triggers and joiners connect it to the value
    #
    # Matches on...
    # <specific time> <beautifierTringgers> <trigger> ------------------------------ 10 minute online timer
    # <trigger> <beautifierTringgers> <specific time> ------------------------------ timer online 10 minutes
    # <trigger> <beautifierTringgers> <joiners> <specific time> -------------------- timer online for 10 min
    # <specific time> <trigger> <beautifierTringgers> ------------------------------ 10 minute timer online
    # <startTringgers> <beautifierTringgers> <trigger> <specific time> ------------- online timer 10 minutes
    # <beautifierTringgers> <trigger> <joiners> <specific time> -------------------- online timer for 10 min
    # <specific time> <beautifierTringgers> <trigger> ------------------------------ 10 minute online countdown timer
    # <trigger> <beautifierTringgers> <specific time> ------------------------------ timer alarm online 10 minutes
    # <trigger> <beautifierTringgers> <joiners> <specific time> -------------------- alarm timer online at 10 min
    # <specific time> <trigger> <beautifierTringgers> ------------------------------ 10 minute countdown timer online
    # <startTringgers> <beautifierTringgers> <trigger> <specific time> ------------- online countdown alarm 10 minutes
    # <beautifierTringgers> <trigger> <joiners> <specific time> -------------------- online timer with 10 min
    $raw =~ s/\s*($btfrTrgx\s*)?(\b(\s*($trgx)\s*)\b)($btfrTrgx)?\s*($joinTrgx)?\s*//ig;

    if($raw eq '') {
        return build_result();
    }elsif($raw =~ /^(\s?([\d.]+ ?(m(in((ute)?s?)?)?|s(ec((ond)?s?)?)?|h(ours?)?|hr))\s?)+$/) {
        return build_result();
    }elsif($raw =~ /^( ?((\d{1,2}:)?\d{1,2}:\d{2}) ?)/) {
        return build_result();
    }
    return;
};

1;
