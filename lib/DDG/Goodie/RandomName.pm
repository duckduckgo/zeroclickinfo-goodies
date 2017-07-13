package DDG::Goodie::RandomName;
# ABSTRACT: Return random first and last name

use strict;
use DDG::Goodie;
use Data::RandomPerson;

triggers start  => 'random name','random person';
zci answer_type => "randomname";
zci is_cached   => 0;

handle query => sub {
    my $query = $_;
    my $person = Data::RandomPerson->new()->create();
    my $name = "$person->{firstname} $person->{lastname}";
    my $string_answer;
    my $structured_answer = {};
    $structured_answer->{templates}->{group} = 'icon';
    $structured_answer->{data}->{title} = $name;
    $structured_answer->{data}->{altSubtitle} = 'Randomly generated name';
    if ($query =~ /person/i) {
        my %genders = (m => 'Male', f => 'Female');
        $string_answer = "Name: $name\nGender: $genders{$person->{gender}}\nDate of birth: $person->{dob}\nAge: $person->{age}";
        $structured_answer->{data}->{subtitle} = 'Birthday: ' . $person->{dob} . ' | Age: ' . $person->{age};
        $structured_answer->{data}->{altSubtitle} = 'Randomly generated person';
    } else {
        $string_answer = "Name: $name";
    }
    return $string_answer, structured_answer => $structured_answer;
};

1;
