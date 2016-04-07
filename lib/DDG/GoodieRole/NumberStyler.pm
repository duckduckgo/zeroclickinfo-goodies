package DDG::GoodieRole::NumberStyler;
# ABSTRACT: A role to allow Goodies to recognize and work with numbers in different notations.

use strict;
use warnings;

use Moo::Role;

use Devel::StackTrace;
use List::Util qw( all first );
use Package::Stash;
use Try::Tiny;

use DDG::GoodieRole::NumberStyler::Format;


sub number_style_regex {
    my $format = _get_format();
    return $format->number_regex();
}

sub number_style {
    return _get_format();
}

sub parse_text_to_number {
    my $number = shift;
    my $format = number_style();
    return $format->parse_number($number);
}

sub _get_format {
    return DDG::GoodieRole::NumberStyler::Format->new(
        locale => (_get_locale() || 'none'),
    );
}

sub _get_locale {
    my $lang = _fetch_stash('$lang') or return;
    return $lang->locale;
}

sub _fetch_stash {
    my $name = shift;

    my $result = try {
        # Dig through how we got here, ignoring
        my $hit = 0;
        # We only care about the most recent caller who is some kinda goodie-looking thing.
        my $frame_filter = sub {
            my $frame_info = shift;
            if (!$hit && $frame_info->{caller}[0] =~ /^DDG::Goodie::/) {
                $hit++;
                return 1;
            }
            else {
                return 0;
            }
        };
        my $trace = Devel::StackTrace->new(
            frame_filter => $frame_filter,
            no_args      => 1,
        );
        # Get the package info for our caller.
        my $stash = Package::Stash->new($trace->frame(0)->package);
        # Give back the $name variable on their package
        ${$stash->get_symbol($name)};
    };
    return $result;
}

1;
