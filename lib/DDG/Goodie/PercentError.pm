package DDG::Goodie::PercentError;

use DDG::Goodie;

triggers start => "percent", "%", "percent-error";

zci answer_type => "percent-error";

handle query_parts => sub {
    shift;
    shift if @_[0] eq 'error' || @_[0] eq 'err';

    my $length = @_;
    print "$length\n";
    return unless $length == 2;

    my ( $acc, $exp ) = @_;
    $acc =~ s/[{},;\s]+//g;
    $exp =~ s/[{},;\s]+//g;

    my $diff = abs $acc - $exp;
    my $err = abs ($diff/$acc*100);
    
    return "Accepted: $acc\nExperimental: $exp\nError: $err%";
};

1;
