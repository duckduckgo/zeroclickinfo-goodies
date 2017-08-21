package DDG::Goodie::DownloadTimeCalculator;
# ABSTRACT: Write an abstract here

# Start at http://docs.duckduckhack.com/walkthroughs/calculation.html if
# you are new to instant answer development

use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';
use strict;
use warnings;

zci answer_type => 'download_time_calculator';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
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
    #print $val;
    if($val =~ /^(\s)?(bit|b)(s?)$/) {
        return 1;
    }
    
    return 8;
}

# Handle statement
handle query => sub {

    my $query = $_;

    # Optional - Guard against no remainder
    # I.E. the query is only 'triggerWord' or 'trigger phrase'
    #
    # return unless $remainder;

    # Optional - Regular expression guard
    # Use this approach to ensure the remainder matches a pattern
    # I.E. it only contains letters, or numbers, or contains certain words
    #
    # return unless qr/^\w+|\d{5}$/;
        
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
