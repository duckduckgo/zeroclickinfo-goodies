package DDG::Goodie::FrequencySpectrum;

use strict;

use DDG::Goodie;

triggers end => "hz","khz","mhz","ghz","thz","hertz","kilohertz","gigahertz","megahertz","terahertz";

zci is_cached => 1;
zci answer_type => "frequency_spectrum";

primary_example_queries '50 hz';
secondary_example_queries '400 thz';
description 'Returns information about light, radio, and sound frequencies';
name 'FrequencySpectrum';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/FrequencySpectrum.pm';
category 'physical_properties';
topics 'science';
attribution web => "https://machinepublishers.com",
            twitter => 'machinepub';

handle query => sub {
  return unless $_ =~ m/^[\d,.]+\s\w+$/;
  return unless my $freq = normalize_freq($_);

  my $freq_hz;
  my $hz_abbrev;
  my $freq_formatted;
  
  if($freq =~ m/^(.+?)\s(?:hz|hertz)$/i){
    $freq_hz = $1;
  }elsif($freq =~ m/^(.+?)\s(?:khz|kilohertz)$/i){
    $freq_hz = $1 * 1000;
  }elsif($freq =~ m/^(.+?)\s(?:mhz|megahertz)$/i){
    $freq_hz = $1 * 1000000;
  }elsif($freq =~ m/^(.+?)\s(?:ghz|gigahertz)$/i){
    $freq_hz = $1 * 1000000000;
  }elsif($freq =~ m/^(.+?)\s(?:thz|terahertz)$/i){
    $freq_hz = $1 * 1000000000000;
  }else{
    #unexpected case
    return;
  }
  
  if($freq_hz >= 1000000000000){
    $hz_abbrev = "THz";
    $freq_formatted = $freq_hz / 1000000000000;
  }elsif($freq_hz >= 1000000000){
    $hz_abbrev = "GHz";
    $freq_formatted = $freq_hz / 1000000000;
  }elsif($freq_hz >= 1000000){
    $hz_abbrev = "MHz";
    $freq_formatted = $freq_hz / 1000000;
  }elsif($freq_hz >= 1000){
    $hz_abbrev = "kHz";
    $freq_formatted = $freq_hz / 1000;
  }else{
    $hz_abbrev = "Hz";
    $freq_formatted = $freq_hz;
  }
  
  
  $freq = $freq_formatted . " " . $hz_abbrev;
  
  return prepare_result($freq, $freq_hz);
};

sub normalize_freq{
  my $freq = $_;
  if($freq =~ m/^[\d]+(\.\d+)?\s\w+$/){
    #only digits and one dot are present,
    #presume they're in perl number notation and do nothing
  }elsif($freq =~ m/^[\d]+(,\d+)?\s\w+$/){
    #only digits and one comma are present,
    #presume the comma is a decimal separator
    $freq =~ s/,/./g; 
  }elsif($freq =~ m/^[\d.]+\s\w+$/){
    #digits and multiple dots are present,
    #presume dots are thousands separators
    $freq =~ s/\.//g;
  }elsif($freq =~ m/^[\d,]+\s\w+$/){
    #digits and multiple commas are present,
    #presume commas are thousands separators
    $freq =~ s/,//g;
  }elsif($freq =~ m/^(?:\d+\.)+\d+,\d+\s\w+$/){
    #dot occurs before comma,
    #presumed that thousands separator is dot and decimal separator is comma
    $freq =~ s/\.//g;
    $freq =~ s/,/./g;
  }elsif($freq =~ m/^(?:\d+,)+\d+\.\d+\s\w+$/){
    #comma occurs before dot,
    #presumed that thousands separator is comma and decimal separator is dot
    $freq =~ s/,//g;
  }else{
    #unexpected format
    return;
  }
  return $freq;
};

