#!C:\Strawberry_Perl\bin\Perl -w

($sic_name, $pre, $number) = @ARGV;

open(FI, $sic_name);
$count = 0;
while (<FI>) {
	chomp;
	@line = split;
	$sic = $line[0];
#	$ignore = $line[1];
	$name = '';
	for ($i = 2; $i <= $#line; $i++) {
		$name = "$name $line[$i]";
	}
	$company{$name} = $sic;
#	print "$name -> $company{$name}\n";
	$count++;
}
close FI;

if ($pre eq 'Sector') {
	$total = 10;
} else {
	$total = 100;
}

for ($i = 1; $i <= $total; $i++) {
	$output = "$i";
	$file = "$pre$i-sic-freq.txt";
#	print "now processing $file\n";
	open(FI2, $file) || die "cannot open $file\n";
	$line = <FI2>; # skip first line;
	
	for ($j = 0; $j < $number; $j++) {
		if (eof FI2) {
			last;
		}
		$_ = readline(FI2);
		@tokens = split;
	
		foreach $key (keys %company) {
			if ($tokens[0] == $company{$key}) {
				$output = "$output,$key";
				last;
			}
		}
	}
	close FI2;
	print "$output\n";
}
