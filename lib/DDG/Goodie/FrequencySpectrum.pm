package DDG::Goodie::FrequencySpectrum;
# ABSTRACT: Return information about light, radio and sound frequencies

use strict;
use SVG;
use DDG::Goodie;
use Lingua::EN::Inflect qw(WORDLIST);

zci answer_type => "frequency_spectrum";

primary_example_queries '50 hz';
secondary_example_queries '400 thz';
description 'Returns information about light, radio, and sound frequencies';
name 'FrequencySpectrum';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/FrequencySpectrum.pm';
category 'physical_properties';
topics 'science';
attribution web => "https://machinepublishers.com", twitter => 'machinepub';

#Regex to match a valid query
# Used for trigger and later for parsing
my $frequencySpectrumQR = qr/^(?<quantity>[\d,]+(\.\d+)?)\s?(?<factor>k|kilo|m|mega|g|giga|t|tera)?(?:hz|hertz)$/;
triggers query_raw => qr/$frequencySpectrumQR/i;

#SI prefixes
my %factors = ( 
    k => {
        multiplier => 1e3,
        cased => 'k'
    },
    m => {
        multiplier => 1e6,
        cased => 'M'
    },
    g => {
        multiplier => 1e9,
        cased => 'G'
    },
    t => {
        multiplier => 1e12,
        cased => 'T'
    }
);

#Load the CSS
#Much styling for the plots was taken from http://bl.ocks.org/mbostock/4061961
my $css = share("style.css")->slurp;

#Load electromagnetic frequency ranges
# References: 
# https://en.wikipedia.org/wiki/Radio_spectrum
# https://en.wikipedia.org/wiki/Ultraviolet
# https://en.wikipedia.org/wiki/X-ray
# https://en.wikipedia.org/wiki/Color
my @electromagnetic;
foreach (split /\n/, share("electromagnetic.txt")->slurp) {
    my @range = split /\t/, $_;
    push @electromagnetic, {
        subspectrum => $range[0],
        min => $range[1],
        max => $range[2],
        description => $range[3]
    };
}

#Frequency ranges for EM subspectra
my %emSpectrum = (
    'radio' => {
        min => 0, 
        max => 3000000000000,
        track => 1
    },
    'visible light' => {
        min => 400000000000000, 
        max => 800000000000000,
        track => 2
    },
    'ultraviolet' => {
        min => 749500000000000, 
        max => 30000000000000000,
        track => 3
    },
    'x-ray' => {
        min => 30000000000000000, 
        max => 30000000000000000000,
        track => 4
    },
    'gamma' => {
        min => 30000000000000000000, 
        max => 3000000000000000000000000,
        track => 5
    }
);

#Load audible frequency ranges
#Reference: https://en.wikipedia.org/wiki/Musical_acoustics
my @audible;
foreach (split /\n/, share("audible.txt")->slurp) {
    my @range = split /\t/, $_;
    push @audible, {
        min => $range[0],
        max => $range[1],
        produced_by => $range[2]
    };
}

