#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'plotter';
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
my @int_point = (
    'Graph of -63, 71',
    structured_answer => {
        data => {
            title    => 'Graph of Point',
            subtitle => '-63, 71',
            is_point => 1,
            is_line => 0,
            point_x => 37,
            point_y => 29,
            x_axis_start => -100,
            y_axis_start => -100,
            x_axis_end => 100,
            y_axis_end => 100
        },
        templates => {
            group => 'info',
            options => {
                content => "DDH.plotter.plane"
            }
        }
}
);
my @float_point = ('Graph of 11.9, -8.5',
structured_answer => {
    data => {
        title    => 'Graph of Point',
            subtitle => '11.9, -8.5',
            is_point => 1,
            is_line => 0,
            point_x => 111.9,
            point_y => 108.5,
            x_axis_start => -100,
            y_axis_start => -100,
            x_axis_end => 100,
            y_axis_end => 100
    },
    templates => {
                group => 'info',
                options => {
                    content => "DDH.plotter.plane"
            }
    }
}
);
my @adjust_point = ('Graph of 123.45, 0.6789',
structured_answer => {
    data => {
        title    => 'Graph of Point',
            subtitle => '123.45, 0.6789',
            is_point => 1,
            is_line => 0,
            point_x => 112.345,
            point_y => 32.11,
            x_axis_start => -1000,
            y_axis_start => -1,
            x_axis_end => 1000,
            y_axis_end => 1
    },
    templates => {
                group => 'info',
                options => {
                    content => "DDH.plotter.plane"
            }
    }
}
);

my @int_line = ('Graph of y = 7 x - 9',
structured_answer => {
    data => {
                    title    => 'Graph of Line',
                    subtitle => 'y = 7 x - 9',
                    is_point => 0,
                    is_line => 1,
                    x1 => 0,
                    y1 => 170.9,
                    x2 => 200,
                    y2 => 30.9,
                    x_axis_start => -100,
                    y_axis_start => -1000,
                    x_axis_end => 100,
                    y_axis_end => 1000
                },

                templates => {
                    group => 'info',
                    options => {
                        content => "DDH.plotter.plane"
                    }
                }
}
);

my @float_line = ('Graph of y = 7.3 x + 9.4',
structured_answer => {
    data => {
                    title    => 'Graph of Line',
                    subtitle => 'y = 7.3 x + 9.4',
                    is_point => 0,
                    is_line => 1,
                    x1 => 0,
                    y1 => 172.06,
                    x2 => 200,
                    y2 => 26.06,
                    x_axis_start => -100,
                    y_axis_start => -1000,
                    x_axis_end => 100,
                    y_axis_end => 1000
                },

                templates => {
                    group => 'info',
                    options => {
                        content => "DDH.plotter.plane"
                    }
                }
}
);

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::Plotter )],
    'plot point -63 71' => test_zci (@int_point),
    'graph point -63, 71' => test_zci (@int_point),
    'plot point 11.9, -8.5' => test_zci (@float_point),
    'point 11.9 -8.5' => test_zci (@float_point),
    'point 123.45, 0.6789' => test_zci (@adjust_point),
    'line y = 7x - 9' => test_zci (@int_line),
    'line y = 7.3x + 9.4' => test_zci (@float_line),
    'great plot point' => undef,
    'plot point 6' => undef,
    '8, 9' => undef
);

done_testing;
