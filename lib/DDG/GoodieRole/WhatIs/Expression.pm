package DDG::GoodieRole::WhatIs::Expression;
# ABSTRACT: Allow building of regular expressions in an intuitive
# manner.

use Moo;

BEGIN {
    require Exporter;

    our @ISA = qw(Exporter);
    our @EXPORT_OK = qw(expr);
}

#######################################################################
#                               Object                                #
#######################################################################

has 'options' => (
    is => 'ro',
    isa => sub { die 'Not a HASH reference' unless ref $_[0] eq 'HASH' },
);

has 'regex' => (
    is => 'rw',
    isa => sub { die 'Not a Regexp reference' unless ref $_[0] eq 'Regexp' },
    default => sub { qr// },
);

sub append_to_regex {
    my ($self, $regex) = @_;
    my $new_regex = qr/${$self->regex}$regex/;
    $self->regex($new_regex);
    return $self;
}

sub append_spaced {
    my ($self, $regex) = @_;
    my $new_re;
    $new_re = $self->regex eq qr// ? $regex : qr/ $regex/;
    $self->append_to_regex($new_re);
}

sub expr {
    my $options = shift;
    if (ref $options eq 'DDG::GoodieRole::WhatIs::Expression') {
        return DDG::GoodieRole::WhatIs::Expression->new(
            options => $options->options
        );
    }
    return DDG::GoodieRole::WhatIs::Expression->new(
        options => $options
    );
}

sub opt {
    my ($self, $option) = @_;
    my $val = $self->options->{$option};
    $self->append_spaced(qr/(?<$option>$val)/);
}

sub re {
    my ($self, $regex) = @_;
    $self->append_to_regex($regex);
}

sub or {
    my ($self, @alternatives) = @_;
    my $regexes = join '|', map { $_->regex } @alternatives;
    $self->append_to_regex(qr/(?:$regexes)/);
}

1;

__END__
