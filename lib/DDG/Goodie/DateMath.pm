package DDG::Goodie::DateMath;
# ABSTRACT: add/subtract days/weeks/months/years to/from a date

use DDG::Goodie;
with 'DDG::GoodieRole::Dates';
use DateTime::Duration;
use Lingua::EN::Numericalize;

triggers any => qw( plus minus + - date day week month year days weeks months years);

zci is_cached => 1;
zci answer_type => 'date_math';

primary_example_queries 'Jan 1 2012 plus 32 days';
secondary_example_queries '1/1/2012 plus 5 months', 'January first minus ten days', 'in 5 weeks', '2 weeks ago', '1 month from today';
description 'calculate the date with an offset';
name 'DateMath';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/DateMath.pm';
category 'time_sensitive';
topics 'everyday';
attribution github => ['http://github.com/cj01101', 'cj01101'];

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
        return $out_date,
            structured_answer => {
            input     => [$+{'date'}],
            operation => 'Date math',
            result    => $out_date
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

    return "$in_date $out_action is $out_date",
      structured_answer => {
        input     => [$in_date . ' ' . $out_action],
        operation => 'Date math',
        result    => $out_date
      };
};

1;
