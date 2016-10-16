package DDG::Goodie::CssAnimations;
# ABSTRACT: Shows examples of CSS Animations from various references

use DDG::Goodie;
use YAML::XS 'LoadFile';
use Data::Dumper;
use strict;
use warnings;

zci answer_type => 'css_animations';

zci is_cached => 1;

triggers start => 'css animations', 'css animations example', 'css animation', 'css animation examples', 
                  'css animation demo', 'css animations demos', 'css animations demos', 'css animation demos';

my $animations = LoadFile(share('data.yml'));

handle remainder => sub {
    my $demo_count = keys $animations;
    
    my @result = ();
    
    for (my $i=0; $i < $demo_count; $i++) {
        my $demo = "demo_$i";
        $animations->{$demo}->{'html'} = share("$demo/demo.html")->slurp if -e share("$demo/demo.html");
        $animations->{$demo}->{'css'} = share("$demo/style.css")->slurp if -e share("$demo/style.css");
        $animations->{$demo}->{'links'} = share("$demo/links.html")->slurp if -e share("$demo/links.html");
        push(@result, $animations->{$demo});
    }
    
    return 'CSS Animations',
        structured_answer => {
            id => 'css_animations',
            name => 'CSS Animations',
            data => \@result,
            templates => {
                group => 'base',
                detail => 0,
                item_detail => 0,
                options => {
                    content => 'DDH.css_animations.content'
                },
                variants => {
                    tile => 'xwide'
                }
            }
        };
};

1;
