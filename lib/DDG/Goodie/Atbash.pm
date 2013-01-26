package DDG::Goodie::Atbash;
# ABSTRACT: A simple substitution cipher using a reversed alphabet

use DDG::Goodie;

primary_example_queries 'atbash hello';
secondary_example_queries 'atbash svool';
description 'A simple substitution cipher using a reversed alphabet';
name 'Atbash';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Atbash.pm';
category 'transformations';
topics 'cryptography';

attribution web => ['http://kyokodaniel.com/tech/', 'Daniel Davis'],
            github => ['https://github.com/tagawa', 'tagawa'],
            twitter => ['https://twitter.com/ourmaninjapan', 'ourmaninjapan'];

triggers start => 'atbash';

zci is_cached => 1;

handle remainder => sub {
    if ($_) {
        my $char;
        my $result;
        
        while (/(.)/g) {
            if ($1 =~ /([a-z])/) {
                # Substitute lowercase characters
                $char = chr(219 - ord $1);
            }
            elsif ($1 =~ /([A-Z])/) {
                # Substitute uppercase characters
                $char = chr(155 - ord $1);
            }
            else { $char = $1; }
            $result .= $char;
        }
        
        return "Atbash: $result";
    }
    return;
};

1;
