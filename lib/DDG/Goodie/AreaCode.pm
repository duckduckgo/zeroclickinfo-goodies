package DDG::Goodie::AreaCode;

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "areacode";

# Regexp for AreaCode.
my $area_code_qr = qr/areacode/io;

primary_example_queries 'area codes 209';
description 'Find the telephone area code';
name 'Area Code';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/AreaCode.pm';
category 'geography';
topics 'everyday', 'geography';
attribution web => [ 'https://www.duckduckgo.com', 'DuckDuckGo' ],
            github => [ 'https://github.com/duckduckgo', 'duckduckgo'],
            twitter => ['http://twitter.com/duckduckgo', 'duckduckgo'];

triggers query_nowhitespace => qr/$area_code_qr.*(?<!\d)([\d]{3}?)(?!\d)|([\d]{3}?)(?!\d).*$area_code_qr/o;

my %state_names = ();
my @states = share('states.txt')->slurp;

foreach my $state (@states) {
  chomp($state);
  my @split_state = split(/=>/, $state);
  $state_names{$split_state[0]} = $split_state[1];
}

my %area_code_check = ();
my @areas = share('area_codes.txt')->slurp;

foreach my $area (@areas) {
  chomp($area);
  my @split_area = split(/=>/, $area);
  $area_code_check{$split_area[0]} = $split_area[1];
}

handle query_nowhitespace => sub {
    sub area_code_location {
        my ($str, $state_names_ref) = @_;

        my ($sub_country, $country) = $str =~ /(.*), (.*)/;
        grep( $_ =~ s/\"//g, ( $sub_country, $country ) );

        if ($country eq 'US' && length($sub_country) == 2) {
            $str = $$state_names_ref{uc $sub_country};
        }
        elsif ($country eq 'CANADA') {
            $str = "$sub_country, Canada";
        }
        else {
            $str = $sub_country;
        }

        return $str;
    }

    my $area_code = $1 || $2;
    my $is_area_code = 0;
    my $area_code_location = '';
    if(exists $area_code_check{$area_code}) {
        $area_code_location = $area_code_check{$area_code};
    }
    if ($area_code_location) {
        my ($sub_country, $country) = $area_code_location =~ /(.*), (.*)/;
        grep($_ =~ s/\"//g, ($sub_country, $country));

        # Make string for display.
        $area_code_location = &area_code_location($area_code_location, \%state_names);

        my $map = '';
        if ($country eq 'US' && length($sub_country) == 2 ) {
            $sub_country = lc $sub_country;
            $map         = qq(<a href="http://www.nanpa.com/area_code_maps/display.html?$sub_country">) . 'Map' . '</a>';
        }
        elsif ($country eq 'CANADA' ) {
            $map = qq(<a href="http://www.cnac.ca/npa_codes/npa_map.htm">) . 'Map' . '</a>';
        }
        else {
            my $sub_country_escape = encode_for_link($sub_country);
            $map = qq(<a href="http://open.mapquest.com/?q=$sub_country_escape">) . 'Map' . '</a>';
        }

        return "$area_code is an area code in $area_code_location", heading => "Area Codes ($area_code_location)", html => "$area_code is an area code in $area_code_location" . " - " . $map;    
    }

    return;
};

1;
