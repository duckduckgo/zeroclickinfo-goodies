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
        return ($text, parens => [$opening, $closing]);
    }
    return $text;
}

sub trim_whitespace {
    my $to_trim = shift;
    $to_trim =~ s/^\s+//ro =~ s/\s+$//ro;
}

sub is_list {
    my ($text, %options) = @_;
    my $parens = join '', @{$options{parens}};
    return $text =~ qr/^$RE{balanced}{-parens=>$parens}$/ ? 1 : 0;
}

sub verify_items {
    my ($item_re, $nested, $items) = @_;
    my @items = @$items;
    return all { $_ =~ /^$item_re$/ } @items unless $nested;
    return all {
        ref $_ eq 'ARRAY'
            ? verify_items($item_re, $nested, $_)
            : $_ =~ /^$item_re$/;
    } @items;
}

# Parse a list of items
#
# Options:
#
# C<item> - regex each item must match. Default is C<.*?\S>
# Items must I<fully> match (implied qr/^...$/).
#
# C<nested> - boolean whether nested lists should be parsed;
# default true. If C<item> is specified then it defaults to false.
sub parse_list {
    my ($list_text, %options) = @_;

    return unless ($list_text // '') ne '';
    my %defaults = (
        item   => qr/.*?\S/o,
        nested => $options{item} ? 0 : 1,
    );
    %options = (%defaults, %options);
    my $item = $options{item};

    ($list_text, my %parens) = remove_parens($list_text);
    return [] if $list_text eq '';
    my $sep = get_separator($list_text);
    my $parens = join '', @{$parens{parens} // []};
    my $record = Data::Record->new({
        split => $sep,
        unless => $options{nested} && $parens ? qr/(?:$RE{quoted}|$RE{balanced}{-parens=>$parens})/ : $RE{quoted},
    });
    my @raw_items = map { trim_whitespace $_ } $record->records($list_text);
    my @items = $options{nested} && %parens ? map {
        is_list($_, %parens) ? parse_list($_, %options, %parens) : $_;
    } @raw_items : @raw_items;
    return unless verify_items($item, $options{nested}, \@items);
    return \@items;
}

sub format_list {
    my $items = shift;
    return "[@{[join ', ', @$items]}]";
}

1;
