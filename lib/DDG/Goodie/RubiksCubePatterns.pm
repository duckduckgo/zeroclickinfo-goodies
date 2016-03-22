package DDG::Goodie::RubiksCubePatterns;
# ABSTRACT: Create interesting patterns from a solved Rubik's Cube.

use strict;
use DDG::Goodie;

triggers start =>	"rcube", "rubik", "rubiks", "rubix",
					"rubicks", "rubik's", "rubic's", "rubick's",
					"rubik cube", "rubiks cube", "rubic cube", "rubics cube",
					"rubik's cube";

zci answer_type => "rubiks_cube";
zci is_cached   => 1;

my $goodieVersion = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;

my %patterns = (
    "stripes" => "F U F R L2 B D' R D2 L D' B R2 L F U F",
    "crosses" => "U F B' L2 U2 L2 F' B U2 L2 U",
    "swap centers" => "U D' R L' F B' U D'",
    "checkerboard" => "F2 B2 R2 L2 U2 D2",
    "cube in a cube" => "F L F U' R U F2 L2 U' L' B D' B' L2 U",
    "cube in a cube in a cube" => "U' L' U' F' R2 B' R F U B2 U B' L U' F U R F'",
    "exchanged peaks" => "F2 R2 D R2 U D F2 D' R' D' F L2 F' D R U'",
    "t's" => "F2 R2 U2 F' B D2 L2 F B",
    "anaconda" => "L U B' U' R L' B R' F B' D R D' F'",
    "python" => "F2 R' B' U R' L F' L F' B D' R B L2",
    "black mamba" => "R D L F' R L' D R' U D' B U' R' D'",
    "slash" => "R L F B R L F B R L F B",
);

sub to_titlecase($)
{
    $a = pop;
    $a =~ s/(\w\S*)/\u\L$1/g;
    $a =~ s/ In / in /g;
    $a =~ s/ A / a /g;
    return $a;
}

sub render_text($) {
    my $name = pop;
    return to_titlecase($name) . ": $patterns{$name} \n";
}

handle remainder_lc => sub {

    return if ($_ eq '');
    #support British English!
    s/centre/center/;

    #hack for the trigger "rubiks cube in a cube"
    s/^in a cube/cube in a cube/;
	
    my @items;
    my $output;
    my $title;
    
    if ($patterns{$_}) {
        $output = render_text($_);
        $title = $patterns{$_};
        my $subtitle = "Rubiks cube '" . to_titlecase($_) . "' pattern";
        my $filename = get_file_name($_);
        @items = {
            title => $title,
            description => $subtitle,
            image => $filename
        };
    } else {
        return if ($_ ne 'patterns');
        foreach my $pattern (keys %patterns) {
            $output .= render_text($pattern);
            my %result = (
                title => to_titlecase($pattern) . " pattern",
                description => $patterns{$pattern},
                image => get_file_name($pattern),
            );
            $title = $patterns{$_};
            push @items, \%result;
        }
    }

    return $output,
    structured_answer => {
        id => 'rubiks_cube_patterns',
        name => 'Answer',
        data => \@items,
        templates => {
            group => 'info',
            variants => {
                tile => 'poster'
            }
        }
     };
};

1;

sub get_file_name {
    my $fn = shift;
    #e.g transforms "swap centers" into "swap_centers"
    $fn =~ s/ /_/g;
    #e.g transforms "t's" into "ts"
    $fn =~ s/'//g;
    return "/share/goodie/rubiks_cube_patterns/$goodieVersion/$fn.svg";
}