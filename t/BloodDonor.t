#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "blood_donor";
zci is_cached   => 1;

sub build_structure
{
	my ($blood_type, $data, $keys) = @_;
	return {
            description => 'Returns available donors for a blood type',
			meta => {
				sourceName => 'Wikipedia',
				sourceUrl => 'https://en.wikipedia.org/wiki/Blood_type'
			},
            templates => {
                group => 'list',
                options => {
                    content => 'record'
                }
            },
            data => {
                title => "Donors for blood type $blood_type",
                record_data => $data,
                record_keys => $keys
            }
        };
}

ddg_goodie_test(
    ['DDG::Goodie::BloodDonor'],
    'donor A+' => test_zci("Ideal donor: A+\nOther donors: A+ or O+\nOnly if no Rh(+) found: A- or O-",
        structured_answer => build_structure("A+",{
				"Ideal donor" => "A+",
				"Other donors" => "A+ or O+",
				"Only if no Rh(+) found" => "A- or O-"
			},
			["Ideal donor", "Other donors", "Only if no Rh(+) found"]
		)
    ),
    'donors for A+' => test_zci("Ideal donor: A+\nOther donors: A+ or O+\nOnly if no Rh(+) found: A- or O-",
        structured_answer => build_structure("A+",{
				"Ideal donor" => "A+",
				"Other donors" => "A+ or O+",
				"Only if no Rh(+) found" => "A- or O-"
			},
			["Ideal donor", "Other donors", "Only if no Rh(+) found"]
		)
    ),
    'blood donor A+' => test_zci("Ideal donor: A+\nOther donors: A+ or O+\nOnly if no Rh(+) found: A- or O-",
        structured_answer => build_structure("A+",{
				"Ideal donor" => "A+",
				"Other donors" => "A+ or O+",
				"Only if no Rh(+) found" => "A- or O-"
			},
			["Ideal donor", "Other donors", "Only if no Rh(+) found"]
		)
    ),
    'blood donors for A+' => test_zci("Ideal donor: A+\nOther donors: A+ or O+\nOnly if no Rh(+) found: A- or O-",
        structured_answer => build_structure("A+",{
				"Ideal donor" => "A+",
				"Other donors" => "A+ or O+",
				"Only if no Rh(+) found" => "A- or O-"
			},
			["Ideal donor", "Other donors", "Only if no Rh(+) found"]
		)
    ),
    'donor o+' => test_zci("Ideal donor: O+\nOther donors: O+\nOnly if no Rh(+) found: O-",
        structured_answer => build_structure("O+",{
				"Ideal donor" => "O+",
				"Other donors" => "O+",
				"Only if no Rh(+) found" => "O-"
			},
			["Ideal donor", "Other donors", "Only if no Rh(+) found"]
		)
    ),
    'donor o+ve' => test_zci("Ideal donor: O+VE\nOther donors: O+ve\nOnly if no Rh(+) found: O-ve",
        structured_answer => build_structure("O+VE",{
				"Ideal donor" => "O+VE",
				"Other donors" => "O+ve",
				"Only if no Rh(+) found" => "O-ve"
			},
			["Ideal donor", "Other donors", "Only if no Rh(+) found"]
		)
    ),
);

done_testing;
