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

