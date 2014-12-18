package DDG::Goodie::RandomName;
# ABSTRACT: Return random first and last name

use DDG::Goodie;

use Data::RandomPerson;

name 'RandomName';
description 'returns a random and fictive title, first- and lastname and day of birth';
category 'random';
topics 'words_and_games';
primary_example_queries 'random name';
secondary_example_queries 'random person';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/RandomName.pm';
attribution github  => ['https://github.com/stelim', 'Stefan Limbacher'],
            twitter => ['http://twitter.com/stefanlimbacher', 'Stefan Limbacher'];

triggers start  => 'random name','random person';
zci answer_type => "randomname";
zci is_cached   => 0;

handle query => sub {
    my $person = Data::RandomPerson->new()->create();
    my $name = "$person->{firstname} $person->{lastname}";
    my %genders = (m => 'Male', f => 'Female');
    return "Name: $name\nGender: $genders{$person->{gender}}\nDate of birth: $person->{dob}\nAge: $person->{age}",
           heading => "Random Person" if /person/i;
    return "$name (random)";
};


1;
