package DDG::Goodie::Shuffle;
# ABSTRACT: Randomly order a given list

use strict;
use warnings;
use utf8;
use DDG::Goodie;

use List::Util qw( shuffle );

with qw(DDG::GoodieRole::Parse::List);

zci answer_type => 'shuffle';

zci is_cached => 0;

my @start_words = ('shuffle', 'sort', 'order');
my @end_words = ('shuffled', 'sorted', 'ordered');

my @start_phrases = (
    'shuffle',
    (map { "randomly $_" } @start_words),
    (map { "random $_" } @start_words),
);

my @end_phrases = (
    'in a random order',
    (map { "randomly $_" } @end_words),
    (map { "random $_" } @start_words),
    'shuffled',
);

triggers start => @start_phrases;
triggers end => @end_phrases;

my @parens = (
    '[' => ']',
    '(' => ')',
    '{' => '}',
);

my $max_range = 30;

sub parse_range {
    my $range = shift;
    $range =~ /^(?:
         (?<numeric>(?<lower>\-?\d+)\.\.(?<upper>\d+))
        |(?<lower>[[:ascii:]])\.\.(?<upper>[[:ascii:]]))$/x or return;
    my ($lower, $upper) = ("$+{lower}", "$+{upper}");
    my ($lower_int, $upper_int) =
        $+{numeric} ? ($lower, $upper) : (ord $lower, ord $upper);
    return if abs ($upper_int - $lower_int) >= $max_range;
    my @result = $lower..$upper;
    return @result;
}

sub shuffle_parse_list {
    my $list_text = shift;
    my @parse = @{parse_list($list_text)};
    @parse == 1 ? parse_range($parse[0]) : @parse;
}

handle remainder => sub {

    my $remainder = $_;
    return if $remainder eq '';

    my @items = shuffle_parse_list($remainder) or return;
    return unless $#items;
    srand;
    my @shuffled = shuffle @items;
    my $shuffled_display = format_list(\@shuffled);
    my $original_display = format_list(\@items);
    return "$original_display",
        structured_answer => {

            data => {
                title    => "$shuffled_display",
                subtitle => "Shuffle: $original_display",
                # Useful for API
                items    => \@shuffled,
            },

            templates => {
                group => "text",
            }
        };
};

1;
