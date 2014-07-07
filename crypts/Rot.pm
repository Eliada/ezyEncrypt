package crypts::Rot;

use strict;
use warnings;
use Clipboard;
use File::Basename;
use Exporter;

our @ISA = qw (Exporter);

our @EXPORT = qw (rot);

if ('Clipboard::Xclip' eq $Clipboard::driver) {
	no warnings 'redefine';
	*Clipboard::Xclip::all_selections = sub {  
		qw(clipboard primary buffer secondary)
	};
}

sub rot
{
	# Abre o arquivo de configuração
	my $dirname = dirname (__FILE__);
	open (my $config_file, '<', $dirname."/..".'/ezyConfig')
		or die "Nao foi possivel abrir o arquivo de configuracao para o ROT";
	
	# Número de rotações que deve ser feita, por default esse valor é 13
	my $num_rots;
	# Lê o arquivo de configuração e busca pelo numero de rotações
	while (<$config_file>) {
		if (m/#ROT/) {
			my $next_line = <$config_file>;
			$num_rots = $next_line =~ s/[n][=]//r;
		}
		last;
	}
	# Fecha o arquivo de configuração
	close ($config_file);
	
	# String de entrada a ser cifrada
	my $in = Clipboard->paste();

	# Remove caracteres especiais
	$in =~ s/[\s!"#\$%&'()\*+,-\/:;<=>?@\[\\\[\^_`{|}~]//g;

	$in =~ s/[\xc3][\xa0]/a/g; #à
	$in =~ s/[\xc3][\xa1]/a/g; #á
	$in =~ s/[\xc3][\xa2]/a/g; #â
	$in =~ s/[\xc3][\xa3]/a/g; #ã
	$in =~ s/[\xc3][\xa4]/a/g; #ä
	$in =~ s/[\xc3][\xa5]/a/g; #ºa

	$in =~ s/[\xc3][\xa6]//g; #ae

	$in =~ s/[\xc3][\xa7]/c/g; #ç

	$in =~ s/[\xc3][\xa8]/e/g; #è
	$in =~ s/[\xc3][\xa9]/e/g; #é
	$in =~ s/[\xc3][\xaa]/e/g; #ê
	$in =~ s/[\xc3][\xab]/e/g; #ë

	$in =~ s/[\xc3][\xac]/i/g; #ì
	$in =~ s/[\xc3][\xad]/i/g; #í
	$in =~ s/[\xc3][\xae]/i/g; #î
	$in =~ s/[\xc3][\xaf]/i/g; #ï

	$in =~ s/[\xc3][\xb2]/o/g; #ò
	$in =~ s/[\xc3][\xb3]/o/g; #ó
	$in =~ s/[\xc3][\xb4]/o/g; #ô
	$in =~ s/[\xc3][\xb5]/o/g; #õ
	$in =~ s/[\xc3][\xb6]/o/g; #ö

	$in =~ s/[\xc3][\xb9]/u/g; #ú
	$in =~ s/[\xc3][\xba]/u/g; #ù
	$in =~ s/[\xc3][\xbb]/u/g; #û
	$in =~ s/[\xc3][\xbc]/u/g; #ü

	# String de saida cifrada
	my $out;

	# Tamanho da string a ser encriptada
	my $in_length = length ($in);

	# Transforma todo o texto em caixa baixa (lowercase)
	$in = lc ($in);

	# Se o processo é de cifrar(e), ou se o processo é de decifrar(d)
	my $process = $_[0];

	# Define o valor da variáveis dependendo do processo
	my $minus_or_plus_one;
	my $aorz;
	my $_aorz;
	my $zeroornine;
	my $_zeroornine;

	if ($process eq 'e') {
		$minus_or_plus_one = +1;
		$aorz = 122;
		$_aorz = 97;
		$zeroornine = 9;
		$_zeroornine = 0;
	}
	elsif ($process eq 'd') {
		$minus_or_plus_one = -1;
		$aorz = 97;
		$_aorz = 122;
		$zeroornine = 0;
		$_zeroornine = 9;
	}
	
	# Cifra o clipboard
	for (my $i = 0; $i < $in_length; $i++) {

		my $char = substr ($in, $i, 1);
		my $chari = ord ($char);

		for (my $j = 0; $j < $num_rots; $j++) {
			if ($chari == $aorz) {
				$chari = $_aorz;
			} 
			elsif ($chari == $zeroornine){
				$chari = $_zeroornine;
			} 
			else {
				$chari += $minus_or_plus_one;
			}
		}

		$char = chr ($chari);
		$out .= $char;
	}

	# Devolve o conteúdo do clipboard devolta para o clipboard, agora cifrado
	Clipboard->copy($out);
}

1;
