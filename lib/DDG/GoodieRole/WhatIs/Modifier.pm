package DDG::GoodieRole::WhatIs::Modifier;
# ABSTRACT: Changes the way in which a query is matched.

use strict;
use warnings;

use Moo;

use Scalar::Util qw(looks_like_number);

sub is_array  { die "$_[0] is not an ARRAY reference" unless ref $_[0] eq 'ARRAY' }
sub is_hash   { die "$_[0] is not a HASH reference"   unless ref $_[0] eq 'HASH' }
sub is_code   { die "$_[0] is not a CODE reference"   unless ref $_[0] eq 'CODE' }
sub is_number { die "$_[0] is not a number!" unless looks_like_number($_[0]) }

has '_options' => (
    is      => 'ro',
    isa     => \&is_hash,
    default => sub { {} },
);

has '_regex_generator' => (
    is       => 'ro',
    isa      => \&is_code,
    required => 1,
);

has 'required_groups' => (
    is       => 'ro',
    isa      => \&is_code,
    required => 1,
);

has 'option_defaults' => (
    is       => 'ro',
    isa      => \&is_hash,
    required => 0,
    default  => sub { {} },
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
    is       => 'ro',
    isa      => \&is_number,
    required => 0,
    default  => 10,
);

sub parse_options {
    my ($self, %options) = @_;
    my %opts = (%{$self->option_defaults}, %options);
    $self->{_options} = \%opts;
}

sub _set_option {
    my ($self, $option, $value) = @_;
    $self->{_options}->{$option} = $value;
}

sub generate_regex {
    my $self = shift;
    my %options = (%{$self->_options}, _modifier_name => $self->name);
    return $self->_regex_generator->(\%options);
}

sub build_result {
    my ($self, %match_result) = @_;
    my %result;
    if (my $dir = $match_result{direction}) {
        $result{direction} = $dir eq 'in' ? 'to' : $dir;
    }
    if (defined $match_result{_singular} || defined $match_result{_plural}) {
        $result{is_plural} = defined $match_result{_plural} ? 1 : 0;
    }
    if (my $command = $match_result{command}
                   // $match_result{prefix_command}
                   // $match_result{postfix_command}) {
        $result{command} = $command
    }
    return (%match_result, %result);
}

1;
