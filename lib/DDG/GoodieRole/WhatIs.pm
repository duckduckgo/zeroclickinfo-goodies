package DDG::GoodieRole::WhatIs;
# ABSTRACT: Role for query matching.

use strict;
use warnings;

use Moo::Role;
use DDG::GoodieRole::WhatIsBase;

# Use for translations between systems where it makes sense to say
# 'What is X in Y?'.
sub wi_translation {
    my $got_options = shift;
    my $groups = ['translation'];
    push $groups, @{$got_options->{groups}} if defined $got_options->{groups};
    my $presets = {
        groups => $groups,
    };
    my %options = (%$got_options, %$presets);
    return DDG::GoodieRole::WhatIsBase->new(\%options);
}

1;

__END__

=head1 NAME

DDG::GoodieRole::WhatIs - Abstracts query matching.

=head1 SYNOPSIS

Including it in your Goodie:

    use DDG::Goodie;
    with 'DDG::GoodieRole::WhatIs';

Creating matchers:

    my $matcher = wi_translation({
        to     => 'Goatee',
        groups => ['spoken', 'written'],
    });

Retrieving values:

    my $result = $matcher->match("What is hello in Goatee?");
    my $value = $result->{value};
    print $value;
    # 'hello'

=head1 DESCRIPTION

L<DDG::GoodieRole::WhatIs> aims to make writing new Goodies,
as well as ensuring they are accessible, as easy as possible!
It does this by reducing the need for complex regular expressions,
instead allowing you to specify certain properties of your Goodie
(it is a C<'translation'>, makes sense to be called C<'written'>)
and have the Role do the hard work.

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
        groups => ['spoken', 'written'],
        to     => 'Goatee',
    });

    handle query_raw => sub {
        my $query = $_;
        my $match_result = $matcher->match($query) or return;
        my $to_translate = $match_result->{value} or return;
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

Ben Moon aka GuiltyDolphin E<lt>guiltydolphin@gmail.comE<gt> or
E<64>GuiltyDolphin on GitHub and others.

=cut
