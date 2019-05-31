use String::Similarity;

($file) = @ARGV;
open FI, $file;

$i = 0;
while (<FI>) {
	chomp;
	@line = split /,/;
#	print "line0 = $line[0]\n";
#	print "line1 = $line[1]\n";
	$id = $line[0];
#	print "$id\n";
	for ($i = 0; $i < $#line; $i++) {
		$industry[$i] =  $line[$i+1];
		$industry[$i] =~ s/^\s+//;
	}
	
	if ($i == 3) {
		$score1 = similarity $industry[0], $industry[1];
		$score2 = similarity $industry[0], $industry[2];
		$score3 = similarity $industry[1], $industry[2];
		if ($score1 >= $score2) {
			if ($score2 >= $score3) {
				print "$id, \"$industry[0]\" and \"$industry[1]\"\n";
			}
			else {
				print "$id, \"$industry[0]\" and \"$industry[2]\"\n";
			}
		} else {
			if ($score1 >= $score3) {
				print "$id, \"$industry[1]\" and \"$industry[0]\"\n";
			}
			else {
				print "$id, \"$industry[1]\" and \"$industry[2]\"\n";
			}
		} 
	}
	elsif ($i == 2) {
		print "$id, \"$industry[0]\" and \"$industry[1]\"\n";
	}
	elsif ($i == 1) {
		print "$id, \"$industry[0]\"\n";
	}
}
close FI;
	
	

 
