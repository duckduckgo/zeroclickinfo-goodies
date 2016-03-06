package DDG::GoodieRole::WhatIs;
# ABSTRACT: Role for query matching.

use strict;
use warnings;

use Moo::Role;
use DDG::GoodieRole::WhatIs::Matcher;

# Custom matcher with no presets.
sub wi_custom {
    return DDG::GoodieRole::WhatIs::Matcher->new(@_);
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

    my $matcher = wi_custom(
        groups  => ['translation', 'verb'],
        options => {
            to      => 'Goatee',
            verb    => qr/(say|write)/i,
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
instead allowing you to specify certain L<groups> and L<options>
which represent properties of your Goodie, and then provides a simple
interface through which matches can be performed.

=head2 Entries

To create a matcher, you use the functions, prefixed with C<wi_>,
that are available after using the role.

Entries are used like so:

    my $matcher = entry(
        # Specify relevant groups.
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

=item wi_custom()

Use if you want to create a matcher with no presets.

=back

=head2 Modifiers

The modifiers allocated to your matcher determine what queries
will match, and the way in which they will be matched.

Modifiers are assigned based on which groups (attributes) have
been specified for your matcher. For example, having the
C<command> group will cause the C<command> modifier to be
allocated.

Multiple modifiers may be assigned to a single matcher.

Each modifier has a set of associated options which it uses to
customize matching to suit your needs. Some options are required,
others optional; if any of the required options for a modifier are
not set (see L<Setting Modifier Options>) the package will die and
tell you which options need to be set. Optional options do not need
to be set and will not cause the package to die.

=head3 List of Modifiers

The following is a complete list of modifiers provided by
B<WhatIs>.

In each case:

'Form' is a representative example of the types
of queries the modifier can match. The form is in bold so as
to make it easier to locate the desired modifier. Additional
forms may be enabled when certain options are specified - these
are also in bold.

'Required Groups' is a list of groups that must be specified
for the modifier to be assigned.

'Options' is a list of options supported by the modifier.
Options may be followed by: I<Required> - meaning the option
must always be specified; I<Optional> - meaning the option may
always be omitted; or nothing, in which case whether the option
is required is dependant upon which other options are set - any
error messages should indicate which options can be used in
place of others.

'Results' is a list of non-standard properties that will be
available in the match result. See L<Results> for more
information on results.

=over

=item C<verb translation>

Form: B<"How to VERB PRIMARY UNIT in TO?">

Required Groups: C<translation>, C<verb>.

Options:

=over

=item C<verb> (I<Required>)

Matches B<VERB>.

=item C<to> (I<Required>)

See L<Standard Options>.

=item C<primary> (I<Optional>)

See L<Standard Options>.

=item C<unit> (I<Optional>)

See L<Standard Options>

=back

Results: No non-standard results.

=item C<language translation>

Form: B<"Translate PRIMARY to TO">

Required Groups: C<translation>, C<language>.

Options:

=over

=item C<to>

Enables matching of forms such as:

B<"Translate PRIMARY to TO">

=item C<from>

Enables matching of forms such as:

B<"Translate PRIMARY from FROM">

=item C<primary> (I<Optional>)

See L<Standard Options>.

=back

Results: No non-standard results.

=item C<conversion>

Form: B<"Convert PRIMARY UNIT to TO">

Required Groups: C<conversion>.

Options:

=over

=item C<to>

Enables matching of forms such as:

B<"What is PRIMARY UNIT in TO?">

B<"PRIMARY UNIT to TO">

=item C<from>

Enables matching of forms such as:

B<"PRIMARY UNIT from FROM">

=back

Results: No non-standard results.

=item C<command>

Form: B<"COMMAND PRIMARY">

Options:

=over

=item C<command>

Enables matching forms such as:

B<"COMMAND PRIMARY">

B<"PRIMARY COMMAND">

=item C<prefix_command>

Enables matching forms such as:

B<"PREFIX_COMMAND PRIMARY">

=item C<postfix_command>

Enables matching forms such as:

B<"PRIMARY POSTFIX_COMMAND">

=back

Results: No non-standard results.

=item C<property>

Form: B<"What is the PROPERTY of PRIMARY?">

Options:

=over

=item C<property>

Enables matching forms such as:

B<"What is the PROPERTY of PRIMARY?">

B<"What are the PROPERTYs of PRIMARY?">

=item C<singular_property>

Enables matching forms such as:

B<"What is the SINGULAR_PROPERTY of PRIMARY?">

=item C<plural_property>

Enables matching forms such as:

B<"What are the PLURAL_PROPERTY of PRIMARY?">

=back

Results:

=over

=item C<is_plural>

Values: I<Boolean>

True if a plural form matched, false otherwise.

=back

=back

=head2 Results

Upon a successful match, a matcher will return a hash with
values accessible through the attributes specified in
L<Modifiers>.

The following is a list of the results and their standard
meanings:

=over

=item C<direction>

The direction of a translation, either C<from> or C<to>.

=item C<is_plural>

C<1> if the trigger used a plural form, C<0> otherwise.

=item C<primary>

The main target of a match - this is the general 'result'.

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
    my $matcher = wi_custom(
        groups  => ['translation', 'verb'],
        options => {
            to   => 'Goatee',
            verb => qr/(say|write)/i,
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
