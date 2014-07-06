#! /usr/bin/perl

use strict;
use warnings;
use File::Basename;
use lib dirname(__FILE__); #garante que o programa funcione quando utilizado com atalhos
use crypts::Rot;

my $numArgs = scalar @ARGV;

if ($numArgs != 0) {
	if ($ARGV[0] eq 'rot') {
		rot ();
	}
}
