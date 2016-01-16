package DDG::GoodieRole::WhatIs::Modifiers;
# ABSTRACT: Defines the possible modifiers that can be used
# with the 'WhatIs' GoodieRole.

use Moo;
use DDG::GoodieRole::WhatIs::Modifier;

BEGIN {
    require Exporter;

    our @ISA = qw(Exporter);
    our @EXPORT_OK = qw(get_modifiers);
}

my @modifiers;

sub new_modifier {
    my ($name, $options) = @_;
    my %opts = (name => $name);
    %opts = (%opts, %$options);
    my $modifier = DDG::GoodieRole::WhatIs::Modifier->new(\%opts);
    push @modifiers, $modifier;
}

new_modifier 'written translation' => {
    required_groups => [['translation', 'written']],
    required_options => ['to'],
    optional_options => { primary => qr/.+/ },
    action => \&written_translation,
};
new_modifier 'spoken translation' => {
    required_groups => [['translation', 'spoken']],
    required_options => ['to'],
    optional_options => { primary => qr/.+/ },
    action => \&spoken_translation,
};
new_modifier 'what is conversion' => {
    required_groups => [['translation']],
    required_options => ['to'],
    optional_options => { primary => qr/.+/ },
    action => \&whatis_translation,
};
new_modifier 'meaning' => {
    required_groups => [['meaning']],
    optional_options => { primary => qr/.+/ },
    action => \&meaning,
};
new_modifier 'base conversion' => {
    required_groups => [['conversion']],
    optional_options => { primary => qr/.+/ },
    required_options => ['to'],
    action => \&base_conversion,
};
new_modifier 'prefix imperative' => {
    required_groups => [['imperative']],
    optional_options => { primary => qr/.+/ },
    required_options => ['command'],
    action => \&prefix_imperative,
};

# Various ways of saying "How would I say";
my $how_forms = qr/(?:how (?:(?:do|would) (?:you|I))|to)/i;
my $spoken_forms = qr/(?:$how_forms say) /i;
my $written_forms = qr/(?:$how_forms write) /i;

sub _in_re {
    my ($options, $re) = @_;
    my $to = $options->{to};
    my $constraint = $options->{primary} // qr/.+/;
    return qr/$re(?<primary>$constraint) in $to/i;
}

sub _to_re {
    my ($options, $re) = @_;
    my $to = $options->{to};
    my $constraint = $options->{primary} // qr/.+/;
    return qr/$re(?<primary>$constraint) to $to/i;
}

sub written_translation {
    my ($options, $matcher) = @_;
    $matcher->_add_re(_in_re($options, $written_forms));
}
sub spoken_translation {
    my ($options, $matcher) = @_;
    $matcher->_add_re(_in_re($options, $spoken_forms));
}
sub whatis_translation {
    my ($options, $matcher) = @_;
    $matcher->_add_re(_in_re($options, qr/what is /i));
}
sub meaning {
    my ($options, $matcher) = @_;
    my $primary = qr/(?<primary>@{[$options->{primary}]})/;
    my $re = qr/what (?:is the meaning of $primary|does $primary mean)/i;
    $matcher->_add_re($re);
}
sub base_conversion {
    my ($options, $matcher) = @_;
    $matcher->_add_re(_to_re($options, qr//));
    $matcher->_add_re(_in_re($options, qr//));
}
sub prefix_imperative {
    my ($options, $matcher) = @_;
    my $command = $options->{command};
    my $primary = $options->{primary};
    $matcher->_add_re(qr/$command (?<primary>$primary)/);
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
    foreach my $modifier (@modifiers) {
        my $required_groups = $modifier->required_groups;
        foreach my $req_group (@$required_groups) {
            if (sublist_uniques($req_group, $groups)) {
                push @applicable_modifiers, $modifier;
                last;
            };
        };
        push @applicable_modifiers, $modifier unless @$required_groups;
    };
    return @applicable_modifiers;
}

1;
