use String::Similarity;


for ($i = 1; $i <= 10; $i++) {
    $file = "Sector$i-sic-freq.txt";
    print "processing $file now\n";
    open FI, $file || die "cannot open file $file";
    
    for ($k = 1; $k <= 10; $k++) {
        $c[$k] = 0;
    }

    $count = 0;
    $first = <FI>;
    while (<FI>) {
        @line = split;
#        print "$line[0], $line[1]\n";
        $two_digits = int ($line[0] / 100);
#        print "$two_digits\n";
#        <STDIN>;
        if (($two_digits > 1) && ($two_digits <= 9)) {
            $c[1] += $line[1];
        }
        elsif (($two_digits >= 10) && ($two_digits <= 14)) {
            $c[2] += $line[1];
        }
        elsif (($two_digits >= 15) && ($two_digits <= 17)) {
            $c[3] += $line[1];
        }
        elsif (($two_digits >= 20) && ($two_digits <= 39)) {
            $c[4] += $line[1];
        }
        elsif (($two_digits >= 40) && ($two_digits <= 49)) {
            $c[5] += $line[1];
        }
        elsif (($two_digits >= 50) && ($two_digits <= 51)) {
            $c[6] += $line[1];
        }
        elsif (($two_digits >= 52) && ($two_digits <= 59)) {
            $c[7] += $line[1];
        }
        elsif (($two_digits >= 60) && ($two_digits <= 67)) {
            $c[8] += $line[1];
        }
        elsif (($two_digits >= 70) && ($two_digits <= 89)) {
            $c[9] += $line[1];
        }
        elsif (($two_digits >= 91) && ($two_digits <= 99)) {
            $c[10] += $line[1];
        }
        $count++;
    }
    close FI;
    
    for ($j = 1; $j <= 10; $j++) {
        $perc = $c[$j] / $count;
#        print "SEC Sector $j: $perc\n";
        print "SEC's Sector #$j: $c[$j]\n";
    }
    print "\n";
}
