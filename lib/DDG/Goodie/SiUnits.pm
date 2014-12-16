package DDG::Goodie::SiUnits;
# ABSTRACT: Convert composite units into SI units.                                                                                                                                                                                             
use DDG::Goodie;

zci answer_type => 'si_base_units';
zci is_cached => 1;

name 'Si Units';
source 'http://en.wikipedia.org/wiki/International_System_of_Units';
description 'convert composite units into si base units';
primary_example_queries 'newtons in si base units';
secondary_example_queries 'si joules';
category 'conversions';
topics 'math', 'science';
code_url 'https://github.com/mohamadissawi/zeroclickinfo-spice/blob/master/lib/DDG/Goodie/SiUnits.pm';
attribution github  => ["https://github.com/mohamadissawi", "Mohamad Issawi"];
            

#looks for keywords
triggers start => 'si', 'si units', 'si base units';                                                                                                                                                              
triggers end => 'si', 'in si', 'si units', 'in si units', 'si base units', 'in si base units'; 

#read conversion statements from share directory
my @lines = split /\n/, share("si_units.txt")->slurp;

#picks unit name out of remainder
handle remainder => sub {

    #greps the text file for the unit of interest
    my $unit = $_;
    my $ans = join "", grep /<div class="zci--statement">$unit /i, @lines;
    
    chomp ($ans);

    #returns the instant answer, and treats the text as html
    return "", html => "$ans" if $ans;
    return ;
};
1;
