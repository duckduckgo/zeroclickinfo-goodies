package DDG::GoodieRole::WhatIs::Modifiers;
# ABSTRACT: Defines the possible modifiers that can be used
# with the 'WhatIs' GoodieRole.

use strict;
use warnings;

use Moo;
use DDG::GoodieRole::WhatIs::Modifier;

BEGIN {
    require Exporter;

    our @ISA = qw(Exporter);
    our @EXPORT_OK = qw(get_modifiers);
}

my @modifier_specs;

sub new_modifier_spec {
    my ($name, $options) = @_;
    my %opts = (name => $name);
    %opts = (%opts, %$options);
    my $modifier_spec = \%opts;
    push @modifier_specs, $modifier_spec;
}

sub new_modifier {
    my $modifier_spec = shift;
    return DDG::GoodieRole::WhatIs::Modifier->new(%$modifier_spec);
}

new_modifier_spec 'written translation' => {
    required_groups => [['translation', 'written']],
    required_options => ['to'],
    optional_options => { primary => qr/.+/ },
    action => \&written_translation,
};
new_modifier_spec 'spoken translation' => {
    required_groups => [['translation', 'spoken']],
    required_options => ['to'],
    optional_options => { primary => qr/.+/ },
    action => \&spoken_translation,
};
new_modifier_spec 'what is conversion' => {
    required_groups => [['translation']],
    required_options => ['to'],
    optional_options => { primary => qr/.+/ },
    action => \&whatis_translation,
};
new_modifier_spec 'meaning' => {
    required_groups => [['meaning']],
    optional_options => { primary => qr/.+/ },
    action => \&meaning,
};
new_modifier_spec 'conversion to' => {
    required_groups  => [['conversion', 'bidirectional'],
                         ['conversion', 'to']],
    required_options => ['to'],
    optional_options => {
        primary => qr/.+/,
        unit    => qr//,
    },
    priority         => 3,
    action => \&conversion_to,
};
new_modifier_spec 'conversion from' => {
    required_groups  => [['conversion', 'bidirectional'],
                         ['conversion', 'from']],
    required_options => ['from'],
    optional_options => { primary => qr/.+/ },
    priority         => 3,
    action => \&conversion_from,
};
new_modifier_spec 'conversion in' => {
    required_groups  => [['conversion']],
    required_options => [['to', 'from']],
    optional_options => { primary => qr/.+/ },
    priority         => 3,
    action => \&conversion_in,
};
new_modifier_spec 'prefix imperative' => {
    required_groups => [['prefix', 'imperative']],
    optional_options => { primary => qr/.+/ },
    required_options => [['prefix_command', 'command']],
    action => \&prefix_imperative,
};
new_modifier_spec 'postfix imperative' => {
    required_groups => [['postfix', 'imperative']],
    optional_options => { primary => qr/.+/ },
    required_options => [['postfix_command', 'command']],
    action => \&postfix_imperative,
};
new_modifier_spec 'targeted property' => {
    required_groups  => [['property']],
    required_options => [['singular_property', 'property'],
                         ['plural_property', 'singular_property']],
    optional_options => { 'primary' => qr/.+/ },
    action => \&targeted_property,
};
new_modifier_spec 'language translation' => {
    required_groups  => [['translation', 'language']],
    required_options => ['to'],
    optional_options => { 'primary' => qr/.+/ },
    action => \&language_translation,
};
new_modifier_spec 'language translation from' => {
    required_groups  => [['translation', 'language', 'from'],
                         ['translation', 'language', 'bidirectional']],
    required_options => ['from'],
    optional_options => { primary => qr/.+/ },
    action => \&language_translation_from,
};

# Various ways of saying "How would I say";
my $how_forms = qr/(?:how (?:(?:(?:do|would) (?:you|I))|to))/i;
my $spoken_forms = qr/(?:$how_forms say) /i;
my $written_forms = qr/(?:$how_forms write) /i;

my $question_end = qr/[?]/;

sub re_gen {
    my $sub = shift;
    return sub {
        my ($options, $start_re, $end_re) = @_;
        $start_re //= qr//;
        $end_re //= qr//;
        my $re = $sub->($options);
        return qr/${start_re}${re}${end_re}/i;
    };
}

sub _in_re {
    return re_gen(sub {
        my $options = shift;
        my $to = $options->{to};
        my $constraint = $options->{primary} // qr/.+/;
        return qr/(?<primary>$constraint) (?<direction>in) $to/i;
    })->(@_);
}

