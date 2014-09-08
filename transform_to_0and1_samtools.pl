#! /usr/bin/perl -w

use warnings;

###transform 1/1, 0/1, 1/0 and 0/0 to 1, hz and 0.

my $input=$ARGV[0]; #e.g. "REALIGNMENT_PHAGE.raw.samtools.vcf"

my @temp; # array to store 0s and 1s
my @temp2; # array to store the original data so that the (GT:PL:DP:SP:GQ) data is retained

open(LIST,"<$input") || die "cannot find list file!\n";

while(<LIST>){
chomp ($_);

#To print the header
if ($_=~/#CHROM/){
print "$_\n";
}

#if ($_=~/^NC_002516.2||RGP42||PNUK73/){#old

if ($_!~/^#/){#match any line that isn't a comment
@temp=split('\t',$_);
@temp2=@temp;

	for ($i=9; $i < scalar(@temp); $i++){
		if ($temp[$i]=~/^1\/1.*/){
		$temp[$i] = 1;
		}
		if ($temp[$i]=~/^1\/0.*/){
		$temp[$i] = "HZ";
		}
		if ($temp[$i]=~/^0\/1.*/){
		$temp[$i] = "HZ";
		}
		if ($temp[$i]=~/^0\/0.*/){
		$temp[$i] = 0;
		}
	}

print join("\t", @temp),"\n";

}
}









