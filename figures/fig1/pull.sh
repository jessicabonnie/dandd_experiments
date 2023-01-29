#!/bin/bash

set -ex

scp rockfish:/home/blangme2/scr16_blangme2/jessica/dandd/RECOMB/ecoli/ksweep_kmc.csv \
    ecoli_ksweep_kmc.csv
scp rockfish:/home/blangme2/scr16_blangme2/jessica/dandd/RECOMB/salmonella/ksweep_kmc.csv \
    salmonella_ksweep_kmc.csv
scp rockfish:/home/blangme2/scr16_blangme2/jessica/dandd/RECOMB/human/ksweep_kmc.csv \
    human_ksweep_kmc.csv