sub _to_re {
    return re_gen(sub {
        my $options = shift;
        my $to = $options->{to};
        my $constraint = $options->{primary} // qr/.+/;
        return qr/(?<primary>$constraint) (?<direction>to) $to/i;
    })->(@_);
}

sub _from_re {
    re_gen(sub {
        my $options = shift;
        my $from = $options->{from};
        my $constraint = $options->{primary};
        return qr/(?<primary>$constraint) (?<direction>from) $from/i;
    })->(@_);
}

sub written_translation {
    _in_re($_[0], $written_forms, qr/$question_end?/)
}
sub spoken_translation {
    _in_re($_[0], $spoken_forms, qr/$question_end?/)
}
sub whatis_translation {
    _in_re($_[0], qr/what is /i, qr/$question_end?/)
}
sub meaning {
    my $options = shift;
    my $primary = qr/(?<primary>@{[$options->{primary}]})/;
    return qr/what (?:is the meaning of $primary|does $primary mean)$question_end?/i;
}
sub primary_prefer_alts {
    my ($primary, @alts) = @_;
    return qr/@{[join '|', map { "(?<primary>$primary)(?=$_)$_" } @alts]}/;
}
sub conversion_to {
    my $options = shift;
    my $to = $options->{to};
    my $primary = $options->{primary};
    my $unit = $options->{unit};
    my @unit_alternatives;
    if (ref $unit eq 'HASH') {
        my $symbol = $unit->{symbol};
        my $word = $unit->{word};
        die "unit specified, but neither 'symbol' nor 'word' were specified." unless defined ($symbol // $word);
        $word //= $symbol;
        @unit_alternatives = (qr/ $symbol/, qr/ $word/, qr/$symbol/);
    } else {
        @unit_alternatives = ($unit);
    };
    my $prim = primary_prefer_alts $primary, @unit_alternatives;
    return qr/(convert )?$prim (?<direction>to) $to/i;
}
sub conversion_from { _from_re(@_) }
sub conversion_in { _in_re(@_) }

sub prefix_imperative {
    my $options = shift;
    my $command = $options->{prefix_command};
    my $primary = $options->{primary};
    return qr/$command (?<primary>$primary)/;
}
sub postfix_imperative {
    my $options = shift;
    my $command = $options->{postfix_command};
    my $primary = $options->{primary};
    return qr/(?<primary>$primary) $command/;
}
sub language_translation { _to_re($_[0], qr/translate /i) }
sub language_translation_from { _from_re($_[0], qr/translate /i) }

sub primary_end_with {
    my ($before, $check, $primary, $end) = @_;
    return qr/$before(?(<$check>)((?<primary>$primary)(?=$end)$end|(?<primary>$primary))|(?<primary>$primary))/;
}

sub targeted_property {
    my $options = shift;
    my $singular = qr/(?<_singular>$options->{singular_property})/;
    my $plural = qr/(?<_plural>$options->{plural_property})/;
    $plural = qr/(?<_plural>${singular}s)/i
        if $options->{singular_property} eq $options->{plural_property};
    my $primary = $options->{primary};
    my $what = qr/(?<_what>what ((?<_is>is)|(?<_are>are)) )/i;
    my $what_re = qr/$what?(the )?(?(<_is>)$singular|(?(<_are>)$plural|($singular|$plural))) (of|for) /i;
    return primary_end_with $what_re, '_what', $primary, $question_end;
}

use List::MoreUtils qw(all any uniq);

# The unique elements of $child is a sublist of the unique elements of
# $container?
sub sublist_uniques {
    my ($child, $container) = @_;
    my @uniques = uniq @$container;
    return all { my $c = $_; any { $_ eq $c } @uniques } (uniq @$child);
}

sub get_modifiers {
    my $groups = shift;
    my @applicable_modifiers = ();
    return unless @$groups;
    foreach my $modifier (@modifier_specs) {
        my $required_groups = $modifier->{required_groups};
        foreach my $req_group (@$required_groups) {
            if (sublist_uniques($req_group, $groups)) {
                push @applicable_modifiers, new_modifier($modifier);
                last;
            };
        };
        push @applicable_modifiers, $modifier unless @$required_groups;
    };
    return @applicable_modifiers;
}

1;
