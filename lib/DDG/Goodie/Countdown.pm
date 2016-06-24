package DDG::Goodie::Countdown;

# ABSTRACT: Provides a countdown to a particular date or time

use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

use DateTime;

use strict;

zci answer_type => 'countdown';

zci is_cached => 1;

my $goodieVersion = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;

triggers startend => 'countdown to','time until','how long until';

# Handle statement
handle remainder => sub {

    my $remainder = $_;

    my $date = parse_datestring_to_date($remainder) or return;
    my $current = parse_datestring_to_date('now');

    my $dur = $date->subtract_datetime($current);
    my $diff = $date->epoch - $current->epoch;

    return if $diff <= 0;
    print "\ndiff $diff also, ".$dur->in_units( 'days' );
    return $diff,
        structured_answer => {
            data => {
                remainder    => $_,
                difference   => $diff,
                days1 => $dur->in_units( 'days' ),
                hours1 => $dur->in_units( 'hours' ),
                minutes1 => $dur->in_units( 'minutes' ),
                seconds1 => $dur->in_units( 'seconds' ),
                #$dur->in_units( 'nanoseconds' ),
                #countdown_to => date_output_string($date,1)
                countdown_to => $date->strftime("%B %d, %Y, %r")  #remove after the Dates Role is updated
            },
            templates => {
                group => "text",
                options => {
                    title_content => 'DDH.countdown.countdown'
                }
            }
        };
};

1;