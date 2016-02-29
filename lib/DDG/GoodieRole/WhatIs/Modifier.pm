package DDG::GoodieRole::WhatIs::Modifier;
# ABSTRACT: Changes the way in which a query is matched.

use strict;
use warnings;

use Moo;

use Scalar::Util qw(looks_like_number);

sub is_array  { die "$_[0] is not an ARRAY reference" unless ref $_[0] eq 'ARRAY' }
has '_options' => (
    is      => 'ro',
    isa     => sub { die "$_[0] is not a HASH reference" unless ref $_[0] eq 'HASH' },
    default => sub { {} },
);

has 'action' => (
    is  => 'ro',
    isa => sub { die "$_[0] is not a CODE reference" unless ref $_[0] eq 'CODE' },
    required => 1,
);

has 'required_groups' => (
    is => 'ro',
    isa => sub { die "$_[0] is not a CODE reference" unless ref $_[0] eq 'CODE' },
    required => 1,
);

has 'option_format' => (
    is       => 'ro',
    isa      => \&is_array,
    required => 0,
    default  => sub { [] },
);

has 'name' => (
    is       => 'ro',
    required => 1,
);

# Higher priority means it will be checked earlier when attempting
# to find a match.
#
# In general, priority should be specified for any modifiers that
# could have clashes when matching.
has 'priority' => (
    is => 'ro',
    isa => sub { die "$_[0] is not a number!" unless looks_like_number($_[0]) },
    required => 0,
    default => 10,
);

sub parse_options {
    my ($self, %options) = @_;
    foreach my $option_spec (@{$self->option_format}) {
        my %opt_res = $option_spec->(%{$self->_options}, %options);
        die "Modifier '@{[$self->name]}' @{[$opt_res{fail_msg}]}" unless defined $opt_res{value};
        $self->_set_option($opt_res{option_name}, $opt_res{value});
    };
}

sub _set_option {
    my ($self, $option, $value) = @_;
    $self->{_options}->{$option} = $value;
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

1;
