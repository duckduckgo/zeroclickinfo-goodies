#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

use Test::MockTime qw( :all );

zci answer_type => 'workdays_between';
zci is_cached   => 0;

my @plural = qw(are Workdays);
my @jan_6_to_10               = ('06 Jan 2014', '10 Jan 2014', 5, @plural);
my @jan_6_to_13               = ('06 Jan 2014', '13 Jan 2014', 6, @plural);
my @jan_6_to_12               = ('06 Jan 2014', '12 Jan 2014', 5, @plural);
my @jan_11_to_14_sat          = ('11 Jan 2014', '14 Jan 2014', 2, @plural);
my @jan_12_to_14_sun          = ('12 Jan 2014', '14 Jan 2014', 2, @plural);
my @jan_3_sameday             = ('03 Jan 2014', '03 Jan 2014',1, 'is', 'Workday');
my @jan_31_2000_to_2001       = ('31 Jan 2000', '31 Jan 2001',253, @plural);
my @jan_4_samedaywknd         = ('04 Jan 2014', '04 Jan 2014', 0, @plural);
my @jan_3_to_6_weekend_middle = ('03 Jan 2014', '06 Jan 2014', 2, @plural);

sub build_structured_answer {
    my ($start_str, $end_str, $workdays, $verb, $number, $regex) = @_;

    my $response = re(qr/There $verb $workdays $number between $start_str and $end_str./);
    my $subtitle = re(qr/Workdays between $start_str - $end_str/);
    my $title = re($workdays);

    if(!$regex) {
        $response = "There $verb $workdays $number between $start_str and $end_str.";
        $title = $workdays;
        $subtitle = "Workdays between $start_str - $end_str";
    }
    return $response,
        structured_answer => {
            data => {
                title    => $title,
                subtitle => $subtitle
            },
            templates => {
                group => "text"
            }
        };
}

sub build_test{ test_zci(build_structured_answer(@_)) }

set_fixed_time("2015-01-11T09:45:56");

ddg_goodie_test(
    [qw(DDG::Goodie::WorkdaysBetween)],

     # Standard work week
    'Workdays between 2014-01-06 2014-01-10'           => build_test(@jan_6_to_10),
    'Workdays between 2014-01-06 2014-01-10 inclusive' => build_test(@jan_6_to_10),

     # Ending date first
    'Workdays between 2014-01-10 2014-01-06'           => build_test(@jan_6_to_10),
    'Workdays between 2014-01-10 2014-01-06 inclusive' => build_test(@jan_6_to_10),

     # Ending date on a weekend
    'Workdays between 2014-01-06 2014-01-12'           => build_test(@jan_6_to_12),
    'Workdays between 2014-01-06 2014-01-12 inclusive' => build_test(@jan_6_to_12),

     # Including the weekend
    'Workdays between 2014-01-06 2014-01-13'           => build_test(@jan_6_to_13),
    'Workdays between 2014-01-06 2014-01-13 inclusive' => build_test(@jan_6_to_13),

     # Including the weekend -- Backwards
    'Workdays between 2014-01-13 2014-01-06'           => build_test(@jan_6_to_13),
    'Workdays between 2014-01-13 2014-01-06 inclusive' => build_test(@jan_6_to_13),

     # Starting on a Saturday
    'Workdays between 2014-01-11 2014-01-14'           => build_test(@jan_11_to_14_sat),
    'Workdays between 2014-01-11 2014-01-14 inclusive' => build_test(@jan_11_to_14_sat),

     # Starting on a Sunday
    'Workdays between 2014-01-12 2014-01-14'           => build_test(@jan_12_to_14_sun),
    'Workdays between 2014-01-12 2014-01-14 inclusive' => build_test(@jan_12_to_14_sun),

     # Same day
    'Workdays between jan 3, 2014 jan 3, 2014'           => build_test(@jan_3_sameday),
    'Workdays between jan 3, 2014 jan 3, 2014 inclusive' => build_test(@jan_3_sameday),

     #same day on a weekend
    'Workdays between jan 4, 2014 jan 4, 2014'           => build_test(@jan_4_samedaywknd),
    'Workdays between jan 4, 2014 jan 4, 2014 inclusive' => build_test(@jan_4_samedaywknd),

     #weekend in the middle
    'Workdays between jan 3, 2014 jan 6, 2014'           => build_test(@jan_3_to_6_weekend_middle),
    'Workdays between jan 3, 2014 jan 6, 2014 inclusive' => build_test(@jan_3_to_6_weekend_middle),

     #weekend in the middle with to
    'Workdays between jan 3, 2014 to jan 6, 2014 inclusive' => build_test(@jan_3_to_6_weekend_middle),
    'Workdays between jan 3, 2014 to jan 6, 2014'           => build_test(@jan_3_to_6_weekend_middle),

    'Workdays between 2000-01-31 2001-01-31'               => build_test(@jan_31_2000_to_2001),
    'Workdays between 2000-01-31 and 2001-01-31 inclusive' => build_test(@jan_31_2000_to_2001),
    'Workdays between 2000-01-31 2001-01-31 inclusive'     => build_test(@jan_31_2000_to_2001),

    'Workdays between jan 3 2013 and jan 4 2013'           => build_test('03 Jan 2013', '04 Jan 2013', 2, @plural),
    'business days between jan 10 and jan 20'              => build_test(qr/10 Jan [0-9]{4}/, qr/20 Jan [0-9]{4}/, qr/[1-9]/, @plural, 'true'),
    'business days between january and february'           => build_test(qr/01 Jan [0-9]{4}/, qr/01 Feb [0-9]{4}/, qr/[1-9][0-9]/, @plural, 'true'),

     # Invalid input
     'Workdays between 01/2014 01/2015'                 => undef,
     'Workdays between 01/2014/01'                      => undef,
     'Workdays between 01/01/2014 inclusive'            => undef,
     'Workdays between 01/01/2014'                      => undef,
     'Workdays between 20/01/2014 inclusive'            => undef,
     'Workdays between 19/19/2014 20/24/2015'           => undef,
     'Workdays between 19/19/2014 20/24/2015 inclusive' => undef,
     'Workdays from FEB 30 2014 to March 24 2014'       => undef,
);

done_testing;
