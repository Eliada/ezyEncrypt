#! /usr/bin/perl

use strict;
use warnings;
use Clipboard;

if ('Clipboard::Xclip' eq $Clipboard::driver) {
  no warnings 'redefine';
  *Clipboard::Xclip::all_selections = sub {  
    qw(clipboard primary buffer secondary)
  };
}
my $a = Clipboard->paste;
  
Clipboard->copy('rot13 here' . $a);