sub prepare_result{
  my $freq = $_[0];
  my $freq_hz = $_[1];
  my $color = match_in_ranges(int($freq_hz), color_ranges());
  my $radio = match_in_ranges(int($freq_hz), radio_ranges()) unless $color;
  my $instruments = matches_in_ranges($freq_hz, instrument_ranges()) unless $color;
  my $text_result = "";
  if($radio){
    $text_result = $freq . " is a radio frequency in the " . $radio . " band.";
  }elsif($color){
    $text_result = $freq . " is an electromagnetic frequency of " . $color . " light.";
  }
  if($instruments){
    $instruments =~ s/,\s(\w+)$/, and $1/;
    if($radio){
      $text_result = $text_result . "\n" . $freq . " is also an audible frequency which can be produced by " . $instruments . ".";
    }else{
      $text_result = $freq . " is an audible frequency which can be produced by " . $instruments . ".";
    }
  }
  if($text_result){
    (my $html_result = $text_result) =~ s/\n/<br>/g;
    $html_result .= '<br><a href="https://en.wikipedia.org/wiki/Frequency_spectrum">More at Wikipedia</a>';
    $text_result .= "\nMore at https://en.wikipedia.org/wiki/Frequency_spectrum";
    return $text_result, html => $html_result, heading => "$freq (Frequency Spectrum)";
  }
  return;
};

sub radio_ranges(){
  #reference: https://en.wikipedia.org/wiki/Radio_spectrum
  return [
    [ "3", "29", "ELF" ],
    [ "30", "299", "SLF" ],
    [ "300", "2999", "ULF" ],
    [ "3000", "29999", "VLF" ],
    [ "30000", "299999", "LF" ],
    [ "300000", "2999999", "MF" ],
    [ "3000000", "29999999", "HF" ],
    [ "30000000", "299999999", "VHF" ],
    [ "300000000", "2999999999", "UHF" ],
    [ "3000000000", "29999999999", "SHF" ],
    [ "30000000000", "299999999999", "EHF" ],
    [ "300000000000", "3000000000000", "THF" ],
    ];
};

sub color_ranges(){
  #reference: https://en.wikipedia.org/wiki/Color
  return [
    [ "400000000000000", "479999999999999", "red" ],
    [ "480000000000000", "504999999999999", "orange" ],
    [ "505000000000000", "524999999999999", "yellow" ],
    [ "525000000000000", "574999999999999", "green" ],
    [ "575000000000000", "609999999999999", "cyan" ],
    [ "610000000000000", "667999999999999", "blue" ],
    [ "668000000000000", "714999999999999", "indigo" ],
    [ "715000000000000", "800000000000000", "violet" ],
    ];
};

sub instrument_ranges(){
  # reference: https://en.wikipedia.org/wiki/Musical_acoustics
  return [
    [ "87", "1046", "human voice" ],
    [ "82.407", "329.63", "bass vocalists" ],
    [ "87.307", "349.23", "baritone vocalists" ],
    [ "130.81", "440.00", "tenor vocalists" ],
    [ "196.00", "698.46", "alto vocalists" ],
    [ "220.00", "880.00", "mezzo-soprano vocalists" ],
    [ "261.63", "880.00", "soprano vocalists" ],
    [ "41.203", "523.25", "double-bass" ],
    [ "130.81", "1760.00", "viola" ],
    [ "196.00", "2637.00", "violin" ],
    [ "82.41", "1046.5", "guitar" ],
    [ "196.00", "1396.9", "mandolin" ],
    [ "130.81", "1046.5", "banjo" ],
    [ "27.500", "4186.0", "piano" ],
    [ "38.891", "440.00", "tuba" ],
    [ "82.407", "523.25", "trombone" ],
    [ "164.81", "932.33", "trumpet" ],
    [ "207.65", "1244.5", "saxophone" ],
    [ "261.63", "2093.0", "flute" ],
    [ "146.83", "1864.7", "clarinet" ],
    [ "58.270", "783.99", "basoon" ],
    [ "233.08", "1760.0", "oboe" ],
    ];
};

sub match_in_ranges{
  my $freq = $_[0];
  my $ranges = $_[1];
  
  foreach my $range (@$ranges){
    if($freq >= $range->[0] && $freq <= $range->[1]){
      return $range->[2];
    }
  }
  return "";
};

sub matches_in_ranges{
  my $freq = $_[0];
  my $ranges = $_[1];
  my @matches;
  foreach my $range (@$ranges){
    if($freq >= $range->[0] && $freq <= $range->[1]){
      push(@matches, $range->[2]);
    }
  }
  return join(", ", @matches);
};

1;