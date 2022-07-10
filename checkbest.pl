#!/usr/bin/perl
#Gwinn, Eleanor  5       X       25      free    UN08    2021/06/12      46.28   46.28
#Philip, Fiona   4       X       25      free    UN08    2021/06/12      42.88   42.88

#name    age     gender  distance        event   age-group       result
#Bright, Max     14      M       50      free    1314    2022/06/11      30.40   30.40
#Bright, Max     14      M       50      back    1314    2022/06/11      37.85   37.85


while ($line = <>) {
  if ($line =~ /distance/) {
    next;
  }
  chomp $line;
  @line = split(/	/, $line);
  $dates{$line[6]} = 1;
  $swimmerevent = $line[0] . ":" . $line[3] . ":" . $line[4] . ":" . $line[2] . ":" . $line[5];
  # if they have a time
  if ( $line[8] =~ /^[0-9.]+/) { 
    $legal{$swimmerevent}++;
    if ($best{$swimmerevent} > $line[8]) {
      $improvemeet{$swimmerevent}{$line[6]} = sprintf("%.2f", $best{$swimmerevent} - $line[8]);
      $improvetotal{$swimmerevent}{$line[6]} = sprintf("%.2f", $first{$swimmerevent} - $line[8]);
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
print "champs?	seed\n";

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
    printf "%s	%s	%s	%s	", $result{$sevent}{$date}, $first, $improvemeet{$sevent}{$date}, $improvetotal{$sevent}{$date};
  }
  if ( $legal{$sevent} >=2 ) { 
    printf "yes	%s\n", $best{$sevent};
  }
  else {
    print "\n";
  }
}  
