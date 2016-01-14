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

handle query_lc => sub {
    my $query = $_;

    my $relative_regex = qr!(?<number>\d+|[a-z\s-]+)\s+(?<unit>(?:day|week|month|year)s?)!;

    return unless $query =~ qr!^(?:date\s+)?(
        (?<date>$datestring_regex)(?:\s+(?<action>plus|\+|\-|minus)\s+$relative_regex)?|
        $relative_regex\s+(?<action>from)\s+(?<date>$datestring_regex)?
    )$!x;

    if (!exists $+{'number'}) {
        my $out_date = date_output_string(parse_datestring_to_date($+{'date'}));
        return $out_date, structured_answer => {
            id => 'date_math',
            name => 'Answer',
            data => {
                title => "$out_date",
                subtitle => "$+{date}",
            },
            templates => {
                group => 'text',
            },
        };
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

    return $result, structured_answer => {
        id => 'date_math',
        name => 'Answer',
        data => {
            title => "$result",
            subtitle => "$formatted_input",
        },
        templates => {
            group => 'text',
        },
    };
};

1;
