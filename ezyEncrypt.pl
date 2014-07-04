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


my $numArgs = scalar @ARGV;

if ($numArgs != 0) {
	if ($ARGV[0] eq 'rot13') {
		rot13 ();
	}
}


sub rot13 
{
	# String de entrada a ser encriptada
	my $in = Clipboard->paste;

	# Remove caracteres especiais
	$in =~ s/[\s!"#\$%&'()\*+,-\/:;<=>?@\[\\\[\^_`{|}~]//g;

	# String de saida encriptada
	my $out;

	# Tamanho da string a ser encriptada
	my $in_length = length ($in);

	# Transforma todo o texto em caixa baixa (lowercase)
	$in = lc ($in);

	for (my $i = 0; $i < $in_length; $i++) {

		my $char = substr ($in, $i, 1);
	
		for (my $j = 0; $j < 13; $j++) {
			if ($char eq 'z') {
				$char = 'a';
			} 
			elsif ($char == 9){
				$char = 0;
			} 
			else {
				$char++;
			}
		}
		$out = $out.$char;
	}
	Clipboard->copy($out);
}
