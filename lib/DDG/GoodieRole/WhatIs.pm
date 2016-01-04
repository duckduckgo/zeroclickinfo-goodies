package DDG::GoodieRole::WhatIs;
# ABSTRACT: Role for query matching.

use strict;
use warnings;

use Moo::Role;
use DDG::GoodieRole::WhatIs::Base;

# Use for translations between systems where it makes sense to
# say 'What is X in Y?'.
sub wi_translation {
    my $got_options = shift;
    my $groups = ['translation'];
    push $groups, @{$got_options->{groups}} if defined $got_options->{groups};
    my $presets = {
        groups => $groups,
    };
    my %options = (%$got_options, %$presets);
    return DDG::GoodieRole::WhatIs::Base->new(\%options);
}

# Matcher with no defaults.
sub wi_custom {
    return DDG::GoodieRole::WhatIs::Base->new($_[0]);
}

1;

__END__

=head1 NAME

DDG::GoodieRole::WhatIs - abstracts query matching

=head1 SYNOPSIS

Including it in your Goodie:

    use DDG::Goodie;
    with 'DDG::GoodieRole::WhatIs';

Creating matchers:

    my $matcher = wi_translation({
        groups  => ['spoken', 'written'],
        options => {
            to => 'Goatee',
        },
    });

Retrieving values:

    my $result = $matcher->match("What is hello in Goatee?");
    my $value = $result->{primary};
    print $value;
    # 'hello'

=head1 DESCRIPTION

L<DDG::GoodieRole::WhatIs> aims to make writing new Goodies,
as well as ensuring they are accessible, as easy as possible!
It does this by reducing the need for complex regular expressions,
instead allowing you to specify certain properties of your Goodie
(it is a C<'translation'>, makes sense to be called C<'written'>)
and have the Role do the hard work.

=head2 Entries

To create a matcher, you use the functions, prefixed with C<wi_>,
that are available after using the role.

Entries are used like so:

    my $matcher = entry({
        # Optionally specify any additional groups.
        groups => [group1, group2, group3, ...],
        # Optionally specify any modifier-specific options.
        # Some modifiers may have required options that will
        # cause the creation of the matcher to fail if they
        # aren't specified.
        options => {
            option1 => value1,
            option2 => value2,
            ...
        },
    });

The following describes the entry functions and their intended
purposes.

=over

=item wi_translation()

When the query should be in a synonymous form with
"What is X in Y?".

=item wi_custom()

Use if you want to create a matcher with no presets.

=back

=head2 Groups

You use groups to specify certain properties of your Goodie that
you want to be reflected in the queries that your Goodie will
match.

B<Coming Soon!>

=head1 EXAMPLES

This is an example of a Goodie that takes English and translates
it to a made-up language called 'Goatee'.

The aim is for queries such as "How do I write X in Goatee?",
"What is X in Goatee?", and so forth to be matched.

    use DDG::Goodie;
    with 'DDG::GoodieRole::WhatIs';

    triggers any => 'goatee';

    zci is_cached   => 1;
    zci answer_type => 'goatee';

    sub english_to_goatee {
        # Hello -> baah baah baah baah baah
        return $_[0] =~ s/\w/baah /gr;
    }

    # The Goatee Goodie performs a translation,
    # it makes sense to be able to say "How do I say...",
    # it makes sense to be able to say "How do I write..."
    my $matcher = wi_translation({
        groups  => ['spoken', 'written'],
        options => {
            to => 'Goatee',
        },
    });

    handle query_raw => sub {
        my $query = $_;
        my $match_result = $matcher->match($query) or return;
        my $to_translate = $match_result->{primary} or return;
        my $result = english_to_goatee $to_translate;

        return $result,
            structured_answer => {
               id   => 'goatee',
               name => 'Answer',
               data => {
                   title    => "$result",
                   subtitle => "Translate $to_translate to Goatee",
               },
               templates => {
                   group  => 'text',
                   moreAt => 0,
               },
            };
    };

=head1 AUTHOR

Ben Moon aka GuiltyDolphin E<lt>guiltydolphinE<64>gmail.comE<gt>

=cut
