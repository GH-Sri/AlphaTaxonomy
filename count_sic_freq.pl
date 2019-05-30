#!C:\Strawberry_Perl\bin\Perl -w

($pre) = @ARGV;

if ($pre eq 'Sector') {
	$total = 10;
} else {
	$total = 100;
}

for ($i = 1; $i <= $total; $i++) {
	$file = "$pre$i-company-list.txt";
	print "now processing $file\n";
	open(FI, $file);

	$count = 0;
	for ($j = 1; $j < 10000; $j++) {
		$freq{$j} = 0;
	}

	foreach $key (keys %freq) {
		if ($freq{$key} > 0) {
			$freq{$key} = 0;
		}
	}


	while (<FI>) {
		chomp;
		@line = split /,/;
		$company_name = $line[0];
#		$company_name =~ s/\"//g;
		$sic = $line[$#line];
		if ( ($sic > 0) && ($sic < 10000) ) {
			$freq{$sic}++;
			$count++;
		}
		else {
#			print "$company_name, $sic\n";
		}

	}
	close FI;
	print "count: $count\n";
	
#	foreach $key (keys %freq) {
#		if ($freq{$key} > 0) {
#			print "$key $freq{$key}\n";
#		}
#	}
	
	$f_file = "$pre$i-sic-freq.txt";
	open FIW, '>', $f_file;
	print FIW "#SIC #Occurrence #Percentage #Accumulated_Percentage\n";
	
	$accumu_perc = 0;
	foreach $key (sort { $freq{$b} <=> $freq{$a} } keys %freq) {
		if ($freq{$key} == 0) {
			last;
		}
		$percentage = $freq{$key} / $count;
		$accumu_perc += $percentage;
		print FIW "$key $freq{$key} $percentage $accumu_perc\n";
	}
	close FIW;
}

