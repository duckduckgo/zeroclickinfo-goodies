package DDG::Goodie::UnixTime;
# ABSTRACT: epoch -> human readable time

use strict;
use DDG::Goodie;

use DateTime;
use List::MoreUtils qw( uniq );
use Try::Tiny;

my @trigger_words = ("unixtime", "datetime", "unix timestamp", "unix time stamp", "unix epoch", "epoch", "timestamp", "unix time", "utc time", "utc now", "current utc", "time since epoch", "epoch converter", "epoch time converter");
triggers startend => @trigger_words;

zci answer_type => "time_conversion";
zci is_cached   => 0;

my $default_tz          = 'UTC';
my $time_format         = '%a %b %d %T %Y %Z';
my $header_format       = "Time (%s)";
my %no_default_triggers = map { $_ => 1 } qw(timestamp epoch);
my $triggers            = join('|', @trigger_words);
my $extract_qr          = qr/^(?<trigger>$triggers)?\s*(?<epoch>-?\d+)?\s*(?<trigger>$triggers)?$/;

handle query => sub {

    my $query = shift;
    $query =~ $extract_qr;
    my $time_input = $+{'epoch'};
    # If there was nothing in there, we must want now... unless we're not supposed to default for this trigger.
    if (defined $+{'trigger'}) {
        $time_input //= time unless ($no_default_triggers{$+{'trigger'}});
    }
    return unless defined $time_input;

    my $dt = try { DateTime->from_epoch(epoch => $time_input) };
    return unless $dt;

    my $time_output;
    my %table_data = ('Unix Epoch' => $time_input);

    foreach my $tz (uniq grep { $_ } ($loc->time_zone, $default_tz)) {
        $dt->set_time_zone($tz);
        $table_data{sprintf($header_format, $tz)} = $dt->strftime($time_format);
    }

    my @table_keys = sort {$b cmp $a} keys %table_data;
    my @table_data = map { [ $_ => $table_data{$_} ] } keys %table_data;
    my $text = join(' | ', (map { join(' => ', @{$_}) } @table_data));

    return $text,
    structured_answer => {
        data => {
            record_data => \%table_data,
            record_keys => \@table_keys
        },
        templates => {
            group => 'list',
            options => {
                content => 'record'
            }
        }
    };
};

1;
