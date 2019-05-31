
($file, $t_file) = @ARGV;

open(FI, $t_file) || die "cannot open file";
$first_line = <FI>;
$c = 0;
$pre_name = '';
#open FIW, '>', "company_name_sic";
while (<FI>) {
	chomp;
	@line = split(/,/);
#	print "line[0]:$line[0], line[1]:$line[1], line[2]=$line[2], line[$#line]=$line[$#line]\n";
	if ($line[1] =~ m/\"/) {
		$name = "$line[1],$line[2]";
		$name =~ s/"//g;
	}
	else {
		$name = $line[1];
	}
	if ($pre_name eq $name) {
		next;
	}
	$stock[$c][2] = $name;
	if (($line[$#line] > 1) && ($line[$#line] < 10000)) {
		$stock[$c][4] = $line[$#line];
	} else {
		$stock[$c][4] = 0;
	}
#	print FIW "$stock[$c][2] - $stock[$c][4]\n";
#	print "$stock[$c][2] - $stock[$c][4]\n";
	$pre_name = $name;
	$c++;
#	<STDIN>;
}
close FI;
print "\nThere are $c entries in the file $t_file\n";

for ($i = 1; $i <= 100; $i++) {
	open(FI, $file);
	open(FIW, '>', "Industry$i-company-list.txt");
	print "*** Generating Industry$i-company-list.txt ***\n";
	$first_line = <FI>;
	while (<FI>) {
		@tokens = split (/,/);
		chomp $tokens[$#tokens];
		if ($tokens[$#tokens] == $i) {
			$tokens[0] =~ s/\"//g;
#			print "$tokens[0]\n";
#			<STDIN>;
			$sic = 0;
			for ($j = 0; $j < $c; $j++) {
				if (($tokens[0] =~ /$stock[$j][2]/i) || ($stock[$j][2] =~ /$tokens[0]/i)) {
					$sic = $stock[$j][4];
#					print "$tokens[0] $stock[$j][2] $sic\n";
					last;
				}
			}
			print FIW "$tokens[0], $sic\n"; 
		}
	}
	close FI;
	close FIW;
}

