package DDG::Goodie::Uptime;
# ABSTRACT: Given an uptime percentage, display various average downtime durations

use strict;
use DDG::Goodie;
use Time::Duration;
use Time::Seconds;
with 'DDG::GoodieRole::NumberStyler';

zci answer_type => "uptime";
zci is_cached   => 1;

name "Uptime";
description "Given an uptime percentage, display various average downtime durations";
primary_example_queries "uptime 99,99%", "uptime 99.99%", "99.99% uptime";
secondary_example_queries "uptime of 99.9998%";
category "calculations";
topics "computing";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Uptime/Uptime.pm";
attribution github => ["YouriAckx", "Youri Ackx"],
            web => ["http://ackx.net/", "Youri Ackx"],
            twitter => ["YouriAckx", "Youri Ackx"],
            github => ["https://github.com/Sloff/", "Sloff"];

# Triggers
triggers startend => "uptime", start => "uptime of";

# Near zero duration messages
my $JUST_NOW_MSG = "just now";                          # from Time::Duration
my $LESS_THAN_ONE_SECOND_MSG = "less than one second";  # from us


# Compute the downtime string durations (year, month, day)
# for the given uptime (must be btw 0 and 1)
sub compute_durations {
    my $downtime_percentage = 1 - $_[0];
    return map { fix_just_now(duration($_ * $downtime_percentage)) } (ONE_YEAR, ONE_MONTH, ONE_DAY);
}


# Given a duration, replace "just now" emitted by Time::Duration
# by "Less than one second" when applicable,
# or return the duration itself otherwise.
sub fix_just_now {
    my $duration = $_[0];
    return $duration eq $JUST_NOW_MSG ? $LESS_THAN_ONE_SECOND_MSG : $duration;
}


# Format response as text
sub format_text {
    my ($uptime_percentage, $downtime_year, $downtime_month, $downtime_day) = @_;
    my $text = "Implied downtimes for " . $uptime_percentage . " uptime\n";
    
    if ($downtime_year eq $LESS_THAN_ONE_SECOND_MSG) {
        $text .= "No downtime or less than a second during a year";
        return $text;
    }
    
    $text .= "Daily: " . $downtime_day . "\n";
    $text .= "Monthly: " . $downtime_month . "\n";
    $text .= "Annually: " . $downtime_year;
    return $text;
}


# Format response as structured_answer
sub format_answer {
    my ($uptime_percentage, $downtime_year, $downtime_month, $downtime_day) = @_;
    
    my ($title, $subtitle, @record_data, @record_keys);

    if ($downtime_year eq $LESS_THAN_ONE_SECOND_MSG) {
        $title = "No downtime or less than a second during a year";
        $subtitle = "Implied downtimes for $uptime_percentage uptime";
        @record_data = undef;
        @record_keys = undef;
    } else {
        $title = "Implied downtimes for $uptime_percentage uptime";
        @record_data = {
            daily => $downtime_day,
            monthly => $downtime_month,
            yearly => $downtime_year
        };
        @record_keys = ["daily", "monthly", "yearly"];
        
    }
    
    return structured_answer => {
        id => "uptime",
        name => "Answer",
        templates => {
            group => "list",
            options => {
                content => "record"
            }
        },
        data => {
            title => $title,
            subtitle => $subtitle,
            record_data => @record_data,
            record_keys => @record_keys
        }
    }
}


# Handle statement
handle remainder => sub {
    return unless $_;               # Guard against "no answer"
    return unless s/%$//;           # Query should end with '%'. Test and remove it
    s/\s+//g;                       # Delete the whitespaces

    # Look for something that "looks like a number"
    my $number_string = $_;
    my $number_re = number_style_regex();
    $number_string =~ qr/($number_re)/;

    # Get an object that can handle the number
    my $styler = number_style_for($number_string);
    return unless $styler;  # might not be supported
    my $perl_number = $styler->for_computation($number_string);
    my $clean_query = $styler->for_display($perl_number) . '%';
    
    # Query value must be btw 0 and 100
    return unless $perl_number >= 0 && $perl_number < 100;
    
    my ($year, $month, $day) = compute_durations($perl_number / 100);
    my $plaintext = format_text($clean_query, $year, $month, $day);
    my @structured_answer = format_answer($clean_query, $year, $month, $day);
    
    return $plaintext, @structured_answer;
};

1;
