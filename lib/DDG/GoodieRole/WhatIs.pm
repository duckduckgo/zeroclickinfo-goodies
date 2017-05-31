package DDG::GoodieRole::WhatIs;
# ABSTRACT: Role for query matching.

use strict;
use warnings;

use Moo::Role;
use DDG::GoodieRole::WhatIs::Matcher;

# Custom matcher with no presets.
sub wi {
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

    my $matcher = wi(
        groups  => ['conversion'],
        options => {
            to => 'Goatee',
        },
    );

Retrieving values:

    my $match = $matcher->full_match("What is hello in Goatee?");
    my $value  = $match->{primary};
    print $value;
    # 'hello'

=head1 DESCRIPTION

L<DDG::GoodieRole::WhatIs> aims to make writing new Goodies,
as well as ensuring they are accessible, as easy as possible!
It does this by reducing the need for complex regular expressions,
instead allowing you to specify certain L</Groups> and L</Options>
which represent properties of your Goodie, and then provides a simple
interface through which matches can be performed.

=head2 Matchers

Matchers are the main way of interacting with B<WhatIs>.
After defining a matcher (see L</Creating Matchers>) it may be
used to smartly match various queries and retrieve parts of the
match (see L</Results>).

=head3 Creating Matchers

To create a matcher, you use the C<wi> routine provided by B<WhatIs>.

    my $matcher = wi(
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
not set (see S<L</Specifying Modifier Options>>) the package will die
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

Form: B<"How to VERB PRIMARY in TO?">

Required Groups: C<translation>, C<verb>.

Options:

=over

=item C<verb> (I<Required>)

Matches B<VERB>.

=item C<to> (I<Required>)

See S<L</Standard Options>>.

=item C<primary> (I<Optional>)

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

Form: B<"Convert PRIMARY to TO">

Required Groups: C<conversion>.

Options:

=over

=item C<to>

Enables matching of forms such as:

B<"What is PRIMARY in TO?">

B<"PRIMARY to TO">

=item C<from>

Enables matching of forms such as:

B<"PRIMARY from FROM">

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

=head2 Options

While modifiers dictate the overall forms which are matched, options
allow the fine-tuning of these forms - to make them more suited to
individual needs.

=head3 Specifying Modifier Options

Options may be specified through the C<options> hash when defining a
matcher.

    my $matcher = wi(
        groups => [...],
        options => {
            option1 => value1,
            option2 => value2,
            ...
        },
    );

Most options take the form of either a regular expression or string,
which matches directly on the query, or a hash containing option
modifiers (see L</Option Modifiers>).

Matches from specified options are usually accessible through the
results hash under the same name; either as a hash or string
depending on whether or not any option modifiers were specified.

=head3 Standard Options

Many of the available options have a common meaning across Modifiers,
these options are considered I<Standard> and are described in detail
below:

=over

=item C<from>

The starting 'language' of a 'translation'.

=item C<primary>

Generally the main information (or target) of a match. For example,
the item being converted in a conversion, the text being translated
in a translation, and the target to which a property applies.

=item C<to>

The target 'language' of a 'translation'.

=back

=head3 Option Modifiers

Option Modifiers allow I<even more> fine-grained control of how
forms are matched. Typically option modifiers are used to create a
richer result with more information about a particular part of the
match.

The following lists the available option modifiers:

=over

=item C<match>

C<match> defines 'regular' matching an option performs.

Result is the matched text.

    # Without option modifiers
    my $matcher = wi(
        groups => ['conversion'],
        options => {
            primary => qr/foo/,
            to      => qr/bar/,
        },
    );
    my $match = $matcher->full_match('What is foo in bar');
    print $match->{primary};
    # 'foo'

    # With option modifiers
    my $matcher = wi(
        groups => ['conversion'],
        options => {
            # We specify a hash instead
            primary => {
                match => qr/foo/,
            },
            to      => qr/bar/,
        },
    );
    my $match = $matcher->full_match('What is foo in bar');
    print (ref $match->{primary});
    # 'HASH'
    print $match->{primary}{match};
    # 'foo'
    print $match->{primary}{full_match};
    # 'foo'

=item C<numeric>

Takes a boolean value which, when true, will match a number and
yield it in the result.

=item C<unit>

Takes either a single regex or a hash reference containing C<symbol>
and/or C<word> attributes.

C<word> is treated as a representation of the unit which I<requires>
there to be a separation between it and the preceding phrase.
C<symbol> does not require any separation, but allows it.

If a regex is specified then it will act in the same way as C<symbol>.

The matched unit is provided in the result.

=back

=head2 Results

Upon a successful match, a matcher will return a hash reference
with values accessible through the attributes specified in
L</Modifiers>.

In any of the forms specified in L</Modifiers>, words shown in
S<B<BOLD CAPITALS>> are always accessible through the same
(lowercase) name in the results hash.

When additional option modifiers are specified
(see L</Option Modifiers>) the result for that particular match will
be a reference to a hash with C<full_match> containing the full match
for the option; C<match> containing the standard match; and other
attributes determined by which modifiers were specified.

For example, the C<conversion> modifier (with the C<to> option), can
match the form B<"Convert PRIMARY to TO">. In this case, both
C<primary> and C<to> could be accessed through the options
hash to retrieve the match at those positions.

    my $matcher = wi(
        groups => ['conversion'],
        options => {
            primary => {
                unit => 'ounces',
            },
            to      => qr/kilograms/,
        },
    );

    my $match = $matcher->full_match("Convert 5 ounces to kilograms");
    print $match->{primary}{full_match}
    # '5 ounces'
    print $match->{primary}{match}
    # '5'
    print $match->{primary}{unit}
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

You specify groups through the C<groups> option in a
L<matcher|/Matchers>.

  ...
  my $matcher = wi(
      groups => ['group1', 'group2', ...]
  ...

The supported groups are covered in L</Modifiers>.

=head1 EXAMPLES

This is an example of a Goodie that takes English and translates
it to a made-up language called 'Goatee'.

The aim is for queries such as "How do I write X in Goatee?",
"What is X in Goatee?", and so forth to be matched.

    use DDG::Goodie;
    # To be able to use 'WhatIs' we need import it!
    with 'DDG::GoodieRole::WhatIs';

    # We don't know *exactly* where 'goatee' will turn up in our
    # query, so we use the 'any' trigger.
    triggers any => 'goatee';

    zci is_cached   => 1;
    zci answer_type => 'goatee';

    sub english_to_goatee {
        # Hello -> baah baah baah baah baah
        return $_[0] =~ s/\w/baah /gr;
    }

    # To be able to match queries such as "How do I say..." and
    # "How do I write...", we need to use the 'verb translation'
    # modifier with the 'verb' option set to something that can match
    # both 'say' and 'write'.
    #
    # To be able to match queries of the form "What is X in Y?",
    # we need to use the 'conversion' modifier and set 'to'
    # appropriately.

    my $matcher = wi(
        groups  => ['translation', 'verb', 'conversion'],
        options => {
            # In both cases we don't care about casing.
            to   => qr/goatee/i,
            # This will match both 'say' and 'write', as required.
            verb => qr/(say|write)/i,
        },
    );

    # We use the 'query' handle so that we have a normalized query
    # with the trigger intact.
    handle query => sub {
        # First we retrieve the query for matching.
        my $query = $_;

        # We use the 'full_match' method to ensure the whole of the
        # query is matched - we exit early if the query is invalid.
        #
        # $match will be a reference to a hash if the query matches.
        my $match = $matcher->full_match($query) or return;

        # 'primary' is the main result from the match, this is what
        # we'll want to translate.
        my $to_translate = $match->{primary};

        # Now we can do with our result what we please.
        my $result = english_to_goatee $to_translate;

        return $result,
            structured_answer => {
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
