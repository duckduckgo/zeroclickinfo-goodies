package DDG::Goodie::CssAnimations;
# ABSTRACT: Shows examples of CSS Animations from various references

use DDG::Goodie;
use YAML::XS 'LoadFile';
use strict;
use warnings;
use JSON;

zci answer_type => 'css_animations';

zci is_cached => 1;

triggers start => 'css animations', 'css animations example', 'css animation', 'css animation examples', 
                  'css animation demo', 'css animations demos', 'css animations demo', 'css animation demos';

my $animations = LoadFile(share('data.yml'));

sub build_response() {

    my $demo_count = keys %{$animations};
    
    my @result = ();
    
    for (my $i=0; $i < $demo_count; $i++) {
        my $demo = "demo_$i";
        my $title = $animations->{$demo}->{'title'};
        my $html = share("$demo/demo.html")->slurp if -e share("$demo/demo.html");
        my $css = share("$demo/style.css")->slurp if -e share("$demo/style.css");
        my %value = ('title' => $title, 'html' => $html, 'css' => $css);
        
        $animations->{$demo}->{'html'} = $html || '';
        $animations->{$demo}->{'css'} = $css || '';
        $animations->{$demo}->{'value'} = encode_json \%value || '';
        push(@result, $animations->{$demo});
    }
    
    return @result;
}

my @result = build_response();

handle remainder => sub {
    return unless $_ eq '';
    
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
