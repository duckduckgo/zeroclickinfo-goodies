package DDG::Goodie::Calculator::Parser::Grammar;

BEGIN {
    require Exporter;

    our @ISA    = qw(Exporter);
    our @EXPORT = qw(new_sub_grammar);
}

use Moose;
use namespace::autoclean;
use utf8;

has spec => (
    is       => 'ro',
    required => 1,
    isa      => 'CodeRef',
);
has name => (
    is       => 'ro',
    required => 1,
    isa      => 'Str',
);
has terms => (
    is  => 'rw',
    isa => sub { [] },
);
has bless_counter => (
    is      => 'ro',
    default => 0,
    isa     => 'Int',
);
has ignore_case => (
    is      => 'ro',
    default => 0,
    isa     => 'Bool',
);

sub generate_sub_grammar {
    my $self = shift;
    my $str_grammar = $self->{name} . " ::= \n";
    my ($first_term, @terms) = @{$self->terms()};
    my ($first_refer, $first_refer_def) = generate_alternate_forms($first_term);
    my @alternate_forms = ($first_refer_def) if defined $first_refer_def;
    $str_grammar .= generate_grammar_line($self->{spec}->($first_refer), $first_term, 1);
    foreach my $term (@terms) {
        my ($refer, $refer_def) = generate_alternate_forms($term);
        push @alternate_forms, $refer_def;
        $str_grammar .= generate_grammar_line($self->{spec}->($refer), $term, 0);
    };
    foreach my $alternate_form (@alternate_forms) {
        $str_grammar .= "\n$alternate_form\n";
    };
    return $str_grammar;
}
sub add_term {
    my ($self, $term) = @_;
    $self->{bless_counter}++;
    $term->{name} = ($self->name . $self->bless_counter);
    $term->{forms} //= [$term->{rep}];
    $term->{ignore_case} = $self->ignore_case;
    push @{$self->{terms}}, $term;
}

__PACKAGE__->meta->make_immutable;

sub generate_grammar_line {
    my ($rhs, $term, $is_first) = @_;
    my $result;
    my $blessf = $term->{name};
    $result .= '    ' . ($is_first ? '  ' : '| ');
    $result .= join ' ', @$rhs;
    $result .= " bless => $blessf";
    $result .= ' assoc => ' . $term->{assoc} if defined $term->{assoc};
    return "$result\n";
}

sub generate_alternate_forms {
    my $term = shift;
    my $name = $term->{name};
    my $forms = $term->{forms};
    my ($refer_to, $refer_definition);
    if (ref $forms eq 'ARRAY') {
        $refer_to = "<gen @{[$name =~ s/[^[:alnum:]]/ /gr]} forms>";
        $refer_definition = $refer_to . ' ~ ' . join(' | ',
            map { $term->{ignore_case} ? "'$_':i" : "'$_'" } @$forms);
    } else {
        $refer_to = "'$forms'";
    };
    return ($refer_to, $refer_definition);
}

sub new_sub_grammar { DDG::Goodie::Calculator::Parser::Grammar->new(@_) };

1;
