#!/usr/bin/perl
#name	age	gender	distance	event	age-group	result
#Anderson, Elijah	11	M	50	free	1112	2022/07/09	33.93	33.93
#Anderson, Elijah	11	M	50	breast	1112	2022/07/09	43.92	43.92
#Anderson, Jarah	14	F	50	free	1314	2022/07/09	33.87	33.87
#Anderson, Jarah	14	F	50	breast	1314	2022/07/09	45.91	45.91
#Anderson, Jarah	14	F	50	back	1314	2022/07/09	45.38	45.38
#Bell, Thomas	8	M	25	free	0708	2022/07/09	39.93	39.93
#Boyer, Elise	10	F	50	free	0910	2022/07/09	40.07	40.07
#Boyer, Elise	10	F	50	breast	0910	2022/07/09	DQ	DQ
#Boyer, Elise	10	F	50	fly	0910	2022/07/09	58.55	58.55


while ($line = <>) {
  if ($line =~ /distance/) {
    next;
  }
  chomp $line;
  @line = split(/	/, $line);
  $dates{$line[6]} = 1;
  ## UN for under in age group messes up sorting. change to 00 (UN06 -> 0006)
  $line[5] =~ s/UN/00/;
  $swimmerevent = $line[0] . ":" . $line[3] . ":" . $line[4] . ":" . $line[2] . ":" . $line[5];
  # if they have a time
  if ( $line[8] =~ /^[0-9.]+/) { 
    $legal{$swimmerevent}++;
    if ($best{$swimmerevent} > $line[8]) {
      $improvemeet{$swimmerevent}{$line[6]} = sprintf("%.2f", $best{$swimmerevent} - $line[8]);
      $improvetotal{$swimmerevent}{$line[6]} = sprintf("%.2f", $first{$swimmerevent} - $line[8]);
      if ($improvetotal{$swimmerevent}{$line[6]} >= 10) {
        if (! $gold{$swimmerevent}) {
          $gold{$swimmerevent}{"previous"} = 0;
        }
        if ( $improvetotal{$swimmerevent}{$line[6]} - $gold{$swimmerevent}{"previous"} >= 10 ) {
          $gold{$swimmerevent}{$line[6]} = $improvetotal{$swimmerevent}{$line[6]} - $gold{$swimmerevent}{"previous"};
          $gold{$swimmerevent}{"previous"} = $improvetotal{$swimmerevent}{$line[6]};
        } 
      }
      $best{$swimmerevent} = $line[8];
    }
    if (! $first{$swimmerevent}) {
      $first{$swimmerevent} = $line[8];
      $best{$swimmerevent} = $line[8];
    }
    if (! $firstswim{$swimmerevent} ) {
      $firstswim{$swimmerevent} = $line[6];
    }
  }
  if ($line[8] =~/DQ/) {
    if (! $firstswim{$swimmerevent} ) {
      $firstswim{$swimmerevent} = $line[6];
    }
  }
  $result{$swimmerevent}{$line[6]} = $line[7];
}

@dates = sort keys(%dates);
@swimmerevents = sort keys(%firstswim);

print "swimmer	gender	age-grp	event	";
foreach $date (@dates) {
    printf "$date	firsttime	improvement	goldstroke	";
}
print "champs?	best	season improvement\n";

foreach $sevent (@swimmerevents) {
  @sevent = split(/:/, $sevent);
  printf "%s	%s	%s	%s %s	", $sevent[0], $sevent[3], $sevent[4], $sevent[1], $sevent[2];
  foreach $date (@dates) {
    if ($firstswim{$sevent} eq $date) {
      $first = "yes"
    } else {
#      print STDERR "$firstswim{$sevent} != $date\n";
      $first = ""
    }
    printf "%s	%s	%s	%s	", $result{$sevent}{$date}, $first, $improvemeet{$sevent}{$date}, $gold{$sevent}{$date};
  }
  ## print champs-eligible column
  if ( $legal{$sevent} >=2 ) { 
    print "yes";
  }
  print "	";
  ## print season best time
  printf "%s	", $best{$sevent};
  ## print season improvement
  printf "%.2f\n", $first{$sevent} - $best{$sevent};
}  
