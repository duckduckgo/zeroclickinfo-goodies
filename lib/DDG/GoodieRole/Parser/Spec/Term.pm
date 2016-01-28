package DDG::GoodieRole::Parser::Spec::Term;
# Individual terms of a sub-grammar.

BEGIN {
    require Exporter;

    our @ISA    = qw(Exporter);
    our @EXPORT = qw(static_arg variable_form
                     static_form variable_arg);
}

use Moose;

has 'text' => (
    is   => 'rw',
    isa  => 'Str',
);

has 'is_form' => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

has 'is_variable' => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);
has 'static_forms' => (
    is => 'rw',
);
has 'refer' => (
    is  => 'rw',
    isa => 'Str',
);

sub new_spec_term {
    DDG::GoodieRole::Parser::Spec::Term->new(@_);
}


sub to_grammar {
    my $self = shift;
    my $check = $self->refer;
    return $check if $check =~ /^[[:upper:]<\[]/;
    return "'$check'";
}

__PACKAGE__->meta->make_immutable;

# Term requiring no arguments and will be passed on as one.
sub static_arg {
    my $forms = shift;
    new_spec_term {
        is_form      => 0,
        is_variable  => 0,
        static_forms => $forms,
    };
}
sub static_form {
    my $forms = shift;
    new_spec_term {
        is_form      => 1,
        is_variable  => 0,
        static_forms => $forms,
    };
}
sub variable_form {
    new_spec_term {
        is_form     => 1,
        is_variable => 1,
    };
}
sub variable_arg {
    new_spec_term {
        is_form     => 0,
        is_variable => 1,
    };
}

1;
