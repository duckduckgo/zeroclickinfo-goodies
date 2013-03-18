package DDG::Goodie::Fortune;

use DDG::Goodie;
use Fortune;

triggers start => 'fortune';

zci is_cached => 1;
zci answer_type => "fortune";

handle remainder => sub {
   my $ffile = share('fortunes');
   my $fortune_file = new Fortune($ffile);
   $fortune_file->read_header();
   my $output = $fortune_file->get_random_fortune();
   $output =~ s/\n//g;
   return $output;
};

1;
