#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list_sam.txt) in the same
# folder and will run bedpostx_diff.sh
# for each subject in that list.

# Set your study
STUDY=/projects/adapt_lab/shared/TPOT

# Set subject list
SUBJLIST=`cat subject_list.txt`
#SUBJLIST=`cat alignment.txt`

for SUBID in $SUBJLIST
 do sbatch --export all,subid=${SUBID} --job-name bedpostx_"${SUBID}" --partition=long --time=03-00:00:00 --nodes=1 -o "${STUDY}"/TPOT_Scripts/dMRI/preproc/output/"${SUBID}"_bedpostx_output.txt -A adapt_lab -e "${STUDY}"/TPOT_Scripts/dMRI/preproc/output/"${SUBID}"_bedpostx_error.txt bedpostx_diff.sh
done

