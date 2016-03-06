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
instead allowing you to specify certain L</Groups> and L</Options>
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
not set (see S<L</Setting Modifier Options>>) the package will die
and tell you which options need to be set. Optional options do not
need to be set and will not cause the package to die.

=head3 List of Modifiers

The following is a complete list of modifiers provided by B<WhatIs>.

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
is required is dependent upon which other options are set - any
error messages should indicate which options can be used in
place of others.

'Results' is a list of non-standard properties that will be
available in the match result. See L</Results> for more
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

See S<L</Standard Options>>.

=item C<primary> (I<Optional>)

See S<L</Standard Options>>.

=item C<unit> (I<Optional>)

See S<L</Standard Options>>.

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

See S<L</Standard Options>>.

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

Results:

=over

=item C<command>

Will take the value of the match from whichever of C<command>,
C<prefix_command>, or C<postfix_command> matched.

=back

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

C<1> if a plural form matched, C<0> otherwise.

=item C<property>

Will take the value of the match from whichever of C<property>,
C<singular_property>, or C<plural_property> matched.

=back

=back

=head2 Results

Upon a successful match, a matcher will return a hash reference
with values accessible through the attributes specified in
L</Modifiers>.

In any of the forms specified in L</Modifiers>, words shown in
S<B<BOLD CAPITALS>> are always accessible through the same
(lowercase) name in the results hash.

For example, the C<conversion> modifier (with the C<to> option), can
match the form B<"Convert PRIMARY UNIT to TO">. In this case, each of
C<primary>, C<unit>, and C<to> could be accessed through the options
hash to retrieve the match at those positions.

  ...
  my $match = $matcher->full_match("Convert 5 ounces to kilograms");
  print $match->{primary};
  # '5'
  print $match->{unit};
  # 'ounces'
  print $match->{to};
  # 'kilograms'

=head3 Standard Results

The following results have a standard meaning across different
modifiers:

=over

=item C<direction>

The direction of a translation, either C<from> or C<to>.

Accessible whenever the C<to> or C<from> options are specified.

=item C<primary>

The main target of a match - this is the general 'result'.

=back

=head2 Groups

=head3 Specifying Groups

You specify groups through the C<groups> option in an
L<entry|/Entries>.

  ...
  my $matcher = wi_custom(
      groups => ['group1', 'group2', ...]
  ...

The supported groups are covered in L</Modifiers>.

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
