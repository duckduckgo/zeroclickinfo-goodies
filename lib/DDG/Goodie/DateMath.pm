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
triggers any => qw(plus minus + - before after);
triggers any => qw(date time);

zci is_cached   => 0;
zci answer_type => 'date_math';

my $date_parser = date_parser();

sub get_duration {
    my ($number, $unit) = @_;
    $unit = lc $unit . 's';
    my $dur = DateTime::Duration->new(
        $unit => $number,
    );
}

sub get_action_for {
    my $action = shift;
    return '+' if $action =~ /^(\+|plus|from|in|add|after)$/i;
    return '-' if $action =~ /^(\-|minus|ago|subtract|before)$/i;
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

sub format_result {
    my ($out_date, $use_clock) = @_;
    my $output_date = $date_parser->for_display($out_date, $use_clock);
    return $output_date;
}

sub format_input {
    my ($input_date, $action, $unit, $input_number, $use_clock) = @_;
    my $in_date    = $date_parser->for_display($input_date, $use_clock);
    my $out_action = "$action $input_number $unit";
    return "$in_date $out_action";
}

my $number_re        = number_style_regex();
my $datestring_regex = datestring_regex();

my $units = qr/(?<unit>second|minute|hour|day|week|month|year)s?/i;

my $relative_regex = qr/(?<number>$number_re|[a-z\s-]+)\s+$units/i;

my $action_re = qr/(?<action>plus|add|\+|\-|minus|subtract)/i;
my $date_re   = qr/(?<date>$datestring_regex)/i;

my $operation_re = qr/$date_re(?:\s+$action_re\s+$relative_regex)?/i;
my $from_re      = qr/$relative_regex\s+(?<action>from|after)\s+$date_re?|(?<action>in)\s+$relative_regex/i;
my $ago_re       = qr/$relative_regex\s+(?<action>ago)|$relative_regex\s+(?<action>before)\s+$date_re?/i;
my $time_24h = time_24h_regex();
my $time_12h = time_12h_regex();
my $relative_dates = relative_datestring_regex();

sub build_result {
    my ($result, $formatted) = @_;
        return $result, structured_answer => {
            meta => {
                signal => 'high',
            },
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
    my ($date, $use_clock) = @_;
    return unless $date =~ $relative_dates;
    my $parsed_date = $date_parser->parse_datestring_to_date($date);
    my $result = format_result $parsed_date, $use_clock or return;
    return build_result($result, ucfirst $date);
}

sub calculate_new_date {
    my ($compute_number, $unit, $input_date) = @_;
    my $dur = get_duration $compute_number, $unit;
    return $input_date->clone->add_duration($dur);
}

sub get_result_action {
    my ($action, $date, $number, $unit, $use_clock) = @_;
    $action = get_action_for $action or return;
    my $input_number = str2nbr($number);
    my $style = number_style_for($input_number) or return;
    my $compute_num = $style->for_computation($input_number);
    my $out_num     = $style->for_display($input_number);

    my $input_date = $date_parser->parse_datestring_to_date(
        defined($date) ? $date : "today") or return;

    my $compute_number = $action eq '-' ? 0 - $compute_num : $compute_num;
    my $out_date = calculate_new_date $compute_number, $unit, $input_date;
    $unit .= 's' if abs($compute_number) != 1;
    my $result = format_result($out_date, $use_clock);
    my $formatted_input = format_input($input_date, $action, $unit, $out_num, $use_clock);
    return build_result($result, $formatted_input);
}

my $what_re = qr/what ((is|was|will) the )?/i;

my $day_or_time_re = qr/(?<day_or_time>date|time|day)/i;

my $will_re = qr/ (was it|will it be|is it|be)/i;

my $full_date_regex = qr/^($what_re?$day_or_time_re$will_re? )?($operation_re|$from_re|$ago_re)[\?.]?$/i;

handle query_lc => sub {
    my $query = $_;

    return unless $query =~ $full_date_regex;

    my $action = $+{action};
    my $date   = $+{date};
    my $number = $+{number};
    my $unit   = $+{unit};
    my $day_or_time   = $+{day_or_time};

    my $specified_time = $query =~ /$time_24h|$time_12h/;
    my $use_clock = $specified_time || should_use_clock $unit, $day_or_time;

    return get_result_relative($date, $use_clock) unless defined $number;
    return get_result_action $action, $date, $number, $unit, $use_clock;
};

1;
