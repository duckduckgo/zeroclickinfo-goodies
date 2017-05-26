package DDG::GoodieRole::Parser::Spec;
# Specifications for sub-grammar forms.

BEGIN {
    require Exporter;

    our @ISA    = qw(Exporter);
    our @EXPORT = qw(new_spec);
}
use Moose;
use List::MoreUtils qw(zip);
use List::Util qw(pairs);

has 'terms' => (
    is       => 'ro',
    isa      => 'ArrayRef[DDG::GoodieRole::Parser::Spec::Term]',
    required => 1,
);

sub collector {
    my ($self,$sub) = @_;
    return sub {
        my $grammar_self = shift;
        my $h = $self->generate_argument_forms($grammar_self);
        return $sub->($h);
    };
}

sub generate_argument_forms {
    my ($self, $args) = @_;
    my $h = {
        args => [],
        forms => [],
    };
    foreach my $pair (pairs(zip @{$self->terms}, @$args)) {
        my ($term, $arg) = @$pair;
        push @{$h->{$term->is_form ? qw(forms) : qw(args)}}, $arg;
    };
    return $h;
}

sub term_to_grammar {
    my ($term, $term_def) = @_;
    return $term_def if $term_def =~ /^\[/;
    return $term->{ignore_case} ? "'$term_def':i" : "'$term_def'";
}

sub generate_lexical_definition {
    my ($term, $name, $subform_num, $forms) = @_;
    my $refer_to = "<gen @{[$name =~ s/[^[:alnum:]]/ /gr]} forms$subform_num>";
    my $refer_definitions = $refer_to . ' ~ ' . join(' | ',
                    map { term_to_grammar($term, $_) } @$forms);
    return  ($refer_to, $refer_definitions);
}

sub to_grammar {
    my ($self, $is_first, $gterm) = @_;
    my $name = $gterm->{name};
    my $alternates = [];
    my @gforms = @{$gterm->{forms}};
    my $rhs = [];
    my $vcount = 0;
    foreach my $var_term (grep { $_->is_variable } @{$self->terms}) {
        $var_term->static_forms($gforms[$vcount]);
        $vcount++;
    };
    my $count = 0;
    my $sfcount = 0;
    foreach my $term (@{$self->terms}) {
        if (ref $term->static_forms eq 'ARRAY') {
            my ($refer, $refer_def) = generate_lexical_definition $gterm, $name, $sfcount, $term->static_forms;
            push $alternates, {
                refer_label => $refer,
                refer_form => $refer_def,
            };
            $sfcount++;
            $term->refer($refer);
        } else {
            $term->refer($term->static_forms);
        };
        push $rhs, $term->to_grammar;
    };
    return (generate_grammar_line($rhs, $gterm, $is_first), $alternates);
};

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

__PACKAGE__->meta->make_immutable;

sub new_spec { DDG::GoodieRole::Parser::Spec->new({terms=>$_[0]}) };

1;
