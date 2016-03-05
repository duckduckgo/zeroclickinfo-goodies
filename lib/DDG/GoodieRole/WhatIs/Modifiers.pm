package DDG::GoodieRole::WhatIs::Modifiers;
# ABSTRACT: Defines the possible modifiers that can be used
# with the 'WhatIs' GoodieRole.

use strict;
use warnings;

use Moo;
use DDG::GoodieRole::WhatIs::Modifier;
use List::MoreUtils qw(any);
use DDG::GoodieRole::WhatIs::Expression qw(expr named when_opt);

BEGIN {
    require Exporter;

    our @ISA = qw(Exporter);
    our @EXPORT_OK = qw(get_modifiers);
}

my @modifier_specs;

#######################################################################
#                          Modifier Helpers                           #
#######################################################################

sub new_modifier_spec {
    my ($name, $options) = @_;
    my %opts = (name => $name, _regex_generator => $options->{regex_sub});
    %opts = (%opts, %$options);
    my $modifier_spec = \%opts;
    push @modifier_specs, $modifier_spec;
}

sub new_modifier {
    my $modifier_spec = shift;
    return DDG::GoodieRole::WhatIs::Modifier->new(%$modifier_spec);
}

# Create a helper for matching against modifier group
# specifications.
#
# $should_return should indicate whether the inverse of $default
# should be returned if the current specifier matches.
#
# $default is returned if $should_return is never true.
sub gspec_helper {
    my ($default, $should_return) = @_;
    return sub {
        my @group_specs = @_;
        return sub {
            my @groups = @_;
            foreach my $gspec (@group_specs) {
                if (ref $gspec eq 'CODE') {
                    return (not $default) if
                        $should_return->($gspec->(@groups));
                } else {
                    return (not $default) if
                        $should_return->(
                            any { $_ eq $gspec} @groups);
                }
            }
            return $default;
        }
    }
}

# True if any of the group specifiers match.
sub any_of { gspec_helper(0, sub {     $_[0] })->(@_) }

# True if all of the group specifiers match.
sub all_of { gspec_helper(1, sub { not $_[0] })->(@_) }

# True if none of the group specifiers match.
sub none_of { gspec_helper(1, sub {     $_[0] })->(@_) }

#######################################################################
#                              Modifiers                              #
#######################################################################

new_modifier_spec 'verb translation' => {
    required_groups  => all_of('translation', 'verb'),
    option_defaults => {
        primary => qr/.+/,
    },
    regex_sub => \&translation_generic,
};
new_modifier_spec 'conversion' => {
    required_groups => all_of('conversion'),
    option_defaults => {
        primary => qr/.+/,
    },
    priority => 3,
    regex_sub => \&conversion_generic,
};
new_modifier_spec 'command' => {
    required_groups  => all_of('command'),
    option_defaults => {
        primary => qr/.+/,
    },
    regex_sub => \&command_generic,
};
new_modifier_spec 'targeted property' => {
    required_groups  => all_of('property'),
    option_defaults => {
        primary => qr/.+/,
    },
    regex_sub => \&targeted_property,
};
new_modifier_spec 'language translation' => {
    required_groups  => all_of('translation', 'language'),
    option_defaults => {
        primary => qr/.+/,
    },
    regex_sub => \&language_translation,
};

#######################################################################
#        Regular Expressions and Regular Expression Generators        #
#######################################################################

sub translation_generic {
    my $options = shift;
    expr($options)->or(
        when_opt('written', $options)->how_to(qr/write/i),
        when_opt('spoken', $options)->how_to(qr/say/i),
    )->opt('primary')->in->opt('to')->question
        ->regex;
}

sub conversion_generic {
    my $options = shift;
    expr($options)->or(
        when_opt('to', $options)
            ->or(
                when_opt('to', $options)
                    ->optional(qr/convert/i)
                    ->opt('primary')
                    ->unit->to->opt('to'),
                when_opt('to', $options)
                    ->or(
                        expr($options)
                            ->words(qr/what is/i)
                            ->opt('primary')
                            ->unit->in->opt('to')->question,
                        expr($options)
                            ->opt('primary')
                            ->unit->in->opt('to'),
                    )
            ),
        when_opt('from', $options)
            ->opt('primary')->unit->from->opt('from')
    )->regex;
}

sub command_generic {
    my $options = shift;
    expr($options)->or(
            expr($options)
                ->prefer_opt('prefix_command', 'command')
                ->opt('primary'),
            expr($options)
                ->opt('primary')
                ->prefer_opt('postfix_command', 'command'),
        )->regex;
}

sub language_translation {
    my $options = shift;
    expr($options)
        ->words(qr/translate/i)->opt('primary')->spaced->or(
            when_opt('to', $options)->to->opt('to'),
            when_opt('from', $options)->from->opt('from'),
        )->regex;
}

sub pluralize {
    my %options = @_;
    return $options{singular_property} . 's'
        if defined $options{singular_property};
    return $options{property} . 's'
        if defined $options{property};
    return;
}

sub targeted_property {
    my $options = shift;
    expr($options)->or(
        named('_singular', $options)
            ->optional(qr/what is/i)
            ->optional(qr/the/i)
            ->prefer_opt('singular_property', 'property'),
        named('_plural', $options)
            ->optional(qr/what are/i)
            ->optional(qr/the/i)
            ->prefer_opt('plural_property', \&pluralize)
        )->words(qr/(of|for)/i)->opt('primary')->question
        ->regex;
}

#######################################################################
#                         External Interface                          #
#######################################################################

sub get_modifiers {
    my $groups = shift;
    my @applicable_modifiers = ();
    return unless @$groups;
    foreach my $modifier (@modifier_specs) {
        my $required_groups = $modifier->{required_groups};
        if ($required_groups->(@{$groups})) {
            push @applicable_modifiers, new_modifier($modifier);
        }
    };
    return @applicable_modifiers;
}

1;
