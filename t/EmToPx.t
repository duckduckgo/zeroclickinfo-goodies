use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'conversion';
zci is_cached   => 1;

sub build_structured_answer {
    my ($result, $size, $type, $fontsize) = @_;
    my $target = $type eq 'em' ? 'px' : 'em';
    return $result,
        structured_answer => {
            data => {
                title    => $result,
                subtitle => "Convert $size $type to $target with a font-size of ${fontsize}px",
            },
            templates => {
                group  => 'text',
                moreAt => 0,
            },
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::EmToPx )],
    # Simple queries
    '10 px to em'   => build_test('0.625em', '10', 'px', '16'),
    '1em to px'     => build_test('16px', '1', 'em', '16'),
    '10 px to 10em' => undef,
    # Font size
    '12.2 px in em assuming a 12.2px font size' => build_test('1em', '12.2', 'px', '12.2'),
    '12.2 px in em assuming a 12.2 font size'   => build_test('1em', '12.2', 'px', '12.2'),
    '15px to em font-size 11'                   => build_test('1.364em', '15', 'px', '11'),
    # Pixel size
    '7em to px base pixel size 10'                    => build_test('70px', '7', 'em', '10'),
    '3px to em with a base pixel size of 17'          => build_test('0.176em', '3', 'px', '17'),
    'what is 9px in em with a base pixel size of 24?' => build_test('0.375em', '9', 'px', '24'),
    '11px to em at base-pixel size 23px'              => build_test('0.478em', '11', 'px', '23'),
);

done_testing;
