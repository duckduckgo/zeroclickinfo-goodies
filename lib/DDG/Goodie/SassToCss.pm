package DDG::Goodie::SassToCss;
# ABSTRACT: Write an abstract here

use DDG::Goodie;
use YAML::XS 'LoadFile';
use POSIX;
use Text::Trim;
use strict;
use warnings;

zci answer_type => 'sass_to_css';

zci is_cached => 1;


my $goodieVersion = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;


# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers any => share('triggers.txt')->slurp;

handle remainder => sub {

    # Return unless the remainder is empty or contains online or tool
    return unless ( $_ =~ /(^$|online|tool)/i );

    return '',
        structured_answer => {

            id => "sass_to_css",

            data => {
                title => 'Sass to Css Converter',
                subtitle => 'Enter SASS below, then click the button to convert it to CSS'
            },

            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.sass_to_css.content'
                }
            }
        };
};

1;
