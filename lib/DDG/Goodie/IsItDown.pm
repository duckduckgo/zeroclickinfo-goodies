package DDG::Goodie::IsItDown;
# ABSTRACT: Check if a website is available

use DDG::Goodie;

use HTTP::Status;
use HTTP::Response;
use LWP::UserAgent;

zci is_cached => 0;
triggers start => "is";
triggers start => "down", "down?";

handle query_raw => sub {

# change $ARGV[0] to $input
print $_;
if (my ($protocol, $domain) = (
        $_ =~ m/^is (http:\/\/)?([a-zA-Z0-9_-]*\.com) down\??$/)) {
  my $url = "http://${domain}";

  my $ua = new LWP::UserAgent;
  $ua->agent("DDG/1.0");
  my $request = new HTTP::Request("GET", $url);
  my $response = $ua->request($request);

  my $code=$response->code;
  my $headers = $response->headers_as_string;
  my $body = $response->content;

  if ($response->code == RC_OK) {
      return "${domain} is up!";
  } else {
      return "We can't reach ${domain} either.";
  }
}

};

1;
