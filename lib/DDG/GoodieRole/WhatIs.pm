package DDG::GoodieRole::WhatIs;
# ABSTRACT: Role for query matching.

use strict;
use warnings;

use Moo::Role;
use DDG::GoodieRole::WhatIs::Base;

sub _build_wi {
    my ($name, $sub) = @_;
    no strict 'refs';
    *$name = *{uc $name} = sub {
        my %options = ref $_[0] eq 'HASH' ? %{$_[0]} : @_;
        my %new_options = $sub->(%options);
        return DDG::GoodieRole::WhatIs::Base->new(%new_options);
    };
}

# Use for translations between systems where it makes sense to
# say 'What is X in Y?'.
_build_wi wi_translation => sub {
    my %got_options = @_;
    my $groups = ['translation'];
    push $groups, @{$got_options{groups}} if defined $got_options{groups};
    my %presets = (
        groups => $groups,
    );
    return (%got_options, %presets);
};

# Matcher with no defaults.
_build_wi wi_custom => sub { @_ };

1;

__END__

=head1 NAME

DDG::GoodieRole::WhatIs - abstracts query matching

=head1 SYNOPSIS

Including it in your Goodie:

    use DDG::Goodie;
    with 'DDG::GoodieRole::WhatIs';

Creating matchers:

    my $matcher = wi_translation(
        groups  => ['spoken', 'written'],
        options => {
            to => 'Goatee',
        },
    );

Retrieving values:

    my $result = $matcher->full_match("What is hello in Goatee?");
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

    my $matcher = entry(
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
    );

The following describes the entry functions and their intended
purposes.

=over

=item wi_translation()

When the query should be in a synonymous form with
"What is X in Y?".

=item wi_custom()

Use if you want to create a matcher with no presets.

=back

=head2 Modifiers

The modifiers allocated to your matcher determine what queries
will match, and the way in which they will be matched.

Modifiers are assigned based on which groups (attributes) have
been specified for your matcher. For example, having the
C<'translation'> and C<'spoken'> groups will cause the
C<'spoken translation'> modifier to be allocated.

Multiple modifiers may be assigned to a single matcher.

Each modifier has a set of optional and required options; if any
of the required options for a modifier are not set (see
L<Setting Modifier Options>) the package will die and tell you
which options need to be set. Optional options do not need to
be set and will not cause the package to die.

=head3 List of Modifiers

The following is a complete list of modifiers provided by
B<WhatIs>.

In each case:

'Form' is a representative example of the types
of queries the modifier will match. The form is in bold so as
to make it easier to locate the desired modifier.

'Required Groups' is a list of groups that must be specified
for the modifier to be assigned.

'Required Options' is a list of options that must be specified
when using this modifier.

'Optional Options' is a list of options that can be optionally
specified when using this group.

=over

=item C<written translation>

Form: B<"How do I write PRIMARY in TO?">

Required Groups: C<translation>, C<written>.

Required Options: C<to>.

Optional Options: C<primary>.

=item C<spoken translation>

Form: B<"How do I say PRIMARY in TO?">

Required Groups: C<translation>, C<spoken>.

Required Options: C<to>.

Optional Options: C<primary>.

=item C<language translation>

Form: B<"Translate PRIMARY to TO">

Required Groups: C<translation>, C<language>.

Required Options: C<to>.

Optional Options: C<primary>.

=item C<what is conversion>

Form: B<"What is PRIMARY in TO?">

Required Groups: C<translation>.

Required Options: C<to>.

Optional Options: C<primary>.

=item C<meaning>

Form: B<"What is the meaning of PRIMARY?">

Required Groups: C<meaning>.

Required Options: I<None>.

Optional Options: C<primary>.

=item C<conversion to>

Form: B<"Convert PRIMARY to TO">

Required Groups:

=over

C<conversion>, C<bidirectional> I<or> C<conversion>, C<to>.

=back

Required Options: C<to>.

Optional Options: C<primary>, C<unit>.

=item C<conversion from>

Form: B<"PRIMARY from FROM">

Required Groups:

=over

C<conversion>, C<bidirectional> I<or> C<conversion>, C<from>.

=back

Required Options: C<from> I<or> C<to>.

Optional Options: C<primary>.

=item C<conversion in>

Form: B<"PRIMARY in TO">

Required Groups: C<conversion>.

Required Options: C<to>.

Optional Options: C<primary>.

=item C<prefix imperative>

Form: B<"PREFIX_COMMAND PRIMARY">

Required Groups: C<prefix>, C<imperative>.

Required Options: C<prefix_command> I<or> C<command>.

Optional Options: C<primary>.

=item C<postfix imperative>

Form: B<"PRIMARY POSTFIX_COMMAND">

Required Groups: C<postfix>, C<imperative>.

Required Options: C<postfix_command> I<or> C<command>.

Optional Options: C<primary>.

=item C<targeted property>

Form:

=over

B<"What is the SINGULAR_PROPERTY of PRIMARY?">,

B<"What are the PLURAL_PROPERTY of PRIMARY?">

=back

Required Groups: C<property>.

Required Options:

=over

C<singular_property> I<or> C<property>,

C<plural_property> I<or> C<singular_property>.

=back

Optional Options: C<primary>.

=back

=head2 Groups

You use groups to specify certain properties of your Goodie that
you want to be reflected in the queries that your Goodie will
match.

There is no guarantee that adding a particular group will
actually change the way in which your query is processed - often
more than one group will need to be combined to produce a
particular effect.

The following is a list of available groups:

=over

=item translation

Use if your Goodie performs conversions between one thing and
another.

=item written

It makes sense to want to I<write> your answer.

=item spoken

It makes sense to want to I<say> your answer.

=item meaning

The Goodie produces a meaning from the query.

=back

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
    my $matcher = wi_translation(
        groups  => ['spoken', 'written'],
        options => {
            to => 'Goatee',
        },
    );

    handle query_raw => sub {
        my $query = $_;
        my $match_result = $matcher->full_match($query) or return;
        my $to_translate = $match_result->{primary};
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
