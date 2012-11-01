package DDG::Goodie::LinuxPermissions;

use DDG::Goodie;

triggers query_lc => qr/^([0|1|2|4]{1}[0-7]{3})$/;

zci is_cached => 1;
zci answer_type => "linux_permissions";

sub calcperms {
	if($_[0] == 7) {
            return "Read, Write, and Execute";
             }
	elsif($_[0] == 6){
		return "Read and Write";
             }
	elsif($_[0] == 5){
		return "Read and Execute";
             }
	elsif($_[0] == 4) {
		return "Read";
             }
	elsif($_[0] == 3){
		return "Write and Execute";
             }
	elsif($_[0] == 2){
		return "Write";
             }
	elsif($_[0] == 1){
		return "Execute";
             }
	else{ return "No access"};
}

sub calcenglish {
   my ($result);
   if($_[0] == 0) {
      for(my($i)= 1;$i<4;$i++){
         if($_[$i] == 7) {
            $result .= "rwx";
         }
         elsif($_[$i] == 6) {
            $result .= "rw-";
         }
         elsif($_[$i] == 5) {
            $result .= "r-x";
         }
         elsif($_[$i] == 4) {
            $result .= "r--";
         }
         elsif($_[$i] == 3) {
            $result .= "-wx";
         }
         elsif($_[$i] == 2) {
            $result .= "-w-";
         }
         elsif($_[$i] == 1) {
            $result .= "--x";
         }
         else {
            $result .= "---";
         }
      }
   }
   return $result;
}

    handle matches => sub {
      my (@perm) = split(//);
      my ($result) = "User: " . calcperms($perm[1]) . "\n";
      $result .= "Group: " . calcperms($perm[2]) . "\n";
      $result .= "Others: " . calcperms($perm[3]);
      $result .= "\n\n" . calcenglish($perm[0], $perm[1], $perm[2], $perm[3]);
      return $result;
   };
1;
