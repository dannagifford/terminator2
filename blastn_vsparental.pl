#! /usr/bin/perl -w

use strict;

my $list_samples="/home/macarenatollriera/data/PROJECTS/Lorenzo_Genomes_samples.list"; #change
my $working_dir="/home/macarenatollriera/data/PROJECTS/Lorenzo_Genomes/DE_NOVO";#change

system ("mkdir M30125.1_CP002496.1");#change

# read list of samples

my $WTCHG;
my $sample;
my $command_blastn;
my $command_makeblastdb;

open(LIST,"<$list_samples") || die "cannot open list input file";
while(<LIST>){
	chomp $_;

	if ($_=~/(.*)\t(.*)/){
	$WTCHG=$1;
	$sample=$2;


#blastn
	$command_makeblastdb="makeblastdb -in /home/macarenatollriera/data/PROJECTS/Lorenzo_Genomes/DE_NOVO/PAO1_WT/contigs.fa -dbtype nucl"; #change
	`$command_makeblastdb`;
	print "$command_makeblastdb\n";

	$command_blastn="blastn -db /home/macarenatollriera/data/PROJECTS/Lorenzo_Genomes/DE_NOVO/PAO1_WT/contigs.fa -query $working_dir/$sample/contigs.fa -evalue 0.001 -out M30125.1_CP002496.1/$sample.blastn"; #change
	`$command_blastn`;
	print "$command_blastn\n";

	}
}


close (LIST);


