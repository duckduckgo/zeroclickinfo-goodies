package DDG::Goodie::DownloadTimeCalculator;
# Download Time Calculator: Calculates time required to
# download a file given data and connection speed.

use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';
use strict;
use warnings;

zci answer_type => 'download_time_calculator';

zci is_cached => 1;

my $dec_num = number_style_regex();
my $unit_prefix = qr/(\s)?(k|m|g|t|kilo|mega|giga|ter(r?)a|)/i;
my $data_suffix = qr/(\s)?(bit|byte|b)(s?)/i;
my $speed_suffix = qr/(\s)?((ps)|(per sec(ond)?))/i;

# Triggers for verbose queries.
my $indirect = qr/$dec_num$unit_prefix$data_suffix.*?$dec_num$unit_prefix$data_suffix$speed_suffix/i;

# Triggers for direct requests.
my $direct = qr/((download|dl|upload)\stime)|(data transfer)/i;

triggers query_lc => qr/.*?$direct|$indirect.*?/;

# Find prefix multiplier.
sub prefix_normalizer {
    my $val = shift;
    if($val =~ /^k.*/i) { return 1e3; }
    elsif($val =~ /^m.*/i) { return 1e6; }
    elsif($val =~ /^g.*/i) { return 1e9; }
    else { return 1e12; }
}

# Differentiate between bit/byte.
sub suffix_normalizer {
    my $val = shift;
    if($val =~ /^(\s)?(bit|b)(s?)$/) {
        return 1;
    }
    else {
        return 8;
    }
}

handle query => sub {

    my $query = $_;
    
    # Handle non-verbose queries
    if($query !~ /$indirect/i) {
        return '', structured_answer => {

                data => {
                    title    => 'Download Time Calculator',
                    speed => '',
                    data => '',
                    speedUnit => '',
                    dataUnit => '',
                },
            
                templates => {
                    group => 'text',
                    options => {
                        content => 'DDH.download_time_calculator.content'
                    }
                }
        };
    }
    
    # Handle verbose queries(same as $indirect trigger).
    return unless (/^.*?(?<dataval>$dec_num)(?<dtpref>$unit_prefix)(?<dtsuff>$data_suffix).*?(?<speedval>$dec_num)(?<spdpref>$unit_prefix)(?<spdsuff>$data_suffix)$speed_suffix.*?$/i);
    
    my ($dataval, $speedval, $speedpref, $speedsuff, $datapref, $datasuff) = ($+{'dataval'}, $+{'speedval'}, $+{'spdpref'}, $+{'spdsuff'}, $+{'dtpref'}, $+{'dtsuff'});
    
    # Stylize to pass to front-end
    my $style = number_style_for($dataval, $speedval);
    $dataval = $style->for_computation($dataval);
    $speedval = $style->for_computation($speedval);
    
    #Calculate symbol for front-end selector
    my $speedunit = prefix_normalizer($speedpref)*suffix_normalizer($speedsuff);
    my $dataunit = prefix_normalizer($datapref)*suffix_normalizer($datasuff);
    
    return '', structured_answer => {

            data => {
                title    => 'Download Time Calculator',
                speed => "$speedval",
                data => "$dataval",
                speedUnit => $speedunit,
                dataUnit => $dataunit,
            },
            
            templates => {
                group => 'text',
                options => {
                    content => 'DDH.download_time_calculator.content'
                }
            }
    };
};

1;

