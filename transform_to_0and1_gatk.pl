#! /usr/bin/perl -w

use warnings;

###transform 1/1, 0/1, 1/0 and 0/0 to 1, hz and 0.

my $input=  $ARGV[0]; #e.g. "REALIGNMENT_PHAGE.raw1.gatk.vcf

my @temp; # array to store 0s and 1s
my @temp2; # array to store the original data so that the (GT:PL:DP:SP:GQ) data is retained

open(LIST,"<$input") || die "cannot find list file!\n";

while(<LIST>){
chomp ($_);

#To print the header
if ($_=~/#CHROM/){
print "$_\n";
}

#if ($_=~/^NC_002516.2||RGP42||PNUK73/){ #old
if ($_!~/^#/){#match any line that isn't a comment
@temp=split('\t',$_);
@temp2=@temp;

	for ($i=9; $i < scalar(@temp); $i++){
		if ($temp[$i]=~/^1:.*/){
		$temp[$i] = 1;
		}
		if ($temp[$i]=~/^0:.*/){
		$temp[$i] = 0;
		}
		if ($temp[$i]=~/^2:.*/){ # gatk tools puts a 2 when there are 3 different types of amino acid
		$temp[$i] = 2;
		}
		if ($temp[$i]=~/\./){ # gatk puts a "." when it's not capable of making a call.  kept just in case.
					#gatk posa . quan no es capac de cridar en algunes mostres i en altres si. me'ls quedo per si de cas. 
		$temp[$i] = 999;
		}
	}

print join("\t", @temp),"\n";

}
}








