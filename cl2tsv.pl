#!/usr/bin/perl

$ABC=<<EOF
- Name: 12 to 39
- Age: 64/65
- swimmer gender: 66
- event gender: 67
- distance: 69-71
- event: 72
  - 1 = free
  - 2 = back
  - 3 = breast
  - 4 = fly
  - 5 = im
  - 6 = free relay
  - 7 = medley relay
- event number: 74-75
- age group: 76-79
  - e.g. 1314, or 15OV, or UN06 or 0708
- event date: 80-87
- result time (final): 117-124
  - DQ / NS / DNF
EOF
;

@events = (
  "error", # no 0 event
  "free",
  "back",
  "breast",
  "fly",
  "im",
  "free relay",
  "medley relay",
);

print "name	age	gender	distance	event	age-group	result\n";
while ( $line = <> ) {
  if ($line =~ /^D0/) {
    chomp $line;
    $name = substr($line, 11, 27);
    $name =~ s/^\s+|\s+$//g;
    $age = substr($line,63,2);
    $age =~ s/^\s+|\s+$//g;
    $gender = substr($line,66,1);
    $distance = substr($line,68,3);
    $distance =~ s/^\s+|\s+$//g;
    $event = $events[substr($line,71,1)];
    $age_group = substr($line,76,4);
    $month = substr($line,80,2);
    $day = substr($line,82,2);
    $year = substr($line,84,4);
    $date = "$year/$month/$day";
    $result = substr($line,115,8);
    $result =~ s/^\s+|\s+$//g;
    if ($result =~ /([0-9]+):([0-9.]+)/) {
      $seconds = $1*60 + $2;
    } else {
      $seconds = $result;
    }
    print "$name	$age	$gender	$distance	$event	$age_group	$date	$result	$seconds\n";
  }
}
