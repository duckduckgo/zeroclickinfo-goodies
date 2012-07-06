package DDG::Goodie::IDN;
# ABSTRACT: Convert domain names from/to Punycode.

use DDG::Goodie;
use Net::IDN::Encode ':all';
use HTML::Entities;

attribution web => ['http://7bits.nl/', 'Peter van Dijk'],
            email => ['peter@7bits.nl', 'Peter van Dijk'],
            github => ['https://github.com/habbie', 'habbie'],
            twitter => ['https://twitter.com/habbie', 'habbie'];

triggers startend => 'idn';

handle remainder => sub {
	if(/^xn--/) {
		return 'Decoded IDN: '.encode_entities(domain_to_unicode($_));
	}
	else {
		return 'Encoded IDN: '.encode_entities(domain_to_ascii($_));
	}
	return;
};

zci is_cached => 1;

1;
