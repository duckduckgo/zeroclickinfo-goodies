package DDG::Goodie::Wavelength;
# ABSTRACT: Frequency to wavelength

use utf8;
use DDG::Goodie;

use constant SPEED_OF_LIGHT => 299792458; #meters/second
use constant MULTIPLIER => {
     hz => 1,
    khz => 10**3,
    mhz => 10**6,
    ghz => 10**9,
    thz => 10**12
};
use constant FORMAT_UNITS => {
     hz => 'Hz',
    khz => 'kHz',
    mhz => 'MHz',
    ghz => 'GHz',
    thz => 'THz'
};

zci answer_type => "wavelength";
zci is_cached   => 1;

# Triggers
triggers any => "λ", "wavelength", "lambda";

# Handle statement
handle remainder => sub {
    my ($query) = @_;
    my ($freq,$units) = $query =~ m/([\d\.]+)\s*((k|M|G|T)?hz)/i;
    return unless $freq and $units;

    my ($vf) = $query =~ m/\bvf[ =]([\d\.]+)/i;
    $vf = 1 if (!$vf or $vf>1 or $vf<0);

    my $velocity_text = ($vf == 1 ? '' : "$vf × ").'Speed of light in a vacuum';

    my $mul     = MULTIPLIER->{lc($units)};
    my $hz_freq = $freq * $mul * (1/$vf);

    my $output_value = (SPEED_OF_LIGHT / $hz_freq);
    my $output_units = 'Meters';

    # Express higher freqs in cm/mm.
    # eg UHF 70cm band, microwave 3mm, etc
    if ($output_value<1) {
        $output_units = 'Centimeters';
        $output_value *= 100;
        if ($output_value<1) {
            $output_units = 'Millimeters';
            $output_value *= 10;
        }
    }

    my $result_text    = "λ = $output_value $output_units";
    my $operation_text = "Wavelength of $freq ".FORMAT_UNITS->{lc($units)}." ($velocity_text)";

    return $result_text, structured_answer => {
        data => {
            title => $result_text,
            subtitle => $operation_text
        },
        templates => {
            group => 'text'
        }
    };
};

1;
