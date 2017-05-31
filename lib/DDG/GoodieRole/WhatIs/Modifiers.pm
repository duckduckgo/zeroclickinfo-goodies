package DDG::GoodieRole::WhatIs::Modifiers;
# ABSTRACT: Defines the possible modifiers that can be used
# with the 'WhatIs' GoodieRole.

use strict;
use warnings;

use Moo;

use List::MoreUtils qw(all);
use List::Util qw(first);

use DDG::GoodieRole::WhatIs::Expression qw(:EXPR);
use DDG::GoodieRole::WhatIs::Modifier;

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

#######################################################################
#                              Modifiers                              #
#######################################################################

new_modifier_spec 'verb translation' => {
    required_groups  => ['translation', 'verb'],
    option_defaults => {
        primary => qr/.+/,
    },
    regex_sub => \&translation_generic,
};
new_modifier_spec 'conversion' => {
    required_groups => ['conversion'],
    option_defaults => {
        primary => qr/.+/,
    },
    priority => 3,
    regex_sub => \&conversion_generic,
};
new_modifier_spec 'command' => {
    required_groups  => ['command'],
    option_defaults => {
        primary => qr/.+/,
    },
    regex_sub => \&command_generic,
};
new_modifier_spec 'property' => {
    required_groups  => ['property'],
    option_defaults => {
        primary => qr/.+/,
    },
    regex_sub => \&property,
};
new_modifier_spec 'language translation' => {
    required_groups  => ['translation', 'language'],
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
    expr($options)
        ->how_to->opt('verb')->opt('primary')->in->opt('to')
        ->question
    ->regex;
}

sub conversion_generic {
    my $options = shift;
    expr($options)->or(
        expr($options)->or(
            expr($options)
                ->optional(qr/convert/i)
                ->opt('primary')
                ->to->opt('to'),
            expr($options)->or(
                expr($options)
                    ->words(qr/what is/i)
                    ->opt('primary')
                    ->in->opt('to')->question,
                expr($options)
                    ->opt('primary')
                    ->in->opt('to'),
            ),
        ),
        expr($options)
            ->opt('primary')->from->opt('from')
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
            expr($options)->to->opt('to'),
            expr($options)->from->opt('from'),
        )->regex;
}

sub pluralize {
    my %v = %{$_[0]};
    $v{match} .= 's';
    return \%v;
}

sub property {
    my $options = shift;
    expr($options)->or(
        named('_singular', $options)
            ->optional_when_before(qr/what is/i, qr/the/i)
            ->prefer_opt('singular_property', 'property'),
        named('_plural', $options)
            ->optional_when_before(qr/what are/i, qr/the/i)
            ->prefer_opt('plural_property', ['property', \&pluralize])
    )->words(qr/(of|for)/i)->opt('primary')->question
    ->regex;
}

#######################################################################
#                         External Interface                          #
#######################################################################

sub sublist {
    my ($small, $parent) = @_;
    my @small  = @{$small};
    my @parent = @{$parent};
    return all { my $x = $_; first { $x eq $_ } @parent } @small;
}

sub get_modifiers {
    my $groups = shift;
    die "No groups specified" unless @$groups;
    my @applicable_modifiers = ();
    my %used_groups = map { $_ => 0 } @$groups;
    foreach my $modifier (@modifier_specs) {
        my $required_groups = $modifier->{required_groups};
        if (sublist($required_groups, $groups)) {
            push @applicable_modifiers, new_modifier($modifier);
            map { $used_groups{$_} = 1 } @$required_groups;
        }
    };
    my @unused = sort grep { $used_groups{$_} eq 0 } (keys %used_groups);
    die "Unused groups " . join(' and ', map { "'$_'" } @unused)
        if @unused;
    return @applicable_modifiers;
}

1;
