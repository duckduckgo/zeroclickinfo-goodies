package DDG::Goodie::RandomName;
# ABSTRACT: Return random first and last name
use DDG::Goodie;
use Data::RandomPerson;

triggers start  => 'random';
zci answer_type => 'rand';


name 'RandomName';
description 'returns a random and fictive title, first- and lastname and day of birth';
category 'random';
topics 'programming';
primary_example_queries 'random name';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/RandomName.pm';
attribution github  => ['https://github.com/stelim', 'Stefan Limbacher'],
            twitter => ['http://twitter.com/stefanlimbacher', 'Stefan Limbacher'];

handle remainder => sub {
    my $person = Data::RandomPerson->new()->create();

    if ($_ =~ m{name}xmsi) {    
        return "$person->{firstname} $person->{lastname}";
    }
    else {
        return;
    }
};


1;