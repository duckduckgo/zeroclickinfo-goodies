#!/usr/bin/env perl

use strict;
use warnings;

use Test::MockTime qw( :all );
use Test::Most;

use DDG::Test::Location;

subtest 'NumberStyler' => sub {

    { package NumberRoleTester; use Moo; with 'DDG::GoodieRole::NumberStyler'; 1; }

    subtest 'Initialization' => sub {
        new_ok('NumberRoleTester', [], 'Applied to a class');
        isa_ok(NumberRoleTester::number_style_regex(), 'Regexp', 'number_style_regex()');
    };

    subtest 'Valid numbers' => sub {

        my @valid_test_cases = (
            [['0,013'] => 'euro'],
            [['4,431',      '4.321'] => 'perl'],
            [['4,431',      '4,32']  => 'euro'],
            [['4534,345.0', '1']     => 'perl'],    # Unenforced commas.
            [['4,431',     '4,32', '5,42']       => 'euro'],
            [['4,431',     '4.32', '5.42']       => 'perl'],
            [['4_431_123', '4 32', '99.999 999'] => 'perl'],
        );

        foreach my $tc (@valid_test_cases) {
            my @numbers           = @{$tc->[0]};
            my $expected_style_id = $tc->[1];
            is(NumberRoleTester::number_style_for(@numbers)->id,
                $expected_style_id, '"' . join(' ', @numbers) . '" yields a style of ' . $expected_style_id);
        }
    };

    subtest 'Invalid numbers' => sub {
        my @invalid_test_cases = (
            [['5234534.34.54', '1'] => 'has a mal-formed number'],
            [['4,431',     '4,32',     '4.32']       => 'is confusingly ambiguous'],
            [['4,431',     '4.32.10',  '5.42']       => 'is hard to figure'],
            [['4,431',     '4,32,100', '5.42']       => 'has a mal-formed number'],
            [['4,431',     '4,32,100', '5,42']       => 'is too crazy to work out'],
            [['4_431_123', "4\t32",    '99.999 999'] => 'no tabs in numbers'],
        );

        foreach my $tc (@invalid_test_cases) {
            my @numbers = @{$tc->[0]};
            my $why_not = $tc->[1];
            is(NumberRoleTester::number_style_for(@numbers), undef, '"' . join(' ', @numbers) . '" fails because it ' . $why_not);
        }
    };

};

