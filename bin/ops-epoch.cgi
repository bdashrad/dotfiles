#!/usr/bin/env perl
#
# Name:     ops-epoch
#
# Purpose:  Calculate and display the combined days each ops member has been using *nix for.
#
# Comments: I got curious one day to find out what our combined unix age would be.  The rules are:
#           1)  Date of first bare metal install.
#           2)  If exact day is unknown use the first of the month.
#           3)  If month is unknown then the release date of the distro's version is used.
#           4)  If year or distro is not known then gtfo as you obviously are n00b or need to go
#               back to the nursing home!!
#
#           Why perl?  This script is in no way associated with the hosting code base so doesn't
#           need to comply with the 'Ruby' rule.  This is also written to purpose.  The purpose is
#           to be obsurd, frivolous and pointless yet unmistakenly purely geek by adhering to key
#           programming axioms.
#
# Author/s: Phil.Ingram@acquia.com
#
# License:  Copyright (C) Acquia, Inc.
#


use DateTime;
use POSIX;


# Start Date
#
%ops = (
  "Brad Clark", "1998-07-01", # Mandrake 5.2 - http://en.wikipedia.org/wiki/Mandriva_Linux
  "Brian Deitte", "1996-09-01", # S.u.S.E. Linux- https://en.wikipedia.org/wiki/SUSE_Linux
  "Chris Nellis", "1999-11-15", # Corel Linux 1.0 - https://en.wikipedia.org/wiki/Corel_Linux
  "Tom Norris", "1997-06-11", # Slackware 3.3 - http://en.wikipedia.org/wiki/Slackware
);


# Subs
#
sub date_to_seconds {
  my ($date) = @_;
  my ($year, $month, $day) = ($date=~/^(\d{4,})-(\d{2,})-(\d{2,})$/);
  my $datetime = DateTime->new(year=>$year, month=>$month, day=>$day);
  my $seconds = $datetime->epoch;
  return($seconds);
};

sub seconds_to_date {
  my ($seconds) = @_;
  my ($sec, $min, $hour, $day, $month, $year) = (gmtime($seconds))[0, 1, 2, 3, 4, 5];
  $month++;
  $year += 1900;
  if ( $sec < 10 ) { $sec = "0$sec"; };
  if ( $min < 10 ) { $min = "0$min"; };
  if ( $hour < 10 ) { $hour = "0$hour"; };
  if ( $day < 10 ) { $day = "0$day"; };
  if ( $month < 10 ) { $month = "0$month"; };
  my $date = "$year-$month-$day $hour:$min:$sec";
  return ($date);
}

sub seconds_to_fulldate {
  my ($seconds) = @_;
  my $years = floor($seconds / 60 / 60 / 24 / 365);
  my $seconds = $seconds - ($years * 365 * 24 * 60 * 60);
  my $months = floor($seconds / 60 / 60 / 24 / 30.416);
  my $seconds = $seconds - ($months * 30.416 * 24 * 60 * 60);
  my $days = floor($seconds / 60 / 60 / 24);
  my $seconds = $seconds - ($days * 24 * 60 * 60);
  my $hours = floor($seconds / 60 / 60);
  my $seconds = $seconds - ($hours * 60 * 60);
  my $minutes = floor($seconds / 60);
  my $seconds = $seconds - ($minutes * 60);
  my $seconds = floor($seconds);
  my $string = "$years years, $months months, $days days, $hours hours, $minutes minutes and $seconds seconds.";
  return($string);
}

sub seconds_since_now {
  my ($op_epoch) = @_;
  my $seconds = time() - $op_epoch;
  return ($seconds);
};


# Main Page
#

print <<END;
Content-type: text/html

<html>
  <head>
    <title>
      Ops Unix Clock
    </title>
    <meta http-equiv="refresh" content="1"/>
  </head>
  <body>
    <!-- $OPSROOT/lib/perl/acquia.png must reside in the root of the docroot -->
    <img src='/acquia.png'>
    <tt>
      <table>
END

foreach $op (sort keys %ops) {
  my $op_epoch = date_to_seconds($ops{$op});
  my $seconds = seconds_since_now($op_epoch);
  print "        <tr>\n";
  print "          <td>$op</td> <td>($ops{$op})</td> <td>$seconds</td>\n";
  print "        </tr>\n";
  $seconds_total += $seconds;
};

$seconds_from_epoch = $seconds_total - time();
$experience_counter = seconds_to_fulldate($seconds_total);
$combined_unix_time = seconds_to_date($seconds_total);

print <<END;
      </table>

      <p>Ops Seconds From Epoch: $seconds_total</p>
      <p>Ops Experience Counter: $experience_counter</p>
      <p>Ops Combined Unix Time: $combined_unix_time</font></p>

    </tt>
  </body>
</html>
END

#
# EOF
