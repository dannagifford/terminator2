#! /usr/bin/perl -w

use strict;

my $list_samples="/media/data/PROJECTS/Karl_Genomes2_samples.list"; #change
my $mapping_dir="/media/data/PROJECTS/Karl_Genomes2"; #change
my $working_dir="/media/data/PROJECTS/Karl_Genomes2/DE_NOVO";#change

system ("mkdir BLASTN");

# read list of samples

my $WTCHG;
my $sample;
my $command_pe;
my $command_se;
my $command_velveth;
my $command_velvetg;
my $insertmetrics;
my $insertsize;
my $command_blastn;

open(LIST,"<$list_samples") || die "cannot open list input file";
while(<LIST>){
	chomp $_;

	if ($_=~/(.*)\t(.*)/){
	$WTCHG=$1;
	$sample=$2;

#velvet 

	$command_pe= "samtools view -bhf 4 $mapping_dir/$sample/MAPPING/*_pe.bam > $working_dir/$sample\_pe.bam.unmapped";
	`$command_pe`;
	print "$command_pe\n";

	$command_se= "samtools view -bhf 4 $mapping_dir/$sample/MAPPING/*_se.bam > $working_dir/$sample\_se.bam.unmapped";
	`$command_se`;
	print "$command_se\n";
	
	$command_velveth= "/media/data/NGS/programs/velvet_1.2.10/velveth $working_dir/$sample 41 -short -bam $working_dir/$sample\_se.bam.unmapped -shortPaired2 -bam $working_dir/$sample\_pe.bam.unmapped";
	`$command_velveth`;
	print "$command_velveth\n";

	#insertmetrics

			$insertmetrics ="/media/data/PROJECTS/Karl_Genomes2/$sample/MAPPING/$sample\_$WTCHG\.realigned.insertmetrics"; #change

			open (INSERTMETRICS,"<", $insertmetrics);
			while(<INSERTMETRICS>)
			{
				if (/^MEDIAN_INSERT_SIZE/){
					my $l = <INSERTMETRICS>;
					my @l = split "\t", $l; 
					$insertsize=$l[0];
					last;
				}
			}
			close (INSERTMETRICS);


	$command_velvetg= "/media/data/NGS/programs/velvet_1.2.10/velvetg $working_dir/$sample -ins_length2 $insertsize -cov_cutoff 10 -exp_cov auto -read_trkg yes -amos_file yes";
	`$command_velvetg`;
	print "$command_velvetg\n";

#blastn

	$command_blastn="blastn -db /media/data/DATA/nt -query $working_dir/$sample/contigs.fa -evalue 0.001 -num_alignments 0 -out $working_dir/BLASTN/$sample.blastn";
	`$command_blastn`;
	print "$command_blastn\n";

	}
}


close (LIST);


