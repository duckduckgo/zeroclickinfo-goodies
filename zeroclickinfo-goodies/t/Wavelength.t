#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => "wavelength";
zci is_cached   => 1;

#input operation result
ddg_goodie_test(
    [qw( DDG::Goodie::Wavelength )],
    '1Hz wavelength'        => test_zci(mk_test(1,299792458,'Hz')),
    '1 MHz lambda VF=0.85'  => test_zci(mk_test(1,254.8235893,'MHz','Meters',0.85)),
    'lambda 0.001kHz'       => test_zci(mk_test(0.001,299792458,'kHz')),
    "λ 2400MHz"             => test_zci(mk_test(2400,12.4913524166667,'MHz','Centimeters')),
    "λ 2.4GHz"              => test_zci(mk_test(2.4,12.4913524166667,'GHz','Centimeters')),
    '144.39 MHz wavelength' => test_zci(mk_test(144.39,2.0762688413325)),
    'lambda 1500kHz'        => test_zci(mk_test(1500,199.861638666667,'kHz')),
    'lambda lambda lambda'  => undef,
);

done_testing;

sub mk_test {
    my ($freq_value,$wave_value,$freq_units,$wave_units,$vf) = @_;

    $freq_units ||= 'MHz';
    $wave_units ||= 'Meters';
            $vf ||= 1;
     my $vf_text = $vf == 1 ? '' : "$vf × ";

    my $expect = "λ = $wave_value $wave_units";
    return (
        $expect,
        structured_answer => {
            input => [],
            operation => "Wavelength of $freq_value $freq_units (${vf_text}Speed of light in a vacuum)",
            result => $expect,
        }
    );
}
