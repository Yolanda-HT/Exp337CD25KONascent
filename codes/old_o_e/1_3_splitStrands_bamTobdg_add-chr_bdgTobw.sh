#!/bin/bash
#PBS -l mem=8gb
#PBS -t 1-24

##### Load modules
module load samtools
module load python
module load ucsc_tools

######################################## Dupr ########################################
INDIR=/gpfs/group/pipkin/Exp337/srt_flt_bam/dupr
cd $INDIR

#---- Names
bam_name_srt_dupr_flt=337-${PBS_ARRAYID}_srt_dupr_flt.bam

bam_name_srt_dupr_flt_pos=337-${PBS_ARRAYID}_srt_dupr_flt_pos.bam
bam_name_srt_dupr_flt_neg=337-${PBS_ARRAYID}_srt_dupr_flt_neg.bam

bdg_name_srt_dupr_flt_pos=337-${PBS_ARRAYID}_srt_dupr_flt_pos.bdg
bdg_name_srt_dupr_flt_neg=337-${PBS_ARRAYID}_srt_dupr_flt_neg.bdg

bdg_name_srt_dupr_flt_pos_chr=337-${PBS_ARRAYID}_srt_dupr_flt_pos_chr.bdg
bdg_name_srt_dupr_flt_neg_chr=337-${PBS_ARRAYID}_srt_dupr_flt_neg_chr.bdg

bdg_name_srt_dupr_flt_pos_chr_srt=337-${PBS_ARRAYID}_srt_dupr_flt_pos_chr_srt.bdg
bdg_name_srt_dupr_flt_neg_chr_srt=337-${PBS_ARRAYID}_srt_dupr_flt_neg_chr_srt.bdg

bw_name_srt_dupr_flt_pos_chr_srt=337-${PBS_ARRAYID}_dupr_pos.bw
bw_name_srt_dupr_flt_neg_chr_srt=337-${PBS_ARRAYID}_dupr_neg.bw

#---- Filter positive / negative strand
samtools view -F 0x10 -h -b $bam_name_srt_dupr_flt > $bam_name_srt_dupr_flt_pos
samtools view -f 0x10 -h -b $bam_name_srt_dupr_flt > $bam_name_srt_dupr_flt_neg
samtools index $bam_name_srt_dupr_flt_pos
samtools index $bam_name_srt_dupr_flt_neg

#---- Bam to Bdg
bamCoverage --bam $bam_name_srt_dupr_flt_pos -o $bdg_name_srt_dupr_flt_pos  --binSize 10 --normalizeUsing RPGC --effectiveGenomeSize 2652783500 --extendReads --outFileFormat bedgraph
bamCoverage --bam $bam_name_srt_dupr_flt_neg -o $bdg_name_srt_dupr_flt_neg  --binSize 10 --normalizeUsing RPGC --effectiveGenomeSize 2652783500 --extendReads --outFileFormat bedgraph

#---- Bdg add chr
awk '{print "chr"$1 "\t" $2 "\t" $3 "\t" $4}' $bdg_name_srt_dupr_flt_pos > $bdg_name_srt_dupr_flt_pos_chr
awk '{print "chr"$1 "\t" $2 "\t" $3 "\t" $4}' $bdg_name_srt_dupr_flt_neg > $bdg_name_srt_dupr_flt_neg_chr

#---- Sort bdg
LC_COLLATE=C sort -k1,1 -k2,2n $bdg_name_srt_dupr_flt_pos_chr > $bdg_name_srt_dupr_flt_pos_chr_srt
LC_COLLATE=C sort -k1,1 -k2,2n $bdg_name_srt_dupr_flt_neg_chr > $bdg_name_srt_dupr_flt_neg_chr_srt

#---- Bdg to bw
mm10_chrom_sizes=/gpfs/group/pipkin/Exp337/srt_flt_bam
bedGraphToBigWig $bdg_name_srt_dupr_flt_pos_chr_srt $mm10_chrom_sizes $bw_name_srt_dupr_flt_pos_chr_srt
bedGraphToBigWig $bdg_name_srt_dupr_flt_neg_chr_srt $mm10_chrom_sizes $bw_name_srt_dupr_flt_neg_chr_srt


######################################## Non Dupr #######################################
INDIR=/gpfs/group/pipkin/Exp337/srt_flt_bam/non_dupr
cd $INDIR

#---- Names
bam_name_srt_flt=337-${PBS_ARRAYID}_srt_flt.bam

bam_name_srt_flt_pos=337-${PBS_ARRAYID}_srt_flt_pos.bam
bam_name_srt_flt_neg=337-${PBS_ARRAYID}_srt_flt_neg.bam

bdg_name_srt_flt_pos=337-${PBS_ARRAYID}_srt_flt_pos.bdg
bdg_name_srt_flt_neg=337-${PBS_ARRAYID}_srt_flt_neg.bdg

bdg_name_srt_flt_pos_chr=337-${PBS_ARRAYID}_srt_flt_pos_chr.bdg
bdg_name_srt_flt_neg_chr=337-${PBS_ARRAYID}_srt_flt_neg_chr.bdg

bdg_name_srt_flt_pos_chr_srt=337-${PBS_ARRAYID}_srt_flt_pos_chr_srt.bdg
bdg_name_srt_flt_neg_chr_srt=337-${PBS_ARRAYID}_srt_flt_neg_chr_srt.bdg

bw_name_srt_flt_pos_chr_srt=337-${PBS_ARRAYID}_pos.bw
bw_name_srt_flt_neg_chr_srt=337-${PBS_ARRAYID}_neg.bw

#---- Filter positive / negative strand
samtools view -F 0x10 -h -b $bam_name_srt_flt > $bam_name_srt_flt_pos
samtools view -f 0x10 -h -b $bam_name_srt_flt > $bam_name_srt_flt_neg

#---- Bam to Bdg
bamCoverage --bam $bam_name_srt_flt_pos -o $bdg_name_srt_flt_pos  --binSize 10 --normalizeUsing RPGC --effectiveGenomeSize 2652783500 --extendReads --outFileFormat bedgraph
bamCoverage --bam $bam_name_srt_flt_neg -o $bdg_name_srt_flt_neg  --binSize 10 --normalizeUsing RPGC --effectiveGenomeSize 2652783500 --extendReads --outFileFormat bedgraph

#---- Bdg add chr
awk '{print "chr"$1 "\t" $2 "\t" $3 "\t" $4}' $bdg_name_srt_flt_pos > $bdg_name_srt_flt_pos_chr
awk '{print "chr"$1 "\t" $2 "\t" $3 "\t" $4}' $bdg_name_srt_flt_neg > $bdg_name_srt_flt_neg_chr

#---- Sort bdg
LC_COLLATE=C sort -k1,1 -k2,2n $bdg_name_srt_flt_pos_chr > $bdg_name_srt_flt_pos_chr_srt
LC_COLLATE=C sort -k1,1 -k2,2n $bdg_name_srt_flt_neg_chr > $bdg_name_srt_flt_neg_chr_srt

#---- Bdg to bw
mm10_chrom_sizes=/gpfs/group/pipkin/Exp337/srt_flt_bam
bedGraphToBigWig $bdg_name_srt_flt_pos_chr_srt $mm10_chrom_sizes $bw_name_srt_flt_pos_chr_srt
bedGraphToBigWig $bdg_name_srt_flt_neg_chr_srt $mm10_chrom_sizes $bw_name_srt_flt_neg_chr_srt