subtest 'ImageLoader' => sub {

    subtest 'object with no share' => sub {
        # We have to wrap the function in a method in order to get the call-stack correct.
        { package ImgRoleTester; use Moo; with 'DDG::GoodieRole::ImageLoader'; sub img_wrap { shift; goodie_img_tag(@_); } 1; }

        my $no_share;
        subtest 'Initialization' => sub {
            $no_share = new_ok('ImgRoleTester', [], 'Applied to class');
        };

        subtest 'non-share enabled object attempts' => sub {
            my %no_deaths = (
                'undef'             => undef,
                'array ref'         => [],
                'killer code ref'   => sub { die },
                'with itself'       => $no_share,
                'empty hash ref'    => +{},
                'nonsense hash ref' => {ding => 'dong'},
                'proper'            => {filename => 'hi.jpg'},
            );
            foreach my $desc (sort keys %no_deaths) {
                lives_ok { $no_share->goodie_img_tag($no_deaths{$desc}) } $desc . ': does not die.';
            }
        };
    };
    subtest 'object with a share' => sub {
        our $b64_gif =
          'R0lGODlhEAAOALMAAOazToeHh0tLS/7LZv/0jvb29t/f3//Ub//ge8WSLf/rhf/3kdbW1mxsbP//mf///yH5BAAAAAAALAAAAAAQAA4AAARe8L1Ekyky67QZ1hLnjM5UUde0ECwLJoExKcppV0aCcGCmTIHEIUEqjgaORCMxIC6e0CcguWw6aFjsVMkkIr7g77ZKPJjPZqIyd7sJAgVGoEGv2xsBxqNgYPj/gAwXEQA7';
        our $final_src = 'src="data:image/gif;base64,' . $b64_gif;
        {

            package DDG::Goodie::ImgShareTester;
            use Moo;
            use HTML::Entities;
            use Path::Class;    # Hopefully the real share stays implemented this way.
            use MIME::Base64;
            with 'DDG::GoodieRole::ImageLoader';
            our $tmp_dir = Path::Class::tempdir(CLEANUP => 1);
            our $tmp_file = file(($tmp_dir->tempfile(TEMPLATE => 'img_XXXXXX', SUFFIX => '.gif'))[1]);
            # Always return the same file for our purposes here.
            sub share     { $tmp_file }
            sub html_enc  { encode_entities(@_) }                                             # Deal with silly symbol table twiddling.
            sub fill_temp { $tmp_file->spew(iomode => '>:bytes', decode_base64($b64_gif)) }
            sub kill_temp { undef $tmp_file }
            sub img_wrap { shift; goodie_img_tag(@_); }
            1;
        }

        my $with_share;
        subtest 'Initialization' => sub {
            $with_share = new_ok('DDG::Goodie::ImgShareTester', [], 'Applied to class');
        };

        subtest 'tag creation' => sub {
            my $filename = $with_share->share()->stringify;
            my $tag_content;
            lives_ok { $tag_content = $with_share->img_wrap({filename => $filename}) } 'Empty file does not die';
            is($tag_content, '', '... but returns empty tag.');
            $with_share->fill_temp;
            lives_ok { $tag_content = $with_share->img_wrap({filename => $filename}) } 'Newly filled file does not die';
            like($tag_content, qr/$final_src/, '... contains proper data');
            lives_ok { $tag_content = $with_share->img_wrap({filename => $filename, alt => 'Yo!'}) } 'With alt';
            like($tag_content, qr/$final_src/,  '... contains proper data');
            like($tag_content, qr/alt=\"Yo!\"/, '... and proper alt attribute');
            lives_ok { $tag_content = $with_share->img_wrap({filename => $filename, alt => 'Yo!', height => 12}) } 'Plus height';
            like($tag_content, qr/$final_src/,  '... contains proper data');
            like($tag_content, qr/alt="Yo!"/,   '... and proper alt attribute');
            like($tag_content, qr/height="12"/, '... and proper height attribute');
            lives_ok { $tag_content = $with_share->img_wrap({filename => $filename, alt => 'Yo!', height => 12, width => 10}) } 'Plus width';
            like($tag_content, qr/$final_src/,  '... contains proper data');
            like($tag_content, qr/alt="Yo!"/,   '... and proper alt attribute');
            like($tag_content, qr/height="12"/, '... and proper height attribute');
            like($tag_content, qr/width="10"/,  '... and proper width attribute');
            lives_ok { $tag_content = $with_share->img_wrap({filename => $filename, alt => 'hello"there!', height => 12, width => 10, class => 'smooth' }); } 'Plus class';
            like($tag_content, qr/$final_src/,              '... contains proper data');
            like($tag_content, qr/alt="hello&quot;there!"/, '... and proper alt attribute');
            like($tag_content, qr/height="12"/,             '... and proper height attribute');
            like($tag_content, qr/width="10"/,              '... and proper width attribute');
            like($tag_content, qr/class="smooth"/,          '... and proper class attribute');
            lives_ok { $tag_content = $with_share->img_wrap({filename => $filename, atl => 'Yo!', height => 12, width => 10, class => 'smooth'}) }
            'Any mispelled does not die';
            is($tag_content, '', '... but yields an empty tag');
            $with_share->kill_temp;
            lives_ok { $tag_content = $with_share->img_wrap({filename => $filename, alt => 'Yo!', height => 12, width => 10, class => 'smooth'}) }
            'File disappeared does not die';
            is($tag_content, '', '... but yields an empty tag');
        };
    };
};

done_testing;
