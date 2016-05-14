package DDG::Goodie::Shuffle;
# ABSTRACT: Randomly order a given list

use strict;
use warnings;
use utf8;
use DDG::Goodie;

use List::Util qw( shuffle pairs );
use Data::Record;
use Regexp::Common;

zci answer_type => 'shuffle';

zci is_cached => 1;

triggers start => 'shuffle';
triggers end   => 'shuffled';

my @parens = (
    '[' => ']',
    '(' => ')',
    '{' => '}',
);

my $record = Data::Record->new({
    split => ',',
    unless => $RE{quoted},
});

sub remove_parens {
    my $text = shift;
    foreach (pairs @parens) {
        my ($opening, $closing) = map { quotemeta $_ } @$_;
        next unless $text =~ /^$RE{balanced}{-parens=>"$opening$closing"}$/;
        $text =~ s/^$opening(.+?)$closing$/$1/;
        return $text;
    }
    return;
}

sub trim_whitespace {
    my $to_trim = shift;
    $to_trim =~ s/^\s+//ro =~ s/\s+$//ro;
}

sub parse_list {
    my $list_text = shift;
    $list_text = remove_parens($list_text) or return;
    my @items = map { trim_whitespace $_ } $record->records($list_text);
    return @items;
}

sub display_list {
    my @items = @_;
    return "[@{[join ', ', @items]}]";
}

handle remainder => sub {

    my $remainder = $_;

    my @items = parse_list($remainder);
    my @shuffled = shuffle @items;
    my $shuffled_display = display_list @shuffled;
    my $original_display = display_list @items;
    return "$original_display",
        structured_answer => {

            data => {
                title    => "$shuffled_display",
                subtitle => "Shuffle: $original_display",
                # Useful for API
                items    => \@items,
            },

            templates => {
                group => "text",
            }
        };
};

1;
