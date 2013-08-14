#!/usr/bin/perl

use strict;

# Verify that we're running as root
unless ($> == 0 || $< == 0) { die "Error: $0 must be run as root" }


if ($ARGV[0] eq "--use_bin")
{
#  $bitfile = $ARGV[1];
}

system("pushd ../scone ; ./scone -r rtables/rtable &");
system("pushd ../gui ; ./router.sh");
`popd`;
`sudo killall scone`;

exit 0;

