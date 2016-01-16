package DDG::Goodie::DateMath;
# ABSTRACT: add/subtract days/weeks/months/years to/from a date

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::Dates';
with 'DDG::GoodieRole::NumberStyler';
use DateTime::Duration;
use Lingua::EN::Numericalize;

triggers any => qw(second minute hour day week month year);
triggers any => qw(seconds minutes hours days weeks months years);
triggers any => qw(plus minus + -);
triggers any => qw(date time);

zci is_cached => 0;
zci answer_type => 'date_math';


sub get_duration {
    my ($number, $unit) = @_;
    my $years  = $number     if $unit eq "year";
    my $months = $number     if $unit eq "month";
    my $weeks   = $number if $unit eq "week";
    my $days   = $number     if $unit eq "day";
    my $hours  = $number     if $unit eq "hour";
    my $minutes = $number    if $unit eq "minute";
    my $seconds = $number if $unit eq "second";
    my $dur = DateTime::Duration->new(
        years  => $years // 0,
        months => $months // 0,
        weeks => $weeks // 0,
        days   => $days // 0,
        hours => $hours // 0,
        minutes => $minutes // 0,
        seconds => $seconds // 0,
    );
}

sub get_action_for {
    my $action = shift;
    return '+' if $action =~ /\+|plus|from/i;
    return '-' if $action =~ /\-|minus|ago/i;
}

sub normalize_number {
    my $number = shift;
    return $number =~ s/(\w+(?!s)\w)/str2nbr($1)/gre;
}

sub is_clock_unit {
    my $unit = shift;
    return $unit =~ /hour|minute|second/i if defined $unit;
    return 0;
}

sub should_use_clock {
    my ($unit, $form) = @_;
    return 1 if is_clock_unit($unit);
    return $form =~ /time/i if defined $form;
    return 0;
}

sub get_clock_time {
    my $date = shift;
    return $date->strftime("%T");
}

sub format_result {
    my ($out_date, $use_clock) = @_;
    my $output_date = date_output_string($out_date, $use_clock);
    return $output_date;
}


sub format_input {
    my ($input_date, $action, $unit, $input_number, $use_clock) = @_;
    my $in_date    = date_output_string($input_date, $use_clock);
    my $out_action = "$action $input_number $unit";
    return "$in_date $out_action";
}

sub format_input_no_action {
    my ($input_date, $use_clock) = @_;
    my $in_date = date_output_string($input_date, $use_clock);
    return $in_date;
}

sub format_result_no_action {
    my ($out_date, $use_clock) = @_;
    my $output_date = date_output_string($out_date, $use_clock);
    return $output_date;
}

my $number_re = number_style_regex();
my $datestring_regex = datestring_regex();

my $units = qr/(?<unit>second|minute|hour|day|week|month|year)s?/i;

my $relative_regex = qr/(?<number>$number_re|[a-z\s-]+)\s+$units/;

my $action_re = qr/(?<action>plus|\+|\-|minus)/i;
my $date_re = qr/(?<date>$datestring_regex)/;

my $operation_re = qr/$date_re(?:\s+$action_re\s+$relative_regex)?/;
my $from_re = qr/$relative_regex\s+(?<action>from)\s+$date_re?/i;
my $ago_re = qr/$relative_regex\s+(?<action>ago)/i;
my $time_24h = time_24h_regex();
my $time_12h = time_12h_regex();
my $relative_dates = relative_dates_regex();

sub build_result {
    my ($result, $formatted) = @_;
        return $result, structured_answer => {
            id   => 'date_math',
            name => 'Answer',
            data => {
                title    => "$result",
                subtitle => "$formatted",
            },
            templates => {
                group => 'text',
            },
        };

}

sub get_result_relative {
    my ($specified_time, $dort, $date) = @_;
    return unless $date =~ $relative_dates;
    my $use_clock = $specified_time || should_use_clock undef, $dort;
    my $parsed_date = parse_datestring_to_date($date);
    my $formatted_input = format_input_no_action $parsed_date, $use_clock;
    my $result = format_result_no_action $parsed_date, $use_clock or return;
    return build_result($result, $date);
}

handle query => sub {
    my $query = $_;


    return unless $query =~ /^(?:(?<dort>date|time)\s+)?($operation_re|$from_re|$ago_re)$/i;
    my $number = $+{number};
    my $action = $+{action};
    my $unit   = $+{unit};
    my $date   = $+{date};
    my $dort   = $+{dort};

    my $specified_time = $query =~ /$time_24h|$time_12h/;
    unless (defined $number) {
        return get_result_relative($specified_time, $dort, $date);
    };

    $action = get_action_for $action or return;
    my $input_date;
    unless (defined $date) {
        $input_date = parse_datestring_to_date("today");
    } else {
        $input_date   = parse_datestring_to_date($date) or return;
    };
    my $input_number = normalize_number $number;
    my $style = number_style_for($input_number) or return;
    my $compute_num = $style->for_computation($input_number);
    my $out_num = $style->for_display($input_number);

    my $compute_number = $action eq '-' ? 0 - $compute_num : $compute_num;

    my $dur = get_duration $compute_number, $unit;

    $unit .= 's' if abs($compute_num) != 1;
    my $out_date = $input_date->clone->add_duration($dur);
    $out_date->set_time_zone($input_date->time_zone);
    my $use_clock = $specified_time || should_use_clock($unit, $dort);
    my $result = format_result($out_date, $use_clock);
    my $formatted_input = format_input($input_date, $action, $unit, $out_num, $use_clock);

    return build_result($result, $formatted_input);
};

1;
