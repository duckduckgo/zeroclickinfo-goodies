package DDG::Goodie::Timer;
# ABSTRACT: Shows a countdown timer

use strict;
use DDG::Goodie;

zci answer_type => 'timer';
zci is_cached   => 1;

my @triggers = ('timer', 'countdown', 'count down', 'alarm', 'reminder');
# Triggers that are valid, but not stripped from the resulting query
my @nonStrippedTriggers = qw(minutes mins seconds secs hours hrs);
# Triggers that are valid in start only
my @baseTriggers = qw(start begin set run);
my @startTriggers = ();
# creates 'start a', 'begin a'
map { push(@startTriggers, "$_ a") } @baseTriggers; 
push(@startTriggers, @baseTriggers);

# Beautifies the trigger can be appended in front/back of trigger
my @beautifierTriggers = qw(online);
#Joins the Timer Value
my @joiners = qw(for on at to with of);
# StartEndTriggers to trigger on nonStrippedTriggers, startTriggers, beautifierTriggers and triggers
my @triggersStartEnd = (@triggers, @nonStrippedTriggers, @startTriggers, @beautifierTriggers);
# Ambigous triggers which should not give Timer IA
my @ambigousTriggers = ("20 minutes", "22 minutes", "60 minutes", "48 hours");

triggers startend => @triggersStartEnd;

my $MAX_TIME = 359999; # 99 hrs 59 mins 59 secs

# Get Goodie version for use with image paths
my $goodieVersion = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;

sub normalize_time_format {
    my $time = shift;
    $time =~ /(?:(?<h>\d{1,2}):)?(?<min>\d{1,2}):(?<sec>\d{2})/;
    my $min_sec = $+{min} . 'min ' . $+{sec} . 'sec';
    return (defined $+{h} ? $+{h} . 'h ' : '') . $min_sec;
}

sub parse_query_for_time {
    my $query = shift;
    $query =~ s/^\s*//;
    $query =~ s/(timer|online)\s*//gi;
    $query =~ s/(?!\a)s/sec/i;
    $query =~ s/(?!\a)m/min/i;
    $query =~ s/(?!\a)h/hrs/i;
    my $timer_re = qr/(?<val>[\d]+\.?[\d]*) ?(?<unit>min|sec|h)/;
    my $time = 0;
    my ($match, $val, $unit);
    $query = normalize_time_format $query if $query =~ /:/;
    while ($query =~ $timer_re) {
        $val = $+{val};
        $unit = $+{unit};
        if ($unit eq 'h') {
            $time += $val * 3600;
        } elsif ($unit eq 'min') {
            $time += $val * 60;
        } elsif ($unit eq 'sec') {
            $time += $val;
        }
        $query =~ s/$timer_re//;
    }
    return ($time <= $MAX_TIME) ? $time : $MAX_TIME;
}

sub build_result {
    my $req = shift;
    my $time = parse_query_for_time($req->query_lc);
    return "$time",
        structured_answer => {
            id     =>  'timer',
            name   => 'Timer',
            signal => 'high',
            meta => {
                sourceName => 'Timer',
                itemType   => 'timer',
            },
            data => {
                time => "$time",
                goodie_version => $goodieVersion
            },
            templates => {
                group       => 'base',
                detail      => 'DDH.timer.timer_wrapper',
                wrap_detail => 'base_detail',
            },
        };
}

