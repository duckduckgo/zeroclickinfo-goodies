#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

use Test::MockTime qw( :all );

zci answer_type => 'workdays_between';
zci is_cached   => 0;

sub build_structured_answer {
    my ($start_str, $end_str, $workdays, $regex) = @_;    

    my $verb = 'are';
    my $number = 'Workdays';
    my $response = re(qr/There $verb $workdays $number between $start_str and $end_str./);
    my $subtitle = re(qr/Workdays between $start_str - $end_str/);
    my $title = re($workdays);

    if(!$regex) {
        $verb = $workdays == 1 ? 'is' : 'are';
        $number = $workdays == 1 ? 'Workday' : 'Workdays';
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

    'Workdays between 01/31/2000 01/31/2001'               => build_test('31 Jan 2000', '31 Jan 2001', 253),
    'Workdays between 01/31/2000 and 01/31/2001 inclusive' => build_test('31 Jan 2000', '31 Jan 2001', 253),
    'Workdays between 01/31/2000 01/31/2001 inclusive'     => build_test('31 Jan 2000', '31 Jan 2001', 253),
    'Workdays between jan 3 2013 and jan 4 2013'           => build_test('03 Jan 2013', '04 Jan 2013', 2),

     #weekend in the middle with to
    'Workdays between jan 3, 2014 to jan 6, 2014 inclusive' => build_test('03 Jan 2014', '06 Jan 2014', 2),
    'Workdays between jan 3, 2014 to jan 6, 2014'           => build_test('03 Jan 2014', '06 Jan 2014', 2),

     #weekend in the middle
    'Workdays between jan 3, 2014 jan 6, 2014'           => build_test('03 Jan 2014', '06 Jan 2014', 2),
    'Workdays between jan 3, 2014 jan 6, 2014 inclusive' => build_test('03 Jan 2014', '06 Jan 2014', 2),

     #same day on a weekend
    'Workdays between jan 4, 2014 jan 4, 2014'           => build_test('04 Jan 2014', '04 Jan 2014', 0),
    'Workdays between jan 4, 2014 jan 4, 2014 inclusive' => build_test('04 Jan 2014', '04 Jan 2014', 0),

     # Same day
    'Workdays between jan 3, 2014 jan 3, 2014'           => build_test('03 Jan 2014', '03 Jan 2014', 1),
    'Workdays between jan 3, 2014 jan 3, 2014 inclusive' => build_test('03 Jan 2014', '03 Jan 2014', 1),

     # Unambiguous date format with comma separator
    'Workdays between jan 6, 2014 jan 10, 2014'           => build_test('06 Jan 2014', '10 Jan 2014', 5),
    'Workdays between jan 6, 2014 jan 10, 2014 inclusive' => build_test('06 Jan 2014', '10 Jan 2014', 5),

     # Unambiguous date format
    'Workdays between jan 6 2014 jan 10 2014'           => build_test('06 Jan 2014', '10 Jan 2014', 5),
    'Workdays between jan 6 2014 jan 10 2014 inclusive' => build_test('06 Jan 2014', '10 Jan 2014', 5),

     # Single digit days and months - Dash format
    'Workdays between 1-6-2014 1-10-2014'           => build_test('06 Jan 2014', '10 Jan 2014', 5),
    'Workdays between 1-6-2014 1-10-2014 inclusive' => build_test('06 Jan 2014', '10 Jan 2014', 5),

     # Month and Date are backwards - Dash format
    'Workdays between 16-06-2014 20-06-2014' => build_test('16 Jun 2014', '20 Jun 2014', 5),
    'Workdays between 5-06-2014 20-06-2014'  => build_test('05 Jun 2014', '20 Jun 2014', 12),
    'Workdays between 20-06-2014 5-06-2014'  => build_test('05 Jun 2014', '20 Jun 2014', 12),

     # Business Days - Dash format
    'business days between 01-06-2014 01-10-2014'           => build_test('06 Jan 2014', '10 Jan 2014', 5),
    'business days between 01-06-2014 01-10-2014 inclusive' => build_test('06 Jan 2014', '10 Jan 2014', 5),

     # Workdays in a year - Dash format
    'Workdays between 01-01-2014 01-01-2015'           => build_test('01 Jan 2014', '01 Jan 2015', 251),
    'Workdays between 01-01-2014 01-01-2015 inclusive' => build_test('01 Jan 2014', '01 Jan 2015', 251),

     # Single digit days and months
    'Workdays between 1/6/2014 1/10/2014'           => build_test('06 Jan 2014', '10 Jan 2014', 5),
    'Workdays between 1/6/2014 1/10/2014 inclusive' => build_test('06 Jan 2014', '10 Jan 2014', 5),

     # Month and Date are backwards
     'Workdays between 16/06/2014 20/06/2014' => build_test('16 Jun 2014', '20 Jun 2014', 5),
     'Workdays between 5/06/2014 20/06/2014'  => build_test('05 Jun 2014', '20 Jun 2014', 12),
     'Workdays between 20/06/2014 5/06/2014'  => build_test('05 Jun 2014', '20 Jun 2014', 12),

     # Workdays in a year
     'Workdays between 01/01/2014 01/01/2015'           => build_test('01 Jan 2014', '01 Jan 2015', 251),
     'Workdays between 01/01/2014 01/01/2015 inclusive' => build_test('01 Jan 2014', '01 Jan 2015', 251),

     # Starting on a Sunday
     'Workdays between 01/12/2014 01/14/2014'           => build_test('12 Jan 2014', '14 Jan 2014', 2),
     'Workdays between 01/12/2014 01/14/2014 inclusive' => build_test('12 Jan 2014', '14 Jan 2014', 2),

     # Starting on a Saturday
     'Workdays between 01/11/2014 01/14/2014'           => build_test('11 Jan 2014', '14 Jan 2014', 2),
     'Workdays between 01/11/2014 01/14/2014 inclusive' => build_test('11 Jan 2014', '14 Jan 2014', 2),

     # Including the weekend -- Backwards
     'Workdays between 01/13/2014 01/06/2014'           => build_test('06 Jan 2014', '13 Jan 2014', 6),
     'Workdays between 01/13/2014 01/06/2014 inclusive' => build_test('06 Jan 2014', '13 Jan 2014', 6),

     # Including the weekend
     'Workdays between 01/06/2014 01/13/2014'           => build_test('06 Jan 2014', '13 Jan 2014', 6),
     'Workdays between 01/06/2014 01/13/2014 inclusive' => build_test('06 Jan 2014', '13 Jan 2014', 6),

     # Standard work week
     'Workdays between 01/06/2014 01/10/2014'           => build_test('06 Jan 2014', '10 Jan 2014', 5),
     'Workdays between 01/06/2014 01/10/2014 inclusive' => build_test('06 Jan 2014', '10 Jan 2014', 5),

     # Ending date first
     'Workdays between 01/10/2014 01/06/2014'           => build_test('06 Jan 2014', '10 Jan 2014', 5),
     'Workdays between 01/10/2014 01/06/2014 inclusive' => build_test('06 Jan 2014', '10 Jan 2014', 5),

     # Ending date on a weekend
     'Workdays between 01/06/2014 01/12/2014'           => build_test('06 Jan 2014', '12 Jan 2014', 5),
     'Workdays between 01/06/2014 01/12/2014 inclusive' => build_test('06 Jan 2014', '12 Jan 2014', 5),

     'business days between jan 10 and jan 20' => build_test(qr/10 Jan [0-9]{4}/, qr/20 Jan [0-9]{4}/, qr/[1-9]/, 'true'),
     'business days between january and february' => build_test(qr/01 Jan [0-9]{4}/, qr/01 Feb [0-9]{4}/, qr/[1-9][0-9]/, 'true'),

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
