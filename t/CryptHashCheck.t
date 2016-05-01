#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'crypthashcheck';
zci is_cached => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::CryptHashCheck
    )],
    'hash 5c0847eccfaeabf4a0207d42a2986992' => test_zci(
        'This is a 128 bit MD5 cryptographic hash.',
        structured_answer => {
            data => {
                title => "This is a 128 bit MD5 cryptographic hash.",
            },
            meta => {
                sourceName => "Wikipedia MD5",
                sourceUrl => "https://en.wikipedia.org/wiki/MD5"
            },
            templates => {
                group => 'text',
                options => {
                    moreAt => 1,
                    moreText => undef
                }
            }
        }    
    ),
    'hash ecaceaca62d6c47190ed6c6f94a298f28a46450fda0bd1ec8fc64bc4a7a8cd436791a35f3c4e339b7ae480c1b751f1c1' => test_zci(
        'This is a 384 bit SHA-2/SHA-3 cryptographic hash.',
        structured_answer => {
            data => {
                title => "This is a 384 bit SHA-2/SHA-3 cryptographic hash.",
            },
            meta => {
                sourceName => "Wikipedia SHA-2",
                sourceUrl => "https://en.wikipedia.org/wiki/SHA-2"
            },
            templates => {
                group => 'text',
                options => {
                    moreAt => 1,
                    moreText =>  [ 
                        {                                                                                                                                  
                            href => "https://en.wikipedia.org/wiki/SHA-3",                                                                                         
                            text => "SHA-3"                                                                                                                        
                        } 
                    ]
                }
            }
        }                
    ),
    'hash b1d7eb51d4372c505446abca04835a101275e498' => test_zci(
        'This is a 160 bit SHA-1 cryptographic hash.',
        structured_answer => {
            data => {
                title => "This is a 160 bit SHA-1 cryptographic hash.",
            },
            meta => {
                sourceName => "Wikipedia SHA-1",
                sourceUrl => "https://en.wikipedia.org/wiki/SHA-1"
            },
            templates => {
                group => 'text',
                options => {
                    moreAt => 1,
                    moreText => undef
                }
            }
        }                
    ),
    'hash 6286e0a5cbc030f7b2d105f594ae0afb9105c92175c6b07ff454734c23cd0bddfed77639fe59b68a70b8c78af27657f611cbe89c27f7a47b978fa9449808c19f' => test_zci(
        'This is a 512 bit SHA-2/SHA-3 cryptographic hash.',
        structured_answer => {
            data => {
                title => "This is a 512 bit SHA-2/SHA-3 cryptographic hash.",
            },
            meta => {
                sourceName => "Wikipedia SHA-2",
                sourceUrl => "https://en.wikipedia.org/wiki/SHA-2"
            },
            templates => {
                group => 'text',
                options => {
                    moreAt => 1,
                    moreText =>  [ 
                        {                                                                                                                                  
                            href => "https://en.wikipedia.org/wiki/SHA-3",                                                                                         
                            text => "SHA-3"                                                                                                                        
                        } 
                    ]
                }
            }
        }                
    ),
    'hash a8a35ab9036388fd42fe1d73d93ede7ec604044ba4753259fafbf718' => test_zci(
        'This is a 224 bit SHA-2/SHA-3 cryptographic hash.',
        structured_answer => {
            data => {
                title => "This is a 224 bit SHA-2/SHA-3 cryptographic hash.",
            },
            meta => {
                sourceName => "Wikipedia SHA-2",
                sourceUrl => "https://en.wikipedia.org/wiki/SHA-2"
            },
            templates => {
                group => 'text',
                options => {
                    moreAt => 1,
                    moreText =>  [ 
                        {                                                                                                                                  
                            href => "https://en.wikipedia.org/wiki/SHA-3",                                                                                         
                            text => "SHA-3"                                                                                                                        
                        } 
                    ]
                }
            }
        }
    ),
    'hash 624d420035fc9471f6e16766b7132dd6bb34ea62' => test_zci(
        'This is a 160 bit SHA-1 cryptographic hash.',
        structured_answer => {
            data => {
                title => "This is a 160 bit SHA-1 cryptographic hash.",
            },
            meta => {
                sourceName => "Wikipedia SHA-1",
                sourceUrl => "https://en.wikipedia.org/wiki/SHA-1"
            },
            templates => {
                group => 'text',
                options => {
                    moreAt => 1,
                    moreText => undef
                }
            }
        }       
    ),
    'hash 1f9b59a2390bb77d2c446837d6aeab067f01b05732735f47099047cd7d3e9f85' => test_zci(
        'This is a 256 bit SHA-2/SHA-3 cryptographic hash.',
        structured_answer => {
            data => {
                title => "This is a 256 bit SHA-2/SHA-3 cryptographic hash.",
            },
            meta => {
                sourceName => "Wikipedia SHA-2",
                sourceUrl => "https://en.wikipedia.org/wiki/SHA-2"
            },
            templates => {
                group => 'text',
                options => {
                    moreAt => 1,
                    moreText => [ 
                        {                                                                                                                                  
                            href => "https://en.wikipedia.org/wiki/SHA-3",                                                                                         
                            text => "SHA-3"                                                                                                                        
                        } 
                    ]
                }
            }
        }
    ),
    'hash 1f9b59a2390bb77d2c446837d6aeab067f01b05732735f47099047cd7d3e9f851' => undef,
    'hash 1f9b59a2390bb77d2c446837d6aeab067f01b05732735f47099047cd7d3e9t85' => undef,
);

done_testing;


