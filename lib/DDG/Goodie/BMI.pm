package DDG::Goodie::BMI;
# ABSTRACT: Write an abstract here

# Start at http://docs.duckduckhack.com/walkthroughs/calculation.html if
# you are new to instant answer development

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'bmi';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;


triggers any => 'bmi', 'body mass index';

# Handle statement
handle remainder => sub {

    my $remainder = $_;
 

    return unless $remainder;


    # return unless $remainder =~ qr/^(\d+\s*cm\s*\d+\s*kg)|(\d+\s*kg\s*\d+\s*cm)$/;
    
    my $height;
    my $weight;
    my @nums;
    
    if ($remainder =~ qr/^\s*\d+\s*cm\s*\d+\s*kg\s*$/){
        @nums = $remainder =~ /(\d+)/g;
        $height = $nums[0]/100;
        $weight = $nums[1];   
    } elsif ($remainder =~ qr/^\s*\d+\s*kg\s*\d+\s*cm\s*$/){
        @nums = $remainder =~ /(\d+)/g;
        $height = $nums[1]/100;
        $weight = $nums[0];   
    } else {
        return;
    }
    

    
    my $bmi_raw = $weight/($height*$height);
    
    my $bmi = sprintf "%.1f", $bmi_raw;

    return "Your BMI is $bmi",
        structured_answer => {
            id => 'bmi',
            name => 'Answer',

            data => {
                title    => "BMI",
                subtitle => "Your BMI is $bmi",
                # image => 'http://website.com/image.png',
            },

            templates => {
                group => 'text',
                # options => {
                #
                # }
            }
        };
};

1;
