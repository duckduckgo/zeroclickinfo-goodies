package DDG::Goodie::Password;
# ABSTRACT: Generate a random password.

use strict;
use DDG::Goodie;

use Crypt::URandom qw( urandom );

use List::MoreUtils qw( none );
use List::Util qw( min max first );
use Scalar::Util qw( looks_like_number );

zci answer_type => 'pw';
zci is_cached   => 0;

triggers start => 'random password', 'generate password', 'generate random password', 'password generator', 'pw', 'generate pw', 'random pw', 'pwgen';
triggers startend => 'password';

use constant MAX_PWD_LENGTH => 64;
use constant MIN_PWD_LENGTH => 8;

my %look_alikes = map { $_ => 1 } qw(l O I);    # Exclude alphabet characters which can be easily visually confused.
my %averages = map { $_ => 1 } (2 .. 9);        # 0,1 missing for the same reasons as above.
my %highs = map { $_ => 1 } ('!', '@', '#', '$', '%', '^', '&', '*', '(', ')');

my @pwgen_low = grep { !$look_alikes{$_} } ('a' .. 'z', 'A' .. 'Z');
my @pwgen_average = (@pwgen_low,     keys %averages);
my @pwgen_high    = (@pwgen_average, keys %highs);

my %pw_strengths = (
    'strong' => 'high',
    'hard'   => 'high',
    'easy'   => 'low',
    'weak'   => 'low',
    'normal' => 'average',
    'avg'    => 'average',
);

foreach my $value (values %pw_strengths) {
    $pw_strengths{$value} = $value;    # Add in self-refereces.
}

my $strengths = join('|', keys %pw_strengths);


handle remainder => sub {

    my $query = lc(shift);
    
    # Remove stopwords from remainder before checking format
    my @stopwords = ('generate', 'generator', 'random', 'characters', 'create');
    for my $stopwd (@stopwords) {
        $query =~ s/$stopwd//;
    }
    
    return if ($query && $query !~ /^(?<fw>\d+|$strengths|)\s*(?<sw>\d+|$strengths|)$/i);

    my @q_words = map { lc $_ } grep { defined } ($+{'fw'}, $+{'sw'});

    my $pw_length = first { looks_like_number($_) } @q_words;
    $pw_length = ($pw_length) ? max(1, $pw_length) : MIN_PWD_LENGTH;

    return if ($pw_length > MAX_PWD_LENGTH || $pw_length < MIN_PWD_LENGTH);

    my $strength_code = first { $_ && exists $pw_strengths{$_} } @q_words;
    my $pw_strength = $pw_strengths{$strength_code || 'average'};

    # Password.
    my @pwgen;

    my @list_to_use = ($pw_strength eq 'low') ? @pwgen_low : ($pw_strength eq 'high') ? @pwgen_high : @pwgen_average;

    # Generate random password of the correct length.
    while (scalar @pwgen < $pw_length) {
        push @pwgen, $list_to_use[saferandom(scalar @list_to_use)];
    }
    if ($pw_strength ne 'low') {
        # Make sure we have the characters we want;
        replace_inside_with(\@pwgen, \%averages) if (none { $averages{$_} } @pwgen);
        replace_inside_with(\@pwgen, \%highs) if ($pw_strength eq 'high' && none { $highs{$_} } @pwgen);
    }

    my $pw_string = join('', @pwgen);

    # Add password for display.
    return "$pw_string (random password)", structured_answer => {
        data => {
            title => $pw_string,
            subtitle => "Random password: $pw_length characters, $pw_strength strength"
        },
        templates => {
            group => 'text'
        }
    };
};

sub replace_inside_with {
    my ($orig, $required_hash) = @_;

    my @keys = keys %$required_hash;

    # replace a random character in the original list with
    # with a randomly selected key from our hash.
    $orig->[saferandom(scalar @$orig)] = $keys[saferandom(scalar @keys)];
    return;
}

sub saferandom {
    my ($range) = @_;
    return unpack("L", urandom(4)) % $range;
}

1;
