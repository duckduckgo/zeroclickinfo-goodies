package DDG::Goodie::FrequencySpectrum;
# ABSTRACT: describe the nature of various wave frequencies.

use strict;
use SVG;
use DDG::Goodie;
use Lingua::EN::Inflect qw(WORDLIST);
use Math::SigFigs qw(:all);

zci answer_type => "frequency_spectrum";
zci is_cached   => 1;

#Javascript to dynamically resize and/or hide elements
my $dynamicwidths = "";

#Regex to match a valid query
# Used for trigger and later for parsing
my $frequencySpectrumQR = qr/
    ^(?<quantity>[\d,]+(\.\d+)?)                #Number, maybe with commas, maybe a decimal
    \s?                                         #Optional space between number and unit
    (                                           #Unit can be frequency (Hz) or wavelength (nm)
        (?<factor>k|kilo|m|mega|g|giga|t|tera)? #Optional SI prefix for Hz
        (?:hz|hertz)                            #Hz
    |
        (?<wavelength>nanom(et(er|re)s?)?|nm)   #nm
    )
$/ix;

triggers query_raw => qr/$frequencySpectrumQR/i;

#The distance light travels in a vacuum in one second,
# expressed in nanometres
my $nanometreLightSecond = 2.99792458 * (10 ** 17);

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
# Hardcoded to control graphical layout
my %emSpectrum = (
    'radio' => {
        min => 0, 
        max => 3000000000000,
        track => 1
    },
    'infrared' => {
        min => 3000000000000,
        max => 400000000000000,
        track => 2
    },
    'visible light' => {
        min => 400000000000000, 
        max => 800000000000000,
        track => 3
    },
    'ultraviolet' => {
        min => 749500000000000, 
        max => 30000000000000000,
        track => 4
    },
    'x-ray' => {
        min => 30000000000000000, 
        max => 30000000000000000000,
        track => 5
    },
    'gamma' => {
        min => 30000000000000000000, 
        max => 3000000000000000000000000,
        track => 6
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

handle query => sub {

    #Query components
    (my $quantity = $+{quantity}) =~ s/,//g;
    my $factor = $+{factor} || 0;
    my $wavelength = $+{wavelength} || 0;

    #Answer components
    my $freq_hz;
    my $freq_formatted;
    my $answer;
    my $html;
    my $plot;

    #If wavelength provided, convert to frequency in hz
    if ($wavelength) {
        $wavelength = $quantity;
        $freq_hz = $nanometreLightSecond / $wavelength;
        my $freq_thz = FormatSigFigs($freq_hz / $factors{'t'}{'multiplier'}, 5);
        $freq_formatted = "$freq_thz THz (wavelength $quantity nm)";

    #If frequency provided, convert to hz
    } else {
        my $prefix = $factor ? lc substr($factor, 0, 1) : 0;
        my $factor = $factor ? $factors{$prefix}{'multiplier'} : 1;
        $freq_hz = $quantity * $factor;
        my $hz_formatted = $prefix ? $factors{$prefix}{'cased'} . 'Hz' : 'Hz';
        $freq_formatted = $quantity . ' ' . $hz_formatted;
    }

    #Look for a match in the electromagnetic spectrum
    my $emMatch = match_electromagnetic($freq_hz);
    if ($emMatch) {

        #Don't show result for wavelengths outside the
        # visual spectrum
        return if $wavelength and not $emMatch->{subspectrum} eq 'visible light';

        my $emDescription = $freq_formatted . ' is a ' . $emMatch->{subspectrum} . ' frequency' . $emMatch->{description} . '.';

        $answer .= $emDescription;
        $html .= $emDescription;

        #Add a plot to the html
        #Prepare parameters
        my $rangeMin = 0;
        my $rangeMax = 10000000000000000000000000;
        my $bandMin = $emMatch->{min};
        my $bandMax = $emMatch->{max};
        my $subspectrum = $emMatch->{subspectrum};

        #Set up the plot panel
        $plot = generate_plot($rangeMin, $rangeMax, scalar keys %emSpectrum);

        #Add a major range for each subspectrum (e.g. radio or UV)
        foreach (sort {$emSpectrum{$a}{'track'} <=> $emSpectrum{$b}{'track'} } keys %emSpectrum) {
            $plot = add_major_range($plot, $emSpectrum{$_}{'min'}, $emSpectrum{$_}{'max'}, $_, $emSpectrum{$_}{'track'});
        }

        #Add a minor range for the band (unless the band is the subspectrum)
        if (! ($emSpectrum{$subspectrum}{'min'} == $bandMin && $emSpectrum{$subspectrum}{'max'} == $bandMax)) {
          # NOTE: Skipping this per @wtrsld's comp, but leaving code in 
          # until design is finalised
          #$plot = add_minor_range($plot, $bandMin, $bandMax, $emSpectrum{$subspectrum}{'track'});
        }

        #Add a marker for the query frequency
        # Colour the marker if frequency is in visible spectrum
        my $markerRGB;
        if ($emMatch->{subspectrum} eq 'visible light') {
            $markerRGB = frequency_to_RGB($freq_hz);
        } else {
            $markerRGB = '#F7614F';
        }
        $plot = add_marker($plot, $freq_hz, $markerRGB, $freq_formatted);

        #Generate the SVG
        $html .= $plot->{svg}->xmlify;

    }

    #Look for matches in the audible spectrum
    # NOTE: Audible frequency results are currently being suppressed,
    # as the resulting IA is too long. This will be revisited when
    # better stying is available.
    #my @audibleMatches = @{match_audible($freq_hz)};
    my @audibleMatches = ();
    if (@audibleMatches) {

        my $audibleDescription = $freq_formatted . ' is';
        $audibleDescription .= ' also' if $emMatch;
        $audibleDescription .= ' an audible frequency which can be produced by ';

        my @producers;
        push @producers, $_->{produced_by} for @audibleMatches;
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
        (my $plot, my $transform) = generate_plot($rangeMin, $rangeMax, scalar @audibleMatches);

        #Add a track with a major range for each producer
        my $track = 0;
        foreach my $match (@audibleMatches) {
            ++$track;
            my $freqRangeMin = $match->{min};
            my $freqRangeMax = $match->{max};
            my $label = $match->{produced_by};
            $plot = add_major_range($plot, $transform, $freqRangeMin, $freqRangeMax, $label, $track);
        }

        #Add a marker for the query frequency
        $plot = add_marker($plot, $freq_hz, scalar @audibleMatches, '#000', $freq_formatted);

        #Generate the SVG
        $html .= $plot->xmlify;
    }
    
    $plot->{svg} = "";
    $plot->{transform} = ""; 

    my @temp = $plot;
    return "$answer", #html => wrap_html($html) if $answer;
    structured_answer => {
        id => 'frequency_spectrum',
        name => 'Answer',
        data => {
            title => $answer,
            plot => $plot,
        },
        templates => {
            group => 'text',
            item => 0,
            options => {
                content => 'DDH.frequency_spectrum.content'
            }
        }
    };
    return;
};

#Find match in the electromagnetic spectrum
sub match_electromagnetic {
    my $freq_hz = shift;
    foreach (@electromagnetic) {
        return $_ if ($_->{min} <= $freq_hz) && ($_->{max} >= $freq_hz);
    }
    return;
}

#Find matches in the audible spectrum
sub match_audible {
    my $freq_hz = shift;
    my @matches;
    foreach (@audible) {
        push @matches, $_ if ($_->{min} <= $freq_hz) && ($_->{max} >= $freq_hz);
    }
    return \@matches;
}

sub generate_plot {

    #Set up plot parameters
    my $plot = {};

    #Range (passed)
    $plot->{rangeMin} = $_[0];
    $plot->{rangeMax} = $_[1];

    #Number of tracks (passed)
    $plot->{tracks} = $_[2];

    #Height of a single track
    $plot->{trackHeight} = 25;

    #Height of a band
    $plot->{bandHeight} = 18;

    #Padding between edge of band and edge of track
    $plot->{bandGutter} = ($plot->{trackHeight} - $plot->{bandHeight}) / 2;

    #Total height of panel (area where data is plotted/Cartesian plane)
    $plot->{panelHeight} = $plot->{tracks} * $plot->{trackHeight};

    #Padding
    $plot->{leftGutter} = 20;
    $plot->{rightGutter} = 5;
    $plot->{bottomGutter} = 50;
    $plot->{topGutter} = 30;

    #Plot width is dynamic, always expressed as percentage
    $plot->{width} = 100;

    #Plot height is fixed, and depends on number of tracks (passed)
    # and the track height
    $plot->{height} = $plot->{panelHeight} + $plot->{bottomGutter} + $plot->{topGutter};

    #Initialise SVG
    $plot->{svg} = SVG->new(height => $plot->{height}, class => 'zci--plot');

    #If the difference betweeen the range
    # minimum and maximum is two orders of
    # magnitude or greater, use a log10 scale
    my $log10 = int(log10($plot->{rangeMax})) - int(log10($plot->{rangeMin})) >= 2 ? 1 : 0;

    #Build a transformation function to map values to
    # x coordinates
    my $transform;
    if ($log10) {
        $plot->{transform} = sub {
            my $value = shift;
            my $unit = ($plot->{width} - $plot->{leftGutter} - $plot->{rightGutter}) / (log10($plot->{rangeMax}) - log10($plot->{rangeMin}));
            return $plot->{leftGutter} + ((log10($value) - log10($plot->{rangeMin})) * $unit);
        };

    } else {
        $plot->{transform} = sub {
            my $value = shift;
            my $unit = ($plot->{width} - $plot->{leftGutter} - $plot->{rightGutter}) / ($plot->{rangeMax} - $plot->{rangeMin});
            return $plot->{leftGutter} + (($value - $plot->{rangeMin}) * $unit);
        };
    }

    #Add plot background
#    $plot->{svg}->group(
#        class => 'plot_background',
#    )->rect(
#        width => '100%',
#        height => $plot->{height}, 
#        x => 0,
#        y => 0
#    );

    #Add panel background
#    $plot->{svg}->group(
#        class => 'plot_panel',
#    )->rect(
#        width => ($plot->{width} - $plot->{leftGutter} - $plot->{rightGutter}) . '%', 
#        height => $plot->{panelHeight}, 
#        x => $plot->{leftGutter} . '%',
#        y => $plot->{topGutter},
#    );
    $plot->{plot_panel_width} = ($plot->{width} - $plot->{leftGutter} - $plot->{rightGutter});

    #Calculate x-axis tick locations
    my @ticks;
    # If we're using a log10 scale, put a tick at
    # each power of 10 between range min and max
    if ($log10) {
        @ticks = map { 10 ** $_ } int(log10($plot->{rangeMin})) .. int(log10($plot->{rangeMax}));

        #If we're using a linear scale, put a tick at every
        # integer multiple at the order of magnitude of
        # range max 
    } else {
        my $order = 10 ** int(log10($plot->{rangeMax}));
        @ticks = map { $_ * $order } int($plot->{rangeMin} / $order) + 1 .. int($plot->{rangeMax} / $order);
        unshift(@ticks, $plot->{rangeMin}) unless $ticks[0] == $plot->{rangeMin};
        push(@ticks, $plot->{rangeMax}) unless $ticks[-1] == $plot->{rangeMax};
    }

    #If there are more than 10 ticks, remove every
    # second tick until there are 10 or fewer
    while (scalar @ticks > 10) {
        @ticks = @ticks[grep !($_ % 2), 0..$#ticks];
    }

    #Draw ticks
#    my $xAxis = $plot->{svg}->group (
#        id => 'x_axis',
#    );
#    foreach (@ticks) {

#        my $x = $plot->{transform}->($_);

        #Draw tick line
        # NOTE: Currently skipping this per wtrsld's redesign
        #my $tick = $xAxis->group();
        #$tick->line(
        #x1 => $x . '%',
        #x2 => $x . '%',
        #y1 => $plot->{panelHeight} + $plot->{topGutter}, 
        #y2 => $plot->{panelHeight} + $plot->{topGutter} + 4, 
        #class => 'x_axis_tick'
        #);

        #Annotate tick
#        my $text = $xAxis->text(
#            dy => '1em', 
#            x => $x . '%', 
#            y => $plot->{panelHeight} + $plot->{topGutter} + 4, 
#            'text-anchor' => 'middle',
#            class => 'x_axis_text'
#        );
#        if ($log10 && $_ > 10) {
#            $text->tag('tspan', -cdata => '10');
#            $text->tag(
#                'tspan', 
#                'baseline-shift' => 'super',
#                dy => '-0.2em', #Superscripts need an extra nudge
#                dx => '-0.5em', #Bring superscript close to parent
#                -cdata => log10($_),
#                style => { 'font-size' => '0.5em' },
#            );
#        } else {
#            $text->tag('tspan', -cdata => $_);
#        }
#    }
    my @x_axis;    
    foreach (@ticks) {
        my $tspan_cdata;
        if ($log10 && $_ > 10) {
            $tspan_cdata = log10($_);
        }
        my $x_axis = {
            x => $plot->{transform}->($_),
            y => $plot->{panelHeight} + $plot->{topGutter} + 4,
            tspan_cdata => $tspan_cdata,
        };
        push @x_axis, $x_axis;
    }
    $plot->{x_axis} = \@x_axis;
    
    #Add x-axis gridlines
    # NOTE: Currently skipping this per wtrsld's redesign
    #my $gridlines = $plot->{svg}->group (
    #class => 'x_axis_gridline',
    #);
    #foreach (@ticks) {
    #my $x = $plot->{transform}->($_);
    #my $line = $gridlines->group();
    #$line->line(
    #x1 => $x . '%',
    #x2 => $x . '%',
    #y1 => $plot->{topGutter}, 
    #y2 => $plot->{panelHeight} + $plot->{topGutter}
    #);
    #}

    #Add a label to the x-axis
#    my $xAxisLabel = $xAxis->text(
#        dy => '1em', 
#        x => '50%',
#        y => $plot->{panelHeight} + $plot->{topGutter} + 25, 
#        'text-anchor' => 'middle',
#        class => 'x_axis_label'
#    );
#    $xAxisLabel->tag('tspan', -cdata => 'Frequency (Hz)');
    $plot->{axis_label_y} = $plot->{panelHeight} + $plot->{topGutter} + 25;     

    #Add axis lines
#    my $axislines = $plot->{svg}->group (
#        class => 'axis_line',
#    );
#    my $xaxisline = $axislines->group();
#    $xaxisline->line(
#        x1 => $plot->{transform}->(0) . '%',
#        x2 => $plot->{transform}->($plot->{rangeMax}) . '%',
#        y1 => $plot->{panelHeight} + $plot->{topGutter}, 
#        y2 => $plot->{panelHeight} + $plot->{topGutter}
#    );
#    my $yaxisline = $axislines->group();
#    $yaxisline->line(
#        x1 => $plot->{transform}->(0) . '%',
#        x2 => $plot->{transform}->(0) . '%',
#        y1 => $plot->{topGutter}, 
#        y2 => $plot->{topGutter} + $plot->{panelHeight}
#    );
    $plot->{x_axis_line} = {
        x1 => $plot->{transform}->(0),
        x2 => $plot->{transform}->($plot->{rangeMax}),
        y1 => $plot->{panelHeight} + $plot->{topGutter}, 
        y2 => $plot->{panelHeight} + $plot->{topGutter}    
    };
    $plot->{y_axis_line} = {
        x1 => $plot->{transform}->(0),
        x2 => $plot->{transform}->(0),
        y1 => $plot->{topGutter}, 
        y2 => $plot->{topGutter} + $plot->{panelHeight}    
    };
    
    return($plot);
}

#Add a minor range to a plot panel
sub add_minor_range {

    (my $plot, my $rangeMin, my $rangeMax, my $track) = @_;

    #Add rectangle for range
    my $minorRange = $plot->{svg}->group(id => 'minor_range_' . $track);
    my $minorRangeRect = $minorRange->group();
    $minorRangeRect->rect(
        class => 'minor_range',
        x => $plot->{transform}->($rangeMin) . '%', 
        width => $plot->{transform}->($rangeMax) - $plot->{transform}->($rangeMin) . '%',
        y => ($plot->{trackHeight} * ($track - 1)) + $plot->{bandGutter} + $plot->{topGutter},
        height => $plot->{bandHeight},
    ); 

    return $plot;
}

#Add a major frequency range to a plot panel
sub add_major_range {

    (my $plot, my $rangeMin, my $rangeMax, my $label, my $track) = @_;

    #Add rectangle for range
    my $majorRange = $plot->{svg}->group(id => 'major_range_' . $label);
    my $majorRangeRect = $majorRange->group();
    $majorRangeRect->rect(
        class => 'major_range',
        x => $plot->{transform}->($rangeMin) . '%', 
        width => $plot->{transform}->($rangeMax) - $plot->{transform}->($rangeMin) . '%',
        y => ($plot->{trackHeight} * ($track - 1)) + $plot->{bandGutter} + $plot->{topGutter},
        height => $plot->{bandHeight},
    ); 

    #Add label for range on the y-axis
    my $x;
    my $anchor;
    $x = $plot->{leftGutter} - 1;
    $anchor = 'end';
    my $majorRangeLabel = $majorRange->group();
    my $majorRangeLabelText = $majorRangeLabel->text(
        x => $x . '%', 
        y => ($plot->{trackHeight} * ($track - 1)) + (2 * $plot->{bandGutter}) + $plot->{topGutter}, 
        dy => ($plot->{trackHeight} / 2) - 5,
        'text-anchor' => $anchor,
        class => 'major_range_label'
    );
    $majorRangeLabelText->tag('tspan', -cdata => ucfirst($label));

    return $plot;
}

#Add a marker (vertical line) to a plot panel
sub add_marker {

    (my $plot, my $markerValue, my $RGB, my $freq_formatted) = @_;

    #Add marker rect
    my $markerWidth = 1; #This is dynamically resized by $dynamicwidths
    my $markerHeight = 14;
    my $markerGutter = ($plot->{topGutter} - $markerHeight - 1) / 2;
#    $plot->{svg}->group(
#        class => 'marker_tag',
#    )->rect(
#        id => 'marker_tag',
#        width => $markerWidth,
#        height => $markerHeight,
#        x => $plot->{transform}->($markerValue) - ($markerWidth / 2) . '%',
#        y => $plot->{topGutter} - $markerGutter - $markerHeight + 1, #Extra pixel to account for plot border
#        style => { 'fill' => $RGB }
#    );

    #Add marker label
#    my $markerLabel = $plot->{svg}->group();
#    my $markerLabelText = $markerLabel->text(
#        x => $plot->{transform}->($markerValue) . '%',
#        y => $plot->{topGutter} - $markerGutter - ($markerHeight / 2) + 4,
#        'text-anchor' => 'middle',
#        class => 'marker_label'
#    );
#    $markerLabelText->tag('tspan', id => 'marker_label', -cdata => ucfirst($freq_formatted));

    #Add marker line
#    $plot->{svg}->group(
#        class => 'marker'
#    )->line(
#        id => 'marker',
#        x1 => $plot->{transform}->($markerValue) . '%', 
#        x2 => $plot->{transform}->($markerValue) . '%', 
#        y1 => $plot->{topGutter} - $markerGutter,
#        y2 => $plot->{topGutter} + $plot->{panelHeight},
#        style => { 'stroke' => $RGB },
#    );
    $plot->{marker_line} = {
        x1 => $plot->{transform}->($markerValue), 
        x2 => $plot->{transform}->($markerValue), 
        y1 => $plot->{topGutter} - $markerGutter,
        y2 => $plot->{topGutter} + $plot->{panelHeight},
        color => $RGB,    
    };

    return $plot;
}

#Wrap html
#sub wrap_html {
#    return <<EOF;
#<!--[if gte IE 9]><!-->        
#<div class='zci--conversions text--primary'>$_[0]</div>
#<![endif]-->
#$dynamicwidths
#EOF
#}

#Get log10 of a number
sub log10 {
    my $n = shift;
    return 0 if $n == 0;
    return log($n)/log(10);
}

#Convert a visible light frequency in Hz to RGB
# Adapted from http://www.efg2.com/Lab/ScienceAndEngineering/Spectra.htm
sub frequency_to_RGB {

    my $frequency = shift;
    my $wavelength = $nanometreLightSecond / $frequency;
    my @RGB;

    if (($wavelength >= 380) && ($wavelength < 440)) {
        @RGB = (
            -($wavelength - 440) / (440 - 380),
            0,
            1,
        );
    } elsif (($wavelength >= 440) && ($wavelength < 490)) {
        @RGB = (
            0,
            ($wavelength - 440) / (490 - 440),
            1,
        );
    } elsif (($wavelength >= 490) && ($wavelength < 510)) {
        @RGB = (
            0,
            1,
            -($wavelength - 510) / (510 - 490),
        );
    } elsif (($wavelength >= 510) && ($wavelength < 580)) {
        @RGB = (
            ($wavelength - 510) / (580 - 510),
            1,
            0,
        );
    } elsif (($wavelength >= 580) && ($wavelength < 645)) {
        @RGB = (
            1,
            -($wavelength - 645) / (645 - 580),
            0,
        );
    } elsif (($wavelength >= 645) && ($wavelength <= 780)) {
        @RGB = (1, 0, 0);
    } else {
        @RGB = (0, 0, 0);
    }

    #Convert to hex
    return '#' . join('', map { sprintf "%02x", $_ * 255 } @RGB);
}

1;
