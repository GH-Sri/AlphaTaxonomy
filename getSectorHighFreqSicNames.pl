#!C:\Strawberry_Perl\bin\Perl -w

($sic_filename, $number) = @ARGV;

@a1 = ('Noun', 'Noun', 'and', 'Noun');
@a2 = ('Adjective', 'and', 'Adjective', 'Noun');
@a3 = ('Adjective', 'Noun', 'and', 'Noun');
@a4 = ('Noun', 'Adverb', 'Noun');

%grammar_template = ('300' => \@a1, 
					 '120' => \@a2, 
					 '210' => \@a3,
					 '201' => \@a4);
			  
%dictionary = ( 'PREPARATIONS' => 'Noun',
				'PHARMACEUTICAL' => 'Adjective',
				'BIOLOGICAL' => 'Adjective',
				'SURGICAL' => 'Adjective',
				'INSTRUMENTS' => 'Noun',
				'APPARATUS' => 'Noun',
				'SERVICES' => 'Noun',
				'SOFTWARE' => 'Noun',
				'SERVICES-PREPACKAGED' => 'Adjective',
				'STORES' => 'Noun',
				'PRODUCTS' => 'Noun',
				'OTHER' => 'Adjective',
				'DEVICES' => 'Noun',
				'RELATED' => 'Adverb',
				'SEMICONDUCTORS' => 'Noun',
				'EQUIPMENT' => 'Noun',
				'MACHINERY' => 'Noun',
				'PRODUCTS' => 'Noun',
				'COMMERCIAL' => 'Noun',
				'BANKS' => 'Noun',
				'STATE' => 'Noun',
				'INSURANCE' => 'Noun',
				'INVESTMENT' => 'Noun',
				'REAL' => 'Adjective',
				'GAS' => 'Noun',
				'NATURAL' => 'Adjective',
				'PETROLEUM' => 'Noun',
				'ESTATE' => 'Noun',
				'TRUSTS' => 'Noun',
				'INVESTMENT' => 'Noun' ); # a small dictionary is used here for prototyping

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

for ($i = 1; $i <= 10; $i++) {
	$file = "Sector$i-sic-freq.txt";
#	print "processing file: $file\n";
	$output = '';
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
		$word[$k] = $key;
		$part[$k] = $dictionary{$key};
#		print "word[$k]:$word[$k], part[$k]:$part[$k]\n";
#		<STDIN>;
		$k++;
		if ($k == $number) {
			last;
		}
	}
	
	$sum = 0;
	for ($l = 0; $l < $k; $l++) {
		if ($dictionary{$word[$l]} =~ /Noun/) {
			$sum += 100;
		}
		elsif ($dictionary{$word[$l]} =~ /Adjective/) {
			$sum += 10;
		}
		else {
			$sum += 1;
		}
		$used[$l] = 0;
	}
	$str = sprintf ("%d", $sum);
#	print "sum=$str\n";
	@template = @{$grammar_template{$str}};
	for ($l = 0; $l <= $#template; $l++) {
#		print "template[$l]=$template[$l]\n";
		$attr = $template[$l];
		if ($attr eq 'and') {
			$output = "$output and";
		} else {
			for ($j = 0; $j < 3; $j++) {
				if (($used[$j] == 0) && ($attr eq $part[$j])) {
					$output = "$output $word[$j]";
					$used[$j] = 1;
					last;
				}
			}
		}
	}
	$output =~ s/^\s+//;
	print "$i, \"$output\"\n";
	
	undef %count;
}
	
	
			