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

my $indirect = qr/$dec_num$unit_prefix$data_suffix\s.*?\s$dec_num$unit_prefix$data_suffix$speed_suffix/i;
my $direct = qr/((download|dl|upload)\stime)|(data transfer)/i;

triggers query_lc => qr/.*?$direct|$indirect.*?/;

sub prefix_normalizer {
    my $val = shift;
    if($val =~ /^k.*/i) { return 1e3; }
    elsif($val =~ /^m.*/i) { return 1e6; }
    elsif($val =~ /^g.*/i) { return 1e9; }
    else { return 1e12; }
}

sub suffix_normalizer {
    my $val = shift;
    if($val =~ /^(\s)?(bit|b)(s?)$/) {
        return 1;
    }
    
    return 8;
}

handle query => sub {

    my $query = $_;
        
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
    
    return unless (/^.*?(?<dataval>$dec_num)(?<dtpref>$unit_prefix)(?<dtsuff>$data_suffix)\s.*?\s(?<speedval>$dec_num)(?<spdpref>$unit_prefix)(?<spdsuff>$data_suffix)$speed_suffix.*?$/i);
    
    my ($dataval, $speedval) = ($+{'dataval'}, $+{'speedval'});
    my $style = number_style_for($dataval, $speedval);
    $dataval = $style->for_computation($dataval);
    $speedval = $style->for_computation($speedval);
    
    my ($spdpref, $spdsuff, $dtpref, $dtsuff) = ($+{'spdpref'}, $+{'spdsuff'}, $+{'dtpref'}, $+{'dtsuff'});
    
    my $spdunit = prefix_normalizer($spdpref)*suffix_normalizer($spdsuff);
    my $dtunit = prefix_normalizer($dtpref)*suffix_normalizer($dtsuff);
    
    return '', structured_answer => {

            data => {
                title    => 'Download Time Calculator',
                speed => "$speedval",
                data => "$dataval",
                speedUnit => $spdunit,
                dataUnit => $dtunit,
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
