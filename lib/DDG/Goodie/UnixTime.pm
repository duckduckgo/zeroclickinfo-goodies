package DDG::Goodie::UnixTime;
# ABSTRACT: epoch -> human readable time

use DDG::Goodie;

use DateTime;
use List::MoreUtils qw( uniq );
use Try::Tiny;

my @trigger_words = ("unixtime", "datetime", "unix timestamp", "unix time stamp", "unix epoch", "epoch", "timestamp", "unix time", "utc time", "utc now", "current utc");
triggers startend => @trigger_words;

zci answer_type => "time_conversion";
zci is_cached   => 0;

attribution github => ['codejoust', 'Iain '];

primary_example_queries 'unix time 0000000000000';
secondary_example_queries 'epoch 0', 'epoch 2147483647';
description 'convert a unix epoch to human-readable time';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/UnixTime.pm';
category 'calculations';
topics 'sysadmin';

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
    $time_input //= time unless ($no_default_triggers{$+{'trigger'}});
    return unless defined $time_input;

    my $dt = try { DateTime->from_epoch(epoch => $time_input) };
    return unless $dt;

    my $time_output;
    my @table_data = (['Unix Epoch', $time_input]);

    foreach my $tz (uniq grep { $_ } ($loc->time_zone, $default_tz)) {
        $dt->set_time_zone($tz);
        push @table_data, [sprintf($header_format, $tz), $dt->strftime($time_format)];
    }

    my $text = join(' | ', (map { join(' => ', @{$_}) } @table_data));
    return $text, html => to_html(@table_data);
};

sub to_html {
    my $results  = "";
    my $minwidth = "90px";
    foreach my $result (@_) {
        $results .=
          "<div><span class=\"unixtime__label text--secondary\">$result->[0]: </span><span class=\"text--primary\">$result->[1]</span></div>";
        $minwidth = "180px" if length($result->[0]) > 10;
    }
    return $results . "<style> .zci--answer .unixtime__label {display: inline-block; min-width: $minwidth}</style>";
}

1;
