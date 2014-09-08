#! /usr/bin/perl -w
#Description: adds the gene names and COG data into the snpEff table from the ptt file
#Syntax: mapping_genes -v variants_snpeff.vcf -genes species.ptt
#outputs to standard out
#TODO: make it work for other genomes/chromosomes besides NC_002516 aka PA01
use warnings;
use Getopt::Long;
my $variantfile=''; # option variable without default value
my $genefile = '/media/data/DATA/NC_002516.ptt'; # option variable with default value
GetOptions ('variants=s' => \$variantfile, 'genes=s' => \$genefile) or die("Error in arguments\n");

# PARSE GFF FILE
open(GENES,"<$genefile") || die "Cannot find genes file! Please check path and filename\n";

my @genes;
my $i=0;

while(<GENES>){
chomp ($_);
##MAKE WORKING FOR PA4280.1 PA4280.2 etc.
	if ($_=~/(\d+)\.\.(\d+)\s+.\s+\d+\s+\d+\s+(.*)\s+(PA\d+\.?\d+?).*\s+(-|COG\w+)\s+(.*)/){
	$genes[$i][0]=$1; #GENE_START
	$genes[$i][1]=$2; #GENE_END
	$genes[$i][2]=$3; #GENE (e.g. clpA)
	$genes[$i][3]=$4; #LOCUS_TAG (e.g. PA2620)
	$genes[$i][4]=$5; #COG
	$genes[$i][5]=$6; #FUNCTION
	$i++;
	}

}

close(GENES);	

my $n=$i;

# PARSE SNPEFF FILE
open(SNPEFF,"<$variantfile") or die "Cannot open variants file! Please check --variants option is correct.\n";
chomp(my $snpeffheader=<SNPEFF>);
my @header=split('\t',$snpeffheader);
splice @header, 6, 0,'GENE_START','GENE_END','GENE','LOCUS_TAG','CHANGE','COG','FUNCTION';
print join("\t",@header)."\n";
while(<SNPEFF>){
chomp ($_);
my $snpeffline=$_;
my $snppostn;
	my @snpsplit=split("\t",$snpeffline);
	if ($snpsplit[1]=~/NC_002516.2/){ #(\d+) is the position of the SNP stored in $1
	$snppostn=$snpsplit[2];
	my $snp="-";
	if ($snpsplit[8]=~/([A-Z-]+[0-9]+[A-Z-]+|FRAME_SHIFT|STOP_GAINED|SILENT|STOP_LOST)/){
	$snp=$1;
	}
        my $switch=0;
		my $t=0;
		while ($t < $n){ # Can't handle overlapping genes! break on first match
			if (($genes[$t][0] <= $snppostn) & ($genes[$t][1] >= $snppostn)){ 
			splice @snpsplit, 6, 0, $genes[$t][0], $genes[$t][1], $genes[$t][2], $genes[$t][3], $snp, $genes[$t][4], $genes[$t][5];
			$switch=1;
			last;
			}
			elsif (($genes[$t][1] <= $snppostn) & ($genes[($t+1)][0] >= $snppostn)){ 
			splice @snpsplit, 6, 0,"-","-","-","between $genes[$t][3]-$genes[($t+1)][3]","intergenic","-","-";
			$switch=1;
			last;
			}
		$t++;
		}
		if($switch==0){
		splice @snpsplit, 6, 0,"-","-","-","-","intergenic","-","-";
		}
	print join("\t",@snpsplit)."\n";
	
	}elsif ($snpsplit[1]=~/RGP42/){
		my @snpsplit=split("\t",$snpeffline);
		splice @snpsplit, 6, 0, "-", "-", "-", "-", "-", "-","-";
		print join("\t",@snpsplit)."\n";
}

}
close(SNPEFF);
