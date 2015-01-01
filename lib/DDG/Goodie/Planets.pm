package DDG::Goodie::Planets;
# ABSTRACT: Return various attributes of a planet

use DDG::Goodie;
use YAML::XS qw( Load );
use POSIX;

zci answer_type => "planets";
zci is_cached   => 1;

name "Planets";
primary_example_queries 'size of venus';
secondary_example_queries 'what is the size of venus', 'volume of venus';
description 'Lookup various attributes of planets';
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Planets.pm";
category 'conversions';
topics 'special_interest';
attribution github => 'chrisjwilsoncom',
            twitter => 'chrisjwilsoncom';

my @triggers = qw(size radius volume mass);
triggers any => @triggers;

# Load planet data 
# https://en.wikipedia.org/wiki/List_of_gravitationally_rounded_objects_of_the_Solar_System
my $planets = Load(scalar share('planets.yml')->slurp);

# Handle statement
handle query_lc => sub {

  s/\?//g; # Strip question marks.
  s/of|what|is|the//g; #remove common words

  #if (m/size/) { }
  #if (m/radius/) { }
  #if (m/volume/) { }
  #if (m/mass/) { }

  my $triggers = join('|', @triggers);
  s/$triggers//g; #remove keywords
  s/^\s+|\s+$//g; #trim

  return unless $_; 

  my $planetObj = $planets->{$_};


  my $html = '<div>';
  $html .= '<div class="zci__caption">' . commify(ceil($planetObj->{equatorial_radius})) . 'km </div> (' . ceil($planetObj->{equatorial_radius}* 0.6214) . ' miles)';
  $html .= '<div class="zci__subheader">' . $planetObj->{equatorial_radius} . '</div>';
  $html .= '</div>';

  return $planetObj->{equatorial_radius}, html => $html;
};
1;

sub commify {
    my $text = reverse $_[0];
    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text;
}