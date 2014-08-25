package DDG::Goodie::Password;
# ABSTRACT: Generate a random password.

use DDG::Goodie;

primary_example_queries 'random password', 'random password strong 15';
description 'generates a random password';
name 'Password';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodies/Password.pm';
attribution github => ['https://github.com/duckduckgo', 'duckduckgo'];
category 'computing_tools';
topics 'cryptography';

zci answer_type => 'pw';

triggers any => 'random', 'password', 'pw', 'pwgen';

# exclude lower case l's, upper case I's and O's.
my @pwgen_avg = ('a'..'k','m'..'z','A'..'H','J'..'N','P'..'Z',0..9);
my @pwgen_weak = ('a'..'k','m'..'z','A'..'H','J'..'N','P'..'Z');
my @pwgen_strong = ('a'..'k','m'..'z','A'..'H','J'..'N','P'..'Z',0..9,'!','@','#','$','%','^','&','*','(',')');

my %pw_strengths = (
    'strong' => 'strong',
    'hard' => 'strong',
    'weak' => 'weak',
    'average' => 'avg',
    'avg' => 'avg',
);

handle query_lc => sub {
    if ( $_ =~ /^\!?(?:(?:random |)password(?: generator|)|pw(?:gen|))(?: |)(\d+|strong|hard|weak|average|avg|)(?: |)(\d+|strong|hard|weak|average|avg|)$/i ) {

	# Actually make it random.
	srand();


        my $var1 = $1 || '';
        my $var2 = $2 || '';

        # For debugging.
        #	warn qq(VARS: $var1\t$var2\n);

        my $pw_length = 8;
        $pw_length = $var1 if $var1 && $var1 =~ /^\d+$/;
        $pw_length = $var2 if $var2 && $var2 =~ /^\d+$/;
        $pw_length = 1     if $pw_length < 1;
        $pw_length = 32    if $pw_length > 32;

        # For debugging.
        #	warn $pw_length;

        my $pw_strength = 'avg';
        $pw_strength = $pw_strengths{ lc $var1 } if $var1 && exists $pw_strengths{ lc $var1 };
        $pw_strength = $pw_strengths{ lc $var2 } if $var2 && exists $pw_strengths{ lc $var2 };

        # For debugging.
        #	warn $pw_strength;
        #	warn exists $data->{pw_strengths}->{lc $var1};

        # Password.
        my $pwgen = '';

        # Generate random password.
        for ( my $i = 0 ; $i < $pw_length ; $i++ ) {
            my $rand = rand;

            if ( $pw_strength eq 'weak' ) {
                $rand *= scalar(@pwgen_weak);
                $rand = int($rand);
                $pwgen .= $pwgen_weak[$rand];
            } elsif ( $pw_strength eq 'strong' ) {
                $rand *= scalar(@pwgen_strong);
                $rand = int($rand);
                $pwgen .= $pwgen_strong[$rand];
            } else {
                $rand *= scalar(@pwgen_avg);
                $rand = int($rand);
                $pwgen .= $pwgen_avg[$rand];
            }
        }

        # Include at least one #.
        if ( ( $pw_strength eq 'avg' || $pw_strength eq 'strong' ) && $pwgen !~ /\d/ ) {
            my $rand = rand;
            $rand *= $pw_length - 1;
            $rand = int($rand) + 1;

            my $rand2 = rand;
            $rand2 *= 9;
            $rand2 = int($rand2);

            # Splice in number.
            $pwgen = substr( $pwgen, 0, $rand - 1 ) . $rand2 . substr( $pwgen, $rand );
        }

        # Include at least one special char.
        if ( $pw_strength eq 'strong' && $pwgen !~ /[\!\@\#\$\%\^\&\*\(\)]/ ) {
            my $rand = rand;
            $rand *= $pw_length - 1;
            $rand = int($rand) + 1;

            my $rand2 = rand;
            $rand2 *= 10;
            $rand2 = int($rand2);

            my @rand2 = ( '!', '@', '#', '$', '%', '^', '&', '*', '(', ')' );

            # For debugging.
            #	    warn "SPLICE $rand2", $rand2[$rand2], "\n";

            # Splice in number.
            $pwgen = substr( $pwgen, 0, $rand - 1 ) . $rand2[$rand2] . substr( $pwgen, $rand );
        }

        # Add password for display.
        return $pwgen." (random password)";
    }
    return;
};

1;
