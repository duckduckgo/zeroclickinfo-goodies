#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "chord";
zci is_cached   => 1;


sub maximum{
    my @sorted = sort{ $a <=> $b } (@_);
    return $sorted[-1];
}
sub get_html_draw{
    my @fret = @_;
    my $length = maximum(@fret, (4));
    my $height = ($length * 25)+5 . "px";
    my $string_height = (($length * 25)) . "px";
    my $width = (@fret * 16) . "px";
    my $final = "<div class='chord' style='width: $width ;height: $height ;'>\n";
    $final .= "  <div class='topfret' style='width: $width'></div>\n";
    $final .= "  <div class='string' style='height: $string_height'></div>\n" x @fret;
    $final .= "  <div class='fret' style='width: $width'></div>\n" x $length;
    for(my $i = 0; $i < @fret; $i++){
        if($fret[$i] == 0){
            my $top = ($length * -25)-7 . "px";
            $final .= "  <div class='zeropoint' style='top: $top'></div>\n";
        }else{
            my $top = (($fret[$i] - ($length))*25)-19.5 . "px";
            $final .= "  <div class='point' style='top: $top'></div>\n";
        };
    };
    return $final . "</div>\n";
};
ddg_goodie_test(
    [qw(DDG::Goodie::Chord)],
    "C ukulele chord" => test_zci(
        "0-0-0-3",
        structured_answer => {
            input => ["C major "],
            operation => "Ukulele Chord",
            result => get_html_draw(0,0,0,3),
        },
    ),
    "a minor Guitar tab" => test_zci(
        "0-0-2-2-1-0",
        structured_answer => {
            input => ["A minor "],
            operation => "Guitar Chord",
            result => get_html_draw(0,0,2,2,1,0),
        }
    ),
    "Ebmaj7 ukulele chord" => test_zci(
        "2-2-2-4, 7-6-5-4",
        structured_answer => {
            input => ["Eb major 7th"],
            operation => "Ukulele Chord",
            result => get_html_draw(2,2,2,4) . get_html_draw(7,6,5,4),
        }
    ),
    "G chord" => undef,
    "G#maj6 guitar chord" => undef,
);

done_testing;
