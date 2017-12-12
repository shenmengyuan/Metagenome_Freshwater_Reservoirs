#! usr/bin/bash
set -u
set -e
set -o pipefail

idba_ud=~/biosoft/IDBA/idba/bin/idba_ud
output=~/Freshwater_Reservoirs/work/2_Assembly

id=("Feb2015-12m" 
    "Feb2015-25m"
    "Jul2016-13m")

for name in ${id[@]};do
mkdir ~/Freshwater_Reservoirs/work/2_Assembly/$name
$idba_ud -r ${name}.fa --mink 70 --maxk 100 --step 10 -o $output/$name
done

