#!/bin/bash

set -ex

head -n 1 ecoli_ksweep_kmc.csv \
    | awk -v FS=',' -v OFS=',' '{print "species",$1,$2,$3,$4}' \
	  > combined_ksweep_kmc.csv

for i in ecoli salmonella human ; do
    awk -v FS=',' -v OFS=',' "\$1 == 10 || \$1 == 12 {print \"${i}\",\$1,\$2,\$3,\$4}" "${i}_ksweep_kmc.csv" \
	>> combined_ksweep_kmc.csv
done
