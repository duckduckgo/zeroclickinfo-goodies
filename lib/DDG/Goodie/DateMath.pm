package DDG::Goodie::DateMath;
# ABSTRACT: add/subtract days/weeks/months/years to/from a date

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::Dates';
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




my $relative_regex = qr/(?<number>\d+|[a-z\s-]+)\s+$units/;

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

    my $input_date   = parse_datestring_to_date($+{date});
    my $input_number = str2nbr($+{number});
    my $unit = $+{unit};

    # check/tweak other (non-date) input
    my %action_map = (
        plus  => '+',
        '+'   => '+',
        minus => '-',
        '-'   => '-',
        from  => '+'
    );
    my $action = $action_map{$+{action}} || return;

    my $number = $action eq '-' ? 0 - $input_number : $input_number;

    $unit =~ s/s$//g;

    my ($years, $months, $days, $weeks) = (0, 0, 0, 0);
    $years  = $number     if $unit eq "year";
    $months = $number     if $unit eq "month";
    $days   = $number     if $unit eq "day";
    $days   = 7 * $number if $unit eq "week";

    my $dur = DateTime::Duration->new(
        years  => $years,
        months => $months,
        days   => $days
    );

    $unit .= 's' if $input_number > 1;    # plural?
    my $out_date   = date_output_string($input_date->clone->add_duration($dur));
    my $in_date    = date_output_string($input_date);
    my $out_action = "$action $input_number $unit";
    my $result = $out_date;
    my $formatted_input = "$in_date $out_action";
    return build_result($result, $formatted_input);
};

1;
