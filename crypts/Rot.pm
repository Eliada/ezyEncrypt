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

	# Cifra o clipboard
	for (my $i = 0; $i < $in_length; $i++) {

		my $char = substr ($in, $i, 1);
	
		for (my $j = 0; $j < $num_rots; $j++) {
			if ($char eq 'z') {
				$char = 'a';
			} 
			elsif ($char eq '9'){
				$char = 0;
			} 
			else {
				$char++;
			}
		}
		$out = $out.$char;
	}

	# Devolve o conteúdo do clipboard devolta para o clipboard, agora cifrado
	Clipboard->copy($out);
}

1;
