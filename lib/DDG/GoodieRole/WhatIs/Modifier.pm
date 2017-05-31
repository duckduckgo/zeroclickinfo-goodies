package DDG::GoodieRole::WhatIs::Modifier;
# ABSTRACT: Changes the way in which a query is matched.

use strict;
use warnings;

use Moo;

use Scalar::Util qw(looks_like_number);

has '_options' => (
    is      => 'ro',
    isa     => sub { die "$_[0] is not a HASH reference"   unless ref $_[0] eq 'HASH' },
    default => sub { {} },
);

has '_regex_generator' => (
    is       => 'ro',
    isa      => sub { die "$_[0] is not a CODE reference"   unless ref $_[0] eq 'CODE' },
    required => 1,
);

has 'required_groups' => (
    is       => 'ro',
    isa      => sub { die "$_[0] is not an ARRAY reference" unless ref $_[0] eq 'ARRAY' },
    required => 1,
);

has 'option_defaults' => (
    is       => 'ro',
    isa      => sub { die "$_[0] is not a HASH reference"   unless ref $_[0] eq 'HASH' },
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
    isa      => sub { die "$_[0] is not a number!" unless looks_like_number($_[0]) },
    required => 0,
    default  => 10,
);

sub parse_options {
    my ($self, %options) = @_;
    my %defaults = %{$self->option_defaults};
    my %full = (%defaults, %options);
    my %opts = map {
        $_ => _parse_option($options{$_}, $defaults{$_})
    } (keys %full);
    $self->{_options} = \%opts;
}

sub _parse_option {
    my ($option, $default) = @_;
    $default = ref $default eq 'HASH'
        ? $default : { match => $default };
    if (ref $option eq 'HASH') {
        my %option_with_defaults = (%$default, %$option);
        $option_with_defaults{use_hash} = 1;
        return \%option_with_defaults;
    }
    my %with_defaults = (
        %$default,
        match => ($option // $default->{match}),
        use_hash => 0,
    );
    return \%with_defaults;
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
    # Embedded options are of the form 'name__key', so we normalize
    # these to the form 'name => { key => ... }'.
    while (my ($option, $value) = each $self->_options) {
        if ($value->{use_hash}) {
            my %match_res = map {
                ($_ =~ s/^${option}__//r) => $match_result{$_}
            } (grep { $_ =~ /^${option}__/ } keys %match_result);
            $result{$option} = \%match_res;
        } else {
            $result{$option} = $match_result{$option};
        }
    }
    if (my $dir = $match_result{direction}) {
        $dir = lc $dir;
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
    # We embed any user captures in the result (overridden by internal
    # matches).
    return (%match_result, %result);
}

1;