handle remainder => sub {
    my $qry = $_;
    my $raw = $req->query_lc;
    my $trgx = join('|', @triggers);
    my $nonStrpTrgx = join('|', @nonStrippedTriggers);
    my $ambTrgx = join('|', @ambigousTriggers);
    my $stTrgx = join('|', @startTriggers);
    my $stTrgxSize = @startTriggers;
    my $btfrTrgx = join('|', @beautifierTriggers);
    my $btfrTrgxSize = @beautifierTriggers;
    my $joinTrgx = join('|', @joiners);
    my $btfrTrigStart = $btfrTrgx.'|'.$stTrgx;
    my $btfrTrigSize = $stTrgxSize+$btfrTrgxSize;

    # Verify that the trigger words are wrapped with whitespace or that
    # the trigger is at the start or end of the string with white space
    # on either side of it. This prevents triggering on queries such as
    # "countdown.js", "timer.x", "five-alarm", etc
    if($raw !~ /(^|\s)($trgx|$nonStrpTrgx)(\s|$)/i) {
        return;
    }

    # When ambigous words are present in triggers then it should not
    # invoke Timer IA.
    if($raw =~ /^($ambTrgx)$/){
        return;
    }
    
    # When query doesn't ask for timer explicitly and just wants time
    # calculations, don't invoke IA.
    if($raw !~ /($trgx)/ and $raw =~ /[+-]/) {
        return;
    }
    
    # When the query is empty and we know that the trigger word matches
    # the trigger exactly (whitespace check) we can return a valid result
    if($qry eq '') {
        return build_result($req);
    }

    # Trim both sides of the raw query to have the raw regex work
    # properly. Since we need to make sure /^<trigger> for $/ doesn't
    # trigger. Additionally trims down the start triggers
    # <startTriggers> <specific time> <beautifierTriggers> <trigger> ------------- start 10 minute online timer
    # <startTriggers> <trigger> <beautifierTriggers> <specific time> ------------- begin timer online 10 minutes
    # <startTriggers> <trigger> <beautifierTriggers> <joiners> <specific time> --- set timer online for 10 min
    $raw =~ s/^\s*(\b(\s*($btfrTrigStart)\s*)\b){1,$btfrTrigSize}\s*//;
    $raw =~ s/($btfrTrgx)$//;

    # Parse the raw query to remove common terms. This allows us to
    # catch the more specific queries and handle them. We also strip
    # the extra bounding whitespace. The trigger is
    # set to startend, causing "online timer for ..." to trigger.
    #
    #
    # Note: Beautifiers surrounds the triggers and joiners connect it to the value
    #
    # Matches on...
    # <specific time> <beautifierTriggers> <trigger> ------------------------------ 10 minute online timer
    # <trigger> <beautifierTriggers> <specific time> ------------------------------ timer online 10 minutes
    # <trigger> <beautifierTriggers> <joiners> <specific time> -------------------- timer online for 10 min
    # <specific time> <trigger> <beautifierTriggers> ------------------------------ 10 minute timer online
    # <startTriggers> <beautifierTriggers> <trigger> <specific time> ------------- online timer 10 minutes
    # <beautifierTriggers> <trigger> <joiners> <specific time> -------------------- online timer for 10 min
    # <specific time> <beautifierTriggers> <trigger> ------------------------------ 10 minute online countdown timer
    # <trigger> <beautifierTriggers> <specific time> ------------------------------ timer alarm online 10 minutes
    # <trigger> <beautifierTriggers> <joiners> <specific time> -------------------- alarm timer online at 10 min
    # <specific time> <trigger> <beautifierTriggers> ------------------------------ 10 minute countdown timer online
    # <startTriggers> <beautifierTriggers> <trigger> <specific time> ------------- online countdown alarm 10 minutes
    # <beautifierTriggers> <trigger> <joiners> <specific time> -------------------- online timer with 10 min
    $raw =~ s/($btfrTrgx\s*)?(\b(\s*($trgx)\s*)\b)($btfrTrgx)?\s*($joinTrgx)?//ig;

    if($raw eq '') {
        return build_result($req);
    }elsif($raw =~ /^(\s?([\d.]+ ?(m(in((ute)?s?)?)?|s(ec((ond)?s?)?)?|h(ours?)?|hr))\s?)+$/) {
        return build_result($req);
    }elsif($raw =~ /^( ?((\d{1,2}:)?\d{1,2}:\d{2}) ?)/) {
        return build_result($req);
    }
    return;
};

1;
