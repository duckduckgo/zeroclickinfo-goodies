package DDG::Goodie::UnixTime;
# ABSTRACT: epoch -> human readable time

use DDG::Goodie;

use DateTime;

triggers startend => "unixtime", "time", "timestamp", "datetime", "epoch", "unix time", "unix timestamp", "unix time stamp", "unix epoch";

zci answer_type => "time_conversion";
zci is_cached => 0;

attribution github => ['https://github.com/codejoust', 'codejoust'];

primary_example_queries 'unix time 0000000000000';
secondary_example_queries 'epoch 0', 'epoch 2147483647';
description 'convert a unix epoch to human-readable time';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/UnixTime.pm';
category 'calculations';
topics 'sysadmin';

handle remainder => sub {
    return unless defined $_;

    my $time_input = shift;
    my $time_utc;
    eval {
        $time_input = int(length($time_input) >= 13 ? ($time_input / 1000) : ($time_input + 0));
        $time_utc = DateTime->from_epoch(
            epoch     => $time_input,
            time_zone => "UTC"
        )->strftime("%a %b %d %T %Y %z");
    };

    return unless $time_utc;
    return "Unix Time: " . $time_utc;
};

1;
