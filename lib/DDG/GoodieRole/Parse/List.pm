package DDG::GoodieRole::Parse::List;
# ABSTRACT: Parse and format lists.

use strict;
use warnings;
use utf8;

use List::Util qw( all pairs );
use Data::Record;
use Regexp::Common;

use Moo::Role;

my @parens = (
    '[' => ']',
    '(' => ')',
    '{' => '}',
);

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
    return $text;
}

sub trim_whitespace {
    my $to_trim = shift;
    $to_trim =~ s/^\s+//ro =~ s/\s+$//ro;
}

# Parse a list of items
#
# Options:
#
# C<item> - regex each item must match. Default is C<.*?\S>
# Items must I<fully> match (implied qr/^...$/).
sub parse_list {
    my ($list_text, %options) = @_;

    return unless ($list_text // '') ne '';
    my $item = $options{item} // qr/.*?\S/o;

    $list_text = remove_parens($list_text);
    return [] if $list_text eq '';
    my $sep = get_separator($list_text);
    my $record = Data::Record->new({
        split => $sep,
        unless => $RE{quoted},
    });
    my @items = map { trim_whitespace $_ } $record->records($list_text);
    return unless all { $_ =~ /^$item$/ } @items;
    return \@items;
}

sub format_list {
    my $items = shift;
    return "[@{[join ', ', @$items]}]";
}

1;
