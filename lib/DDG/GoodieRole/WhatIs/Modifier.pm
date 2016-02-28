package DDG::GoodieRole::WhatIs::Modifier;
# ABSTRACT: Changes the way in which a query is matched.

use strict;
use warnings;

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
    isa => 'CodeRef',
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

# Higher priority means it will be checked earlier when attempting
# to find a match.
#
# In general, priority should be specified for any modifiers that
# could have clashes when matching.
has 'priority' => (
    is => 'ro',
    isa => 'Int',
    required => 0,
    default => 10,
);

sub parse_options {
    my ($self, %options) = @_;
    foreach my $required (@{$self->required_options}) {
        my $opt_key = $required;
        my $opt_val;
        my $fail_msg = "requires the '$opt_key' option to be set - but it wasn't";
        if (ref $required eq 'CODE') {
            ($opt_key, $opt_val) = $required->(%{$self->_options}, %options);
            $fail_msg = $opt_key unless defined $opt_val;
        } else {
            $opt_val = $options{$opt_key} // $self->_fetch_option($opt_key);
        }
        die "Modifier '@{[$self->name]}' @{[$fail_msg]}" unless defined $opt_val;
        $self->_set_option($opt_key, $opt_val);
    };
    while (my ($option, $default) = each %{$self->optional_options}) {
        my $value = $options{$option} // $default;
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

sub generate_regex {
    my $self = shift;
    return $self->action->($self->_options);
}

sub build_result {
    my ($self, %init_res) = @_;
    my %res;
    if (my $dir = $init_res{direction}) {
        $res{direction} = $dir eq 'in' ? 'to' : $dir;
    }
    if (defined $init_res{_singular} || defined $init_res{_plural}) {
        $res{is_plural} = defined $init_res{_plural} ? 1 : 0;
    }
    return (%init_res, %res);
}


__PACKAGE__->meta->make_immutable();

1;
