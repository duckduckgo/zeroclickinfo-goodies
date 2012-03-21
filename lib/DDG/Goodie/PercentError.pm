package DDG::Goodie::PercentError;

use DDG::Goodie;

triggers start => "percent", "%", "percent-error", "% error", "%err";

zci answer_type => "PercentError";
zci is_cached => 1;
handle query_parts => sub {
    shift;
    shift if @_[0] eq 'error' || @_[0] eq 'err';

    my $length = @_;
    return unless $length == 2;

    my ( $acc, $exp ) = @_;
    $acc =~ s/[{},;\s]+//g;
    $exp =~ s/[{},;\s]+//g;

    my $diff = abs $acc - $exp;
    my $err = abs ($diff/$acc*100);

    my $html = qq(Accepted: <a href="javascript:;" onclick="document.x.q.value='$acc';document.x.q.focus();">$acc</a> Experimental: <a href="javascript:;" onclick="document.x.q.value='$exp';document.x.q.focus();">$exp</a> Error: <a href="javascript:;" onclick="document.x.q.value='$err';document.x.q.focus();">$err</a>);
    
    return "Accepted: $acc Experimental: $exp Error: $err%", html => $html;
};

1;
