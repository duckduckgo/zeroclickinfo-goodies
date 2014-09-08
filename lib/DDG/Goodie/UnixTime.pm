package DDG::Goodie::UnixTime;
# ABSTRACT: epoch -> human readable time

use DDG::Goodie;

use DateTime;
use Try::Tiny;

triggers startend => "unixtime", "timestamp", "datetime", "epoch", "unix time", "unix timestamp", "unix time stamp", "unix epoch";

zci answer_type => "time_conversion";
zci is_cached   => 0;

attribution github => ['https://github.com/codejoust', 'codejoust'];

primary_example_queries 'unix time 0000000000000';
secondary_example_queries 'epoch 0', 'epoch 2147483647';
description 'convert a unix epoch to human-readable time';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/UnixTime.pm';
category 'calculations';
topics 'sysadmin';

my $default_tz  = 'UTC';
my $time_format = '%a %b %d %T %Y %Z';

handle remainder => sub {
    return unless defined $_;

    my $time_input = shift;
    $time_input = time if ($time_input eq '');    # Default to 'now' when empty.

    my $time_output;
    my $tz = $loc->time_zone || $default_tz;      # Show them local time, otherwise the default.
    my $dt = try { DateTime->from_epoch(epoch => $time_input, time_zone => $tz,) };
    return unless $dt;
    $time_output = $dt->strftime($time_format);
    if ($tz ne $default_tz) {
        # They get the default TZ (UTC) regardless.  Either we already did it or we do it now.
        $dt->set_time_zone($default_tz);
        $time_output .= ' / ' . $dt->strftime($time_format);
    }

    return unless $time_output;
    return $time_input . ' (Unix time): ' . $time_output;
};

1;
