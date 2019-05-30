#!C:\Strawberry_Perl\bin\Perl -w

($sic_filename, $sectorID, $number) = @ARGV;

open(FI, $sic_filename);

while (<FI>) {
	chomp;
	@line = split;
	$sic = $line[0];
#	$ignore = $line[1];
	$name = '';
	for ($i = 2; $i <= $#line; $i++) {
		$name = "$name $line[$i]";
	}
	$sic_name{$sic} = $name;
#	print "$sic -> $sic_name{$sic}\n";
}
close FI;

for ($i = $sectorID; $i <= $sectorID; $i++) {
	$file = "Sector$i-sic-freq.txt";
#	print "processing file: $file\n";
	$output = "$i";
	open FI, $file || die "cannot open file $file";
	
	<FI>;
	while (<FI>) {
		chomp;
		@line = split;
#		print "sic:$line[0], freq:$line[1]\n";
		$sic = $line[0];
		$freq = $line[1];
		$str = $sic_name{$sic};
		$str =~ s/^\s+//;
#		print "sic_name{$sic}=$str\n";
		@tokens = split (/\s/, $str);
#		print "tokens[0]=$tokens[0]\n";
		for ($j = 0; $j <= $#tokens; $j++) {
			if ($tokens[$j] eq '&') {
				next;
			}
			if (defined $count{$tokens[$j]}) {
				$count{$tokens[$j]} += $freq;
			}
			else {
				$count{$tokens[$j]} = $freq;
			}
		}
	}
	close FI;
	
	$k = 0;
	foreach $key (sort { $count{$b} <=> $count{$a} } keys %count) {
#		print "$key $count{$key}\n";
		$output = "$output,$key";
		$k++;
		if ($k == $number) {
			last;
		}
	}
	print "$output\n";
}
	
	
			