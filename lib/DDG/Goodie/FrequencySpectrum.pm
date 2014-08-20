package DDG::Goodie::FrequencySpectrum;
# ABSTRACT: describe the nature of various wave frequencies.

use strict;

use DDG::Goodie;

triggers end => "hz","khz","mhz","ghz","thz","hertz","kilohertz","gigahertz","megahertz","terahertz";

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

sub THOUSAND { 1000 };
sub MILLION { 1000000 };
sub BILLION { 1000000000 };
sub TRILLION { 1000000000000 };

#reference: https://en.wikipedia.org/wiki/Radio_spectrum
#Radio spectrum ranges along with example uses
my $radio_ranges =
  [
    [ "3", "29", "ELF band used by pipeline inspection gauges."],
    [ "30", "299", "SLF band used by submarine communication systems."],
    [ "300", "2999", "ULF band used by mine cave communication systems."],
    [ "3000", "29999", "VLF band used by government time stations and navigation systems."],
    [ "30000", "299999", "LF band used by AM broadcasts, government time stations, navigation systems, and weather alert systems."],
    [ "300000", "2999999", "MF band used by AM broadcasts, navigation systems, and ship-to-shore communication systems."],
    [ "3000000", "29999999", "HF band used by international shortwave broadcasts, aviation systems, government time stations, weather stations, and amateur radio."],
    [ "30000000", "299999999", "VHF band used by FM broadcasts, televisions, amateur radio, marine communication systems, and air traffic control."],
    [ "300000000", "2999999999", "UHF band used by televisions, cordless phones, cell phones, pagers, walkie-talkies, and satellites."],
    [ "3000000000", "29999999999", "SHF band used by microwave ovens, wireless LANs, cell phones, and satellites."],
    [ "30000000000", "299999999999", "EHF band used by radio telescopes, security screening systems, and point-to-point high-bandwidth devices."],
    [ "300000000000", "3000000000000", "THF band used by satellites and radio telescopes."],
  ];

#reference: https://en.wikipedia.org/wiki/Color
#Color ranges. Some colors are controversial but these are fairly well accepted.
my $color_ranges =
  [
    [ "400000000000000", "479999999999999", "red" ],
    [ "480000000000000", "504999999999999", "orange" ],
    [ "505000000000000", "524999999999999", "yellow" ],
    [ "525000000000000", "574999999999999", "green" ],
    [ "575000000000000", "609999999999999", "cyan" ],
    [ "610000000000000", "667999999999999", "blue" ],
    [ "668000000000000", "714999999999999", "indigo" ],
    [ "715000000000000", "800000000000000", "violet" ],
  ];

# reference: https://en.wikipedia.org/wiki/Musical_acoustics
#Ranges for common instruments 
my $instrument_ranges =
  [
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
    [ "58.270", "783.99", "bassoon" ],
    [ "233.08", "1760.0", "oboe" ],
  ];

# Reference: https://en.wikipedia.org/wiki/Ultraviolet
my $ultraviolet_ranges = 
    [
     [ 7.495*(10**14), 3*(10**16), "UV light is found in sunlight and is emitted by electric arcs and specialized lights such as mercury lamps and black lights." ],
    ];

# Reference: https://en.wikipedia.org/wiki/X-ray
my $xray_ranges = 
    [
     [ 3*(10**16), 3*(10**19), "X-rays are used for various medical and industrial uses such as radiographs and CT scans. "],
    ];

# Reference: 
my $gamma_ranges = 
    [
     [ 10**19, 10**24, "Gamma rays are can be used to treat cancer and for diagnostic purposes." ],
    ];

