package DDG::Goodie::PercentError;

use DDG::Goodie;

triggers start => "percent error", "% error", "%err", "%error", "percenterror";

zci answer_type => "percent_error";
zci is_cached => 1;

handle remainder => sub {
    my $length = length($_);
#return unless $length == 2;

    my ( $acc, $exp ) = split ' ', $_;
    $acc =~ s/[{},;\s]+//g;
    $exp =~ s/[{},;\s]+//g;
    return unless $acc =~ /^-?\d+?(?:\.\d+|)$/ && $exp =~ /^-?\d+?(?:\.\d+|)$/;

    my $diff = abs $acc - $exp;
    my $per = abs ($diff/$acc);
    my $err = $per*100;

    my $html = qq(Accepted: $acc Experimental: $exp Error: <a href="javascript:;" onclick="document.x.q.value='$per';document.x.q.focus();">$err%</a>);
    
    return "Accepted: $acc Experimental: $exp Error: $err%", html => $html;
};

1;
