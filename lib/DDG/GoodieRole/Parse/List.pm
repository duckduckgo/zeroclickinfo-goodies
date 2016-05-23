package DDG::GoodieRole::Parse::List;
# ABSTRACT: Parse and format lists.

use strict;
use warnings;
use utf8;

use List::Util qw( shuffle pairs );
use Data::Record;
use Regexp::Common;

use Moo::Role;

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

sub is_conj {
    return shift =~ qr/^$RE{list}{and}$/i;
}

sub get_separator {
    my $text = shift;
    my $comma_sep = qr/\s*,\s*/io;
    return qr/(?:\s*,?\s*and\s*|$comma_sep)/io if is_conj($text);
    return $comma_sep;
}

sub remove_parens {
    my $text = shift;
    foreach (pairs @parens) {
        my ($opening, $closing) = map { quotemeta $_ } @$_;
        next unless $text =~ /^$RE{balanced}{-parens=>"$opening$closing"}$/;
        $text =~ s/^$opening(.*?)$closing$/$1/;
        return $text;
    }
    return $text if is_conj($text);
    return;
}

sub trim_whitespace {
    my $to_trim = shift;
    $to_trim =~ s/^\s+//ro =~ s/\s+$//ro;
}

sub parse_list {
    my $list_text = shift;
    $list_text = remove_parens($list_text)
        // return parse_range($list_text);
    if (my @items = parse_range($list_text)) {
        return @items;
    }
    my $sep = get_separator($list_text);
    my $record = Data::Record->new({
        split => $sep,
        unless => $RE{quoted},
    });
    my @items = map { trim_whitespace $_ } $record->records($list_text);
    return \@items;
}

sub display_list {
    my @items = @_;
    return "[@{[join ', ', @items]}]";
}

1;
