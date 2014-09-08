#! /usr/bin/perl -w

use strict;
use Getopt::Long;

my $project='';
my $refgenome = '/media/data/DATA/NC_002516.2.fa'; # option variable with default value
GetOptions ('project=s' => \$project, 'ref=s' => \$refgenome) or die("Error in arguments\n");
my $list_samples="/media/data/PROJECTS/$project\_samples.list"; #change


# read list of samples

open(LIST,"<$list_samples") || die "cannot open list input file $list_samples";

my $WTCHG;
my $sample;
my $command_unzip_forward;
my $command_unzip_reverse;
my $command_zip_forward;
my $command_zip_reverse;

while(<LIST>){
	chomp;
	if ($_=~/(.*)\t(.*)/){
	$WTCHG=$1;
	$sample=$2;

	#descomprimimim els fastq
	$command_unzip_forward= "gunzip /media/data/PROJECTS/$project/$sample/FASTQ/$WTCHG\_1.fastq.gz";#change
	`$command_unzip_forward`;

	$command_unzip_reverse="gunzip /media/data/PROJECTS/$project/$sample/FASTQ/$WTCHG\_2.fastq.gz";#change
	`$command_unzip_reverse`;

	#executem breseq

	system("breseq -r $refgenome /media/data/PROJECTS/$project/$sample/FASTQ/$WTCHG\_1.fastq /media/data/PROJECTS/$project/$sample/FASTQ/$WTCHG\_2.fastq -p -n $sample"); #-r REF, change when necessary

	#esborrem les carpetes no necessaries de breseq i copiem i cambien de nom la carpeta d'output que es la que ens interessa.

	system("rm -r 01_sequence_conversion");
	system("rm -r 02_reference_alignment");
	system("rm -r 03_candidate_junctions");
	system("rm -r 04_candidate_junction_alignment");
	system("rm -r 05_alignment_correction");
	system("rm -r 06_bam");
	system("rm -r 07_error_calibration");
	system("rm -r 08_mutation_identification");
	system("rm -r data");

	system ("mv output output_$sample");
	system ("mv output_$sample/output.gd output_$sample/$sample\_out.gd");

	#tornem a comprimir els fastq

	$command_zip_forward= "gzip /media/data/PROJECTS/$project/$sample/FASTQ/$WTCHG\_1.fastq";#change
	`$command_zip_forward`;

	$command_zip_reverse="gzip /media/data/PROJECTS/$project/$sample/FASTQ/$WTCHG\_2.fastq";#change
	`$command_zip_reverse`;

	}
}

close (LIST);