#Query is intitially processed here. First normalize the query format,
# normalize the units, and then calculate information about the frequency range.
handle query => sub {

    my $query = shift;

    my $freq_hz;
    my $freq_formatted;
    my $answer;
    my $html;

    #Extract frequency and unit
    if ($query =~ /$frequencySpectrumQR/i) {
        my $prefix = $+{factor} ? lc substr($+{factor}, 0, 1) : 0;
        my $factor = $+{factor} ? $factors{$prefix}{'multiplier'} : 1;
        my $quantity = $+{quantity};
        $quantity =~ s/,//g;
        $freq_hz = $quantity * $factor;
        my $hz_formatted = $prefix ? $factors{$prefix}{'cased'} . 'Hz' : 'Hz';
        $freq_formatted = $quantity . ' ' . $hz_formatted;

    } else {
        return;
    }

    #Look for a match in the electromagnetic spectrum
    my $emMatch = match_electromagnetic($freq_hz);
    if ($emMatch) {

        my $emDescription = $freq_formatted . ' is a ' . $$emMatch{'subspectrum'} . ' frequency' . $$emMatch{'description'} . '.';

        $answer .= $emDescription;
        $html .= $emDescription;

        #Add a plot to the html
        #Prepare parameters
        my $rangeMin = 0;
        my $rangeMax = 10000000000000000000000000;
        my $bandMin = $$emMatch{'min'};
        my $bandMax = $$emMatch{'max'};
        my $subspectrum = $$emMatch{'subspectrum'};
        my $tracks = scalar keys %emSpectrum;

        #Set up the plot panel
        (my $plot, my $transform) = generate_panel($rangeMin, $rangeMax, $tracks);

        #Add a major range for each subspectrum (e.g. radio or UV)
        foreach (sort {$emSpectrum{$a}{'track'} <=> $emSpectrum{$b}{'track'} } keys %emSpectrum) {
            $plot = add_major_range($plot, $transform, $emSpectrum{$_}{'min'}, $emSpectrum{$_}{'max'}, $_, $emSpectrum{$_}{'track'});
        }

        #Add a minor range for the band (unless the band is the subspectrum)
        if (! ($emSpectrum{$subspectrum}{'min'} == $bandMin && $emSpectrum{$subspectrum}{'max'} == $bandMax)) {
            $plot = add_minor_range($plot, $transform, $bandMin, $bandMax, $emSpectrum{$subspectrum}{'track'});
        }

        #Add a marker for the query frequency
        $plot = add_marker($plot, $transform, $freq_hz, $tracks);

        #Generate the SVG
        $html .= $plot->xmlify;

    }

    #Look for matches in the audible spectrum
    my @audibleMatches = @{match_audible($freq_hz)};
    if (@audibleMatches) {

        my $audibleDescription = $freq_formatted . ' is';
        $audibleDescription .= ' also' if $emMatch;
        $audibleDescription .= ' an audible frequency which can be produced by ';

        my @producers;
        push @producers, $$_{'produced_by'} for @audibleMatches;
        $audibleDescription .= WORDLIST(@producers, {cong => 'and'});
        $audibleDescription .= '.';

        $answer .= $audibleDescription;
        $html .= $audibleDescription;

        #Add a plot to the HTML
        #Basic plot parameters
        my $rangeMin = 10;
        my $rangeMax = 10000;

        #Set up the background panel
        # A 'track' is a row in the plot/categorical variable on the y axis
        (my $plot, my $transform) = generate_panel($rangeMin, $rangeMax, scalar @audibleMatches);

        #Add a track with a major range for each producer
        my $track = 0;
        foreach my $match (@audibleMatches) {
            ++$track;
            my $freqRangeMin = $$match{'min'};
            my $freqRangeMax = $$match{'max'};
            my $label = $$match{'produced_by'};
            $plot = add_major_range($plot, $transform, $freqRangeMin, $freqRangeMax, $label, $track);
        }

        #Add a marker for the query frequency
        $plot = add_marker($plot, $transform, $freq_hz, scalar @audibleMatches);

        #Generate the SVG
        $html .= $plot->xmlify;
    }

    return $answer, html => wrap_html($html) if $answer;
    return;
};

#Find match in the electromagnetic spectrum
sub match_electromagnetic {
    my $freq_hz = shift;
    foreach (@electromagnetic) {
        return $_ if ($$_{'min'} <= $freq_hz) && ($$_{'max'} >= $freq_hz);
    }
    return;
}

#Find matches in the audible spectrum
sub match_audible {
    my $freq_hz = shift;
    my @matches;
    foreach (@audible) {
        push @matches, $_ if ($$_{'min'} <= $freq_hz) && ($$_{'max'} >= $freq_hz);
    }
    return \@matches;
}

