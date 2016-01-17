package DDG::GoodieRole::WhatIs::Modifier;
# ABSTRACT: Changes the way in which a query is matched.

use Moose;

has '_options' => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub { {} },
);

has 'action' => (
    is  => 'ro',
    isa => 'CodeRef',
    required => 1,
);

has 'required_groups' => (
    is => 'ro',
    isa => 'ArrayRef[ArrayRef[Str]]',
    required => 1,
);

has 'required_options' => (
    is => 'ro',
    isa => 'ArrayRef',
    default => sub { [] },
);

has 'optional_options' => (
    is => 'ro',
    isa => 'HashRef',
    default => sub { {} },
);

has 'name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

sub parse_options {
    my ($self, $options) = @_;
    foreach my $required (@{$self->required_options}) {
        if (ref $required eq 'ARRAY') {
            my $option_key;
            my $prefer = $required->[0];
            foreach my $potential (@{$required}) {
                if (defined $options->{$potential}) {
                    $option_key = $potential;
                    $self->_set_option($prefer, $options->{$option_key});
                    last;
                } elsif (defined $self->_fetch_option($potential)) {
                    $option_key = $potential;
                    $self->_set_option($prefer, $self->_fetch_option($option_key));
                    last;
                };
            };
            unless (defined $option_key) {
                die "Modifier '@{[$self->name]}' requires at least on of the @{[join ' or ', map { '\'' . $_ . '\'' } @{$required}]} options to be set, but none were.\n";
            };
        } else {
            unless (defined $options->{$required}) {
                die "Modifier '@{[$self->name]}' requires the '$required' option to be set - but it wasn't!\n";
            };
            $self->_set_option($required, $options->{$required});
        };
    };
    while (my ($option, $default) = each %{$self->optional_options}) {
        my $value = defined($options->{$option}) ? $options->{$option} : $default;
        $self->_set_option($option, $value);
    };
}

sub _set_option {
    my ($self, $option, $value) = @_;
    $self->{_options}->{$option} = $value;
}

sub _fetch_option {
    my ($self, $option) = @_;
    return $self->{_options}->{$option};
}

sub run_action {
    my ($self, $matcher) = @_;
    return $self->action->($self->_options, $matcher);
}


__PACKAGE__->meta->make_immutable();

1;
