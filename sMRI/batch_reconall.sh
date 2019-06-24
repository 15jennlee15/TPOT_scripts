#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt). And 
# runs the job_reconall.sh file for 
# each subject. It saves the ouput
# and error files in their specified
# directories.
#
# Set your study
STUDY=/projects/adapt_lab/shared/TPOT

# Set subject list
SUBJLIST=`cat subject_list.txt`
#SUBJLIST=`cat test.txt`

# 
for SUBJ in $SUBJLIST
do
 sbatch --export SUBID=${SUBJ} --job-name reconall_"${SUBJ}" --partition=short --mem-per-cpu=8G --time=24:00:00 --cpus-per-task=1 -o "${STUDY}"/TPOT_Scripts/sMRI/output/"${SUBJ}"_wave2_reconall_output.txt -e "${STUDY}"/TPOT_Scripts/sMRI/output/"${SUBJ}"_wave2_reconall_error.txt job_reconall.sh
done