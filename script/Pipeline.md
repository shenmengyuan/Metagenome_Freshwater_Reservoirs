### Paper

Cabello-Yeves P J, Ghai R, Mehrshad M, et al. Reconstruction of Diverse Verrucomicrobial Genomes from Metagenome Datasets of Freshwater Reservoirs[J]. Front Microbiol, 2017, 8: 2131.

### My scripts

#### Download data

```shell
wget ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/SRR419/SRR4198666/SRR4198666.sra
wget ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/SRR419/SRR4198832/SRR4198832.sra
wget ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/SRR533/SRR5338504/SRR5338504.sra
```

#### Transfer format: sra to fastq

```shell
/home/shenmy/biosoft/sratoolkit/sratoolkit.2.8.2-1-ubuntu64/bin/fastq-dump --split-3  --gzip  -A   Feb2015-12m  SRR4198666.sra
/home/shenmy/biosoft/sratoolkit/sratoolkit.2.8.2-1-ubuntu64/bin/fastq-dump --split-3  --gzip  -A   Feb2015-25m  SRR4198832.sra
/home/shenmy/biosoft/sratoolkit/sratoolkit.2.8.2-1-ubuntu64/bin/fastq-dump --split-3 --gzip -A Jul2016-13m SRR5338504.sra
```

#### FastQC

```shell
~/biosoft/FastQC/current/fastqc Feb2015-12m_1.fastq.gz  -o ~/Freshwater_Reservoirs/work/1_FastQC_Raw_Data  -t  20
~/biosoft/FastQC/current/fastqc Feb2015-12m_2.fastq.gz  -o ~/Freshwater_Reservoirs/work/1_FastQC_Raw_Data  -t  20
~/biosoft/FastQC/current/fastqc Feb2015-25m_1.fastq.gz  -o ~/Freshwater_Reservoirs/work/1_FastQC_Raw_Data  -t  20
~/biosoft/FastQC/current/fastqc Feb2015-25m_2.fastq.gz  -o ~/Freshwater_Reservoirs/work/1_FastQC_Raw_Data  -t  20
~/biosoft/FastQC/current/fastqc Jul2016-13m_1.fastq.gz  -o ~/Freshwater_Reservoirs/work/1_FastQC_Raw_Data  -t  20
~/biosoft/FastQC/current/fastqc Jul2016-13m_2.fastq.gz -o ~/Freshwater_Reservoirs/work/1_FastQC_Raw_Data -t 20
```

#### Assembly

- fq2fa

  ```shell
  #! usr/bin/bash
  set -u
  set -e
  set -o pipefail

  fq2fa=~/biosoft/IDBA/idba/bin/fq2fa
  id=("Feb2015-12m"
      "Feb2015-25m"
      "Jul2016-13m")

  for name in ${id[@]};do
  $fq2fa --merge --filter <(gunzip -c ${name}_1.fastq.gz) <(gunzip -c ${name}_2.fastq.gz) ${name}.fa
  done
  ```

- idba_ud
  ```shell
  #! usr/bin/bash
  set -u
  set -e
  set -o pipefail

  idba_ud=~/biosoft/IDBA/idba/bin/idba_ud
  output=~/Freshwater_Reservoirs/work/2_Assembly

  ### mix assembly
  mkdir ~/Freshwater_Reservoirs/work/2_Assembly/idba_ud
  $idba_ud --read Feb2015-25m.fa --read_level_2 Feb2015-12m.fa --		read_level_3 Jul2016-13m.fa --mink 70 --maxk 100 --step 10 -o 		$output/idba_ud
  ```

- Filter < 10kb contig

  `perl -lne 'if(/>/){$header=$_}else{$seq{$header}=$_;$len=length($_);if($len>=10000){push @{$order{$len}},$header;}}END{foreach $p(sort {$a <=> $b} keys %order){foreach(@{$order{$p}}){print "$_\n$seq{$_}"}}}' contig.fa >contig_filter_10000.fa`

#### Gene prediction

- CDS

  ```shell
  mkdir 3_Gene && cd 3_Gene
  contig=~/Freshwater_Reservoirs/work/2_Assembly/idba/contig_filter_10000.fa
  output=~/Freshwater_Reservoirs/work/3_Gene/gene
  nohup prodigal -a $output.faa -d $output.fna -f gff -o $output.gff -p meta -s $output.stat -i $contig &
  ```

- RNA 

  ```shell
  # tRNAs
  ~/biosoft/tRNAscan-SE-2.0/tRNAscan-SE -B -o ~/Freshwater_Reservoirs/work/3_Gene/tRNA/tRNA.results -f tRNA_secondary_stru -m stat_sum  ~/Freshwater_Reservoirs/work/2_Assembly/idba/contig_filter_10000.fa
  # Status: Phase I: Searching for tRNAs with HMM-enabled Infernal
  # Status: Phase II: Infernal verification of candidate tRNAs detected with first-pass scan
  ## rRNA
  ssu-align -f -n bacteria --dna ~/Freshwater_Reservoirs/work/2_Assembly/idba/contig_filter_10000.fa 16srRNA
  ```

#### Gene annotion

```shell
python emapper.py -i /home/shenmy/Freshwater_Reservoirs/work/3_Gene/gene.faa -o metagene  -m diamond --cpu 20
```

