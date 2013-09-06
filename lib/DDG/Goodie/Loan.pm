package DDG::Goodie::Loan;
# ABSTRACT: Calculate monthly payment and total interest payment for a conventional mortgage loan

use DDG::Goodie;

triggers start => 'loan';

zci is_cached => 1;
zci answer_type => 'loan';

primary_example_queries 'loan $500000 at 4.5% with 20% down';
secondary_example_queries 
	'loan $500000 at 4.5% with 20% down 15 years',
	'loan $500000 4.5%',
	'loan $500000 4.5% 20% down 15 years';

description 'Calculate monthly payment and total interest for conventional mortgage';
name 'Loan';
category 'finance';
topics 'economy_and_finance';
attribution github  => [ 'https://github.com/mmattozzi', 'mmattozzi' ];

# Monthly payment calculation from http://en.wikipedia.org/wiki/Mortgage_calculator
sub loan_monthly_payment {
	my ($p, $r, $n) = @_;
	return ($r / (1 - (1 + $r)**(-1 * $n))) * $p;
}

handle remainder => sub {
	my $query = $_;

	# At a minimum, query should contain some amount of money and a percent interest rate
	if ($query =~ /^\$?(\d+)\s(at\s)?(\d+.?\d*)%/) {
		my $principal = $1;
		my $rate = $3;
		my $downpayment = 0;
		my $years = 30;

		# Check if query contains downpayment information
		if ($query =~ /\$?(\d+)(%)? down/) {
			my $downpaymentIsInDollars = ! (defined $2);
			my $downpaymentNoUnits = $1;
			if ($downpaymentIsInDollars) {
				$downpayment = $downpaymentNoUnits;
			} else {
				$downpayment = $principal * .01 * $downpaymentNoUnits;
			}
		}

		# Check if query contains number of years for loan
		if ($query =~ /(\d+) years?/) {
			$years = $1;
		}

		my $loanAmt = $principal - $downpayment;
		my $monthlyPayment = loan_monthly_payment($loanAmt, $rate / 12 * .01, $years * 12);
		my $totalInterest = ($monthlyPayment * 12 * $years) - $loanAmt;

		return "Monthly Payment is \$" . sprintf("%.2f", $monthlyPayment) . 
			" for $years years. Total interest paid is \$" . sprintf("%.2f", $totalInterest); 
			
	}
	return;
};

1;
