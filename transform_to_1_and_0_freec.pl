#! /usr/bin/perl -w

use warnings;
#use strict;
my $input= $ARGV[0]; #change
open(LIST,"<$input") || die "cannot find list file!\n";


my @files = glob("*_CNVs");
my @samplenames;

foreach my $file (@files){
	my @split = split '_WTCHG_', $file;
	push @samplenames, $split[0];
}


#print "CHROM\tPOS\tPOS\tNUM\tEVENT\t8P0_1_1\t8P0_1_2\t8P0_1_3\t8P0_2_1\t8P0_2_2\t8P0_2_3\t8P0_3_1\t8P0_3_2\t8P0_3_3\tparental1\tparental3\n";#change

my $sampleprint = join("\t",@samplenames);

print "CHROM\tPOS\tPOS\tNUM\tEVENT\t$sampleprint\n";

my @freecuniq;

while(<LIST>){
	chomp ($_);

	@freecuniq=split('\t',$_);

	print "$_";
	for (my $i=0; $i < scalar(@files); $i++){
		open(FILE,"<$files[$i]") || die "cannot find list file!\n";
		my $name="";
		my $switch=0;
		while(<FILE>){
			chomp ($_);
			@fields=split('\t',$_);
			if (($fields[0] eq $freecuniq[0]) && ($fields[1] == $freecuniq[1]) && ($fields[2] == $freecuniq[2])){
				print "\t1";
				$switch=1;
			}
		}
		if ($switch ==0){
			print "\t0";
		}
	}
	close(FILE);
	print "\n";

}

close(LIST);
