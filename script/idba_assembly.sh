#! usr/bin/bash
set -u
set -e
set -o pipefail

idba_ud=~/biosoft/IDBA/idba/bin/idba_ud
output=~/Freshwater_Reservoirs/work/2_Assembly
### single assembly
#id=("Feb2015-12m" 
#    "Feb2015-25m"
#    "Jul2016-13m")

#for name in ${id[@]};do
#mkdir ~/Freshwater_Reservoirs/work/2_Assembly/$name
#$idba_ud -r ${name}.fa --mink 70 --maxk 100 --step 10 -o $output/$name
#done

### mix assembly
mkdir ~/Freshwater_Reservoirs/work/2_Assembly/idba_ud
$idba_ud --read Feb2015-25m.fa --read_level_2 Feb2015-12m.fa --read_level_3 Jul2016-13m.fa --mink 70 --maxk 100 --step 10 -o $output/idba_ud

