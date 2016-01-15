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
triggers any => qw(date);

zci is_cached => 1;
zci answer_type => 'date_math';

my $datestring_regex = datestring_regex();

my $units = qr/(?<unit>second|minute|hour|day|week|month|year)s?/i;

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
    return $unit =~ /hour|minute|second/i;
}

sub format_result {
    my ($out_date, $unit) = @_;
    my $clock_rep = $out_date->strftime("%T");
    $out_date = date_output_string($out_date);
    return "${out_date}@{[is_clock_unit($unit) ? ' ' . $clock_rep : '']}";
}

sub get_clock_time {
    my $date = shift;
    return $date->strftime("%T");
}

sub format_input {
    my ($input_date, $action, $unit, $input_number) = @_;
    my $in_date    = date_output_string($input_date);
    $in_date = "$in_date @{[get_clock_time $input_date]}" if is_clock_unit $unit;
    my $out_action = "$action $input_number $unit";
    return "$in_date $out_action";
}

my $number_re = number_style_regex();

my $relative_regex = qr/(?<number>$number_re|[a-z\s-]+)\s+$units/;

my $action_re = qr/(?<action>plus|\+|\-|minus)/i;
my $date_re = qr/(?<date>$datestring_regex)/;

my $operation_re = qr/$date_re(?:\s+$action_re\s+$relative_regex)?/;
my $from_re = qr/$relative_regex\s+(?<action>from)\s+$date_re?/i;
my $ago_re = qr/$relative_regex\s+(?<action>ago)/i;

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

handle query_lc => sub {
    my $query = $_;


    return unless $query =~ /^(?:date\s+)?($operation_re|$from_re|$ago_re)$/i;

    if (!exists $+{'number'}) {
        my $out_date = date_output_string(parse_datestring_to_date($+{'date'}));
        return build_result($out_date, $+{date});
    }

    my $action = get_action_for $+{action} or return;
    my $input_date;
    unless (defined $+{date}) {
        $input_date = parse_datestring_to_date("today");
    } else {
        $input_date   = parse_datestring_to_date($+{date});
    };
    my $input_number = normalize_number $+{number};
    my $style = number_style_for($input_number) or return;
    my $compute_num = $style->for_computation($input_number);
    my $out_num = $style->for_display($input_number);
    my $unit = $+{unit};

    my $compute_number = $action eq '-' ? 0 - $compute_num : $compute_num;

    my $dur = get_duration $compute_number, $unit;

    $unit .= 's' if $compute_num != 1;
    my $out_date = $input_date->clone->add_duration($dur);
    my $result = format_result $out_date, $unit;
    my $formatted_input = format_input $input_date, $action, $unit, $out_num;

    return build_result($result, $formatted_input);
};

1;