#Query is intitially processed here. First normalize the query format,
#normalize the units, and then calculate information about the frequency range.
handle query => sub {
  return unless $_ =~ m/^[\d,.]+\s\w+$/;
  return unless my $freq = normalize_freq($_);

  my $freq_hz;
  my $hz_abbrev;
  my $freq_formatted;
  
  if($freq =~ m/^(.+?)\s(?:hz|hertz)$/i) {
    $freq_hz = $1;
  } elsif($freq =~ m/^(.+?)\s(?:khz|kilohertz)$/i) {
    $freq_hz = $1 * THOUSAND;
  } elsif($freq =~ m/^(.+?)\s(?:mhz|megahertz)$/i) {
    $freq_hz = $1 * MILLION;
  } elsif($freq =~ m/^(.+?)\s(?:ghz|gigahertz)$/i) {
    $freq_hz = $1 * BILLION;
  } elsif($freq =~ m/^(.+?)\s(?:thz|terahertz)$/i) {
    $freq_hz = $1 * TRILLION;
  } else {
    #unexpected case
    return;
  }
  
  if($freq_hz >= TRILLION){
    $hz_abbrev = "THz";
    $freq_formatted = $freq_hz / TRILLION;
  } elsif($freq_hz >= BILLION) {
    $hz_abbrev = "GHz";
    $freq_formatted = $freq_hz / BILLION;
  } elsif($freq_hz >= MILLION) {
    $hz_abbrev = "MHz";
    $freq_formatted = $freq_hz / MILLION;
  } elsif($freq_hz >= THOUSAND) {
    $hz_abbrev = "kHz";
    $freq_formatted = $freq_hz / THOUSAND;
  } else {
    $hz_abbrev = "Hz";
    $freq_formatted = $freq_hz;
  }
  
  $freq = $freq_formatted . " " . $hz_abbrev;
  
  return prepare_result($freq, $freq_hz);
};

#Normalize the frequency, attempting to discern between region differences
#in number formatting. Filter out clearly invalid queries.
sub normalize_freq{
  my $freq = $_;

  if($freq =~ /(\d+\.){2,}|([.]{2,})|([,]{2,})/) {
      return;
  }

  # Remove commas.
  $freq =~ s/,//g;

  return $freq;
};

#Take the frequency and look at which ranges it falls in.
#Build up the result string.
sub prepare_result {
    my $freq = $_[0];
    my $freq_hz = $_[1];
    my $color = match_in_ranges(int($freq_hz), $color_ranges);
    my $radio = match_in_ranges(int($freq_hz), $radio_ranges) unless $color;
    my $instruments = matches_in_ranges($freq_hz, $instrument_ranges) unless $color;

    my $ultraviolet = matches_in_ranges($freq_hz, $ultraviolet_ranges);
    my $xray = matches_in_ranges($freq_hz, $xray_ranges);
    my $gamma = matches_in_ranges($freq_hz, $gamma_ranges);

    my $text_result = "";
    my $more_at = '';
    if($radio) {
	$text_result = $freq . " is a radio frequency in the " . $radio;
	$more_at = 'https://en.wikipedia.org/wiki/Radio_spectrum';
    } elsif($color) {
	$text_result = $freq . " is an electromagnetic frequency of " . $color . " light.";
	$more_at = 'https://en.wikipedia.org/wiki/Color';
    }
    if($instruments) {
	$more_at = 'https://en.wikipedia.org/wiki/Musical_acoustics';
	$instruments =~ s/,\s([a-zA-Z\s-]+)$/, and $1/;
	if($radio) {
	    $text_result = $text_result . "\n" . $freq . " is also an audible frequency which can be produced by " . $instruments . ".";
	} else {
	    $text_result = $freq . " is an audible frequency which can be produced by " . $instruments . ".";
	}
    }

    if($ultraviolet) {
	$more_at = 'https://en.wikipedia.org/wiki/Ultraviolet';
	$text_result = $ultraviolet;
    }
    if($xray) {
	$more_at = 'https://en.wikipedia.org/wiki/X-ray';
	$text_result = $xray;
    }
    if($gamma) {
	$more_at = 'https://en.wikipedia.org/wiki/Gamma_ray';
	$text_result = $gamma;
    }

    if($text_result) {
	(my $html_result = $text_result) =~ s/\n/<br>/g;
	$html_result .= "<br><a href='$more_at'>More at Wikipedia</a>";
	$text_result .= "\nMore at $more_at";
	return $text_result, html => $html_result, heading => "$freq (Frequency Spectrum)";
    }

    return;
};

#Find which single range applies.
sub match_in_ranges {
    my $freq = $_[0];
    my $ranges = $_[1];

    foreach my $range (@$ranges) {
	if($freq >= $range->[0] && $freq <= $range->[1]){
	    return $range->[2];
	}
    }

    return "";
};

#Find any number of ranges which apply.
sub matches_in_ranges {
    my $freq = $_[0];
    my $ranges = $_[1];
    my @matches;
    foreach my $range (@$ranges) {
	if($freq >= $range->[0] && $freq <= $range->[1]) {
	    push(@matches, $range->[2]);
	}
    }

    return join(", ", @matches);
};

1;
