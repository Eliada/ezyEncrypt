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
