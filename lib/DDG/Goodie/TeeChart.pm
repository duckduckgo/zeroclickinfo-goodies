package DDG::Goodie::TeeChart;
# ABSTRACT: Generate a chart.

use DDG::Goodie;
use Scalar::Util qw(looks_like_number);

triggers start => 'chart', 'graph', 'plot', 'grafico';

handle query_parts => sub {

    # if (lc(shift) eq 'ch') {
    #    return unless lc(shift) eq "art";
    # }
    # my $str = join(' ',@_);

    my $data = "";
    my $labels = "";

    my $c=0;

    foreach (@_) {
     if (looks_like_number($_)) {
        if (length $data) {
          $data = $data . ",";
        }
      	$data = $data . $_;
     }
     elsif ($c > 0)
     {
       if ($_ eq ",") {
       }
       else
       {
         if (length $labels) {
           $labels = $labels . ",";
         }
      	 $labels = $labels . "'" . $_ . "'";
       }
     }

     $c++;
    }

    my $html = "";

    if (length $data)  {
      my $s = "var c=new Tee.Chart('chart1'); s=c.addSeries(new Tee.Bar([".$data."]));";

      if (length $labels) {
        $s = $s . " s.data.labels=[" . $labels . "];";
      }

      $s = $s . " c.draw();";

      my $tee = "http://www.steema.com/files/public/teechart/html5/jscript/src/teechart.js";

      $html = $html . '<script type="text/javascript" src="'.$tee.'"></script><canvas id="chart1"></canvas><script type="text/javascript">'.$s.'</script>';

      $html = qq( <div style="float:left;margin-right:10px;">$html</div><div class="clear"></div>);

      zci is_cached => 1;
      zci answer_type => "chart";
    }

    return '', html => $html;
};

1;