sub generate_panel {

    (my $rangeMin, my $rangeMax, my $tracks) = @_;

    #Width is dynamic, always expressed as percentage
    my $width = 100;

    #Height is fixed
    my $height = (25 * $tracks) + 45;

    #Padding
    my $leftGutter = 5;
    my $rightGutter = 5;

    my $svg = SVG->new(height => $height, class => 'zci-plot');

    #If the difference betweeen the range
    # minimum and maximum is two orders of
    # magnitude or greater, use a log10 scale
    my $log10 = int(log10($rangeMax)) - int(log10($rangeMin)) >= 2 ? 1 : 0;

    #Build a transformation function to map values to
    # x coordinates
    my $transform;
    if ($log10) {
        $transform = sub {
            my $value = shift;
            my $unit = ($width - $leftGutter - $rightGutter) / (log10($rangeMax) - log10($rangeMin));
            return $leftGutter + ((log10($value) - log10($rangeMin)) * $unit);
        };

    } else {
        $transform = sub {
            my $value = shift;
            my $unit = ($width - $leftGutter - $rightGutter) / ($rangeMax - $rangeMin);
            return $leftGutter + (($value - $rangeMin) * $unit);
        };
    }

    #Add panel background
    $svg->group(
        class => 'plot_panel',
    )->rect(
        width => ($width - $leftGutter - $rightGutter) . '%', 
        height => 25 * $tracks, 
        x => $leftGutter . '%',
        rx => 2,
        ry => 2
    );

    #Calculate x-axis tick locations
    my @ticks;
    # If we're using a log10 scale, put a tick at
    # each power of 10 between range min and max
    if ($log10) {
        @ticks = map { 10 ** $_ } int(log10($rangeMin)) .. int(log10($rangeMax));

        #If we're using a linear scale, put a tick at every
        # integer multiple at the order of magnitude of
        # range max 
    } else {
        my $order = 10 ** int(log10($rangeMax));
        @ticks = map { $_ * $order } int($rangeMin / $order) + 1 .. int($rangeMax / $order);
        unshift(@ticks, $rangeMin) unless $ticks[0] == $rangeMin;
        push(@ticks, $rangeMax) unless $ticks[-1] == $rangeMax;
    }

    #If there are more than 10 ticks, remove every
    # second tick until there are 10 or fewer
    while (scalar @ticks > 10) {
        @ticks = @ticks[grep !($_ % 2), 0..$#ticks];
    }

    #Draw ticks
    my $xAxis = $svg->group (
        id => 'x_axis',
    );
    foreach (@ticks) {

        my $x = $transform->($_);

        #Draw tick line
        my $tick = $xAxis->group();
        $tick->line(
            x1 => $x . '%',
            x2 => $x . '%',
            y1 => 25 * $tracks, 
            y2 => (25 * $tracks) + 4,
            class => 'x_axis_tick'
        );

        #Annotate tick
        my $text = $xAxis->text(
            dy => '1em', 
            x => $x . '%', 
            y => (25 * $tracks) + 4, 
            'text-anchor' => 'middle',
            class => 'x_axis_text'
        );
        if ($log10) {
            $text->tag('tspan', -cdata => '10');
            $text->tag(
                'tspan', 
                'baseline-shift' => 'super',
                dx => '-0.5em', #Bring superscript close to parent
                -cdata => log10($_),
                style => { 'font-size' => '0.5em' },
            );
        } else {
            $text->tag('tspan', -cdata => $_);
        }
    }

    #Add x-axis gridlines
    my $gridlines = $svg->group (
        class => 'x_axis_gridline',
    );
    foreach (@ticks) {
        my $x = $transform->($_);
        my $line = $gridlines->group();
        $line->line(
            x1 => $x . '%',
            x2 => $x . '%',
            y1 => 0, 
            y2 => 25 * $tracks
        );
    }

    #Add a label to the x-axis
    my $xAxisLabel = $xAxis->text(
        dy => '1em', 
        x => '50%', 
        y => (25 * $tracks) + 25, 
        'text-anchor' => 'middle',
        class => 'x_axis_label'
    );
    $xAxisLabel->tag('tspan', -cdata => 'Frequency (Hz)');

    return($svg, $transform);
}

#Add a minor range to a plot panel
sub add_minor_range {

    (my $svg, my $transform, my $rangeMin, my $rangeMax, my $track) = @_;

    #Add rectangle for range
    my $minorRange = $svg->group(id => 'minor_range_' . $track);
    my $minorRangeRect = $minorRange->group();
    $minorRangeRect->rect(
        class => 'minor_range',
        x => $transform->($rangeMin) . '%', 
        width => $transform->($rangeMax) - $transform->($rangeMin) . '%',
        y => (15 * ($track - 1)) + 5,
        height => 15,
        rx => 2,
        ry => 2
    ); 

    return $svg;
}

#Add a major frequency range to a plot panel
sub add_major_range {

    (my $svg, my $transform, my $rangeMin, my $rangeMax, my $label, my $track) = @_;

    #Add rectangle for range
    my $majorRange = $svg->group(id => 'major_range_' . $label);
    my $majorRangeRect = $majorRange->group();
    $majorRangeRect->rect(
        class => 'major_range',
        x => $transform->($rangeMin) . '%', 
        width => $transform->($rangeMax) - $transform->($rangeMin) . '%',
        y => (25 * ($track - 1)) + 5,
        height => 15,
        rx => 2,
        ry => 2
    ); 

    #Add label for range
    #Place the label on the side of the band with more space
    my $x;
    my $anchor;
    if ($transform->($rangeMin) > 100 - ($transform->($rangeMax))) {
        $x = $transform->($rangeMin) - 1;
        $anchor = 'end';
    } else {
        $x = $transform->($rangeMax) + 1;
        $anchor = 'start';
    }
    my $majorRangeLabel = $majorRange->group();
    my $majorRangeLabelText = $majorRangeLabel->text(
        x => $x . '%', 
        y => (25 * ($track - 1)) + 10, 
        dy => '0.5em',
        'text-anchor' => $anchor,
        class => 'major_range_label'
    );
    $majorRangeLabel->tag('tspan', -cdata => ucfirst($label));

    return $svg;
}

#Add a marker (vertical line) to a plot panel
sub add_marker {

    (my $svg, my $transform, my $markerValue, my $tracks) = @_;

    #Add marker
    $svg->group(
        class => 'marker'
    )->line(
        x1 => $transform->($markerValue) . '%', 
        x2 => $transform->($markerValue) . '%', 
        y1 => 3,
        y2 => (25 * $tracks) - 3,
    );

    return $svg;
}

#Wrap html
sub wrap_html {
    return append_css("<div class='zci--conversions text--primary'>$_[0]</div>");
}

#Get log10 of a number
sub log10 {
    my $n = shift;
    return 0 if $n == 0;
    return log($n)/log(10);
}

sub append_css {
    my $html = shift;
    return "<style type='text/css'>$css</style>$html";
}

1;
