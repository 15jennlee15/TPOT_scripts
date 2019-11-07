#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt). And 
# runs the job_fmriprep.sh file for 
# each subject. It saves the ouput
# and error files in their specified
# directories.
#
# Set your directories

group=adapt_lab
group_dir=/projects/adapt_lab/shared
#container=containers/poldracklab_fmriprep_latest-2018-09-05.img
container=containers/fmriprep-latest-2018-09-05.simg
study="TPOT"
task=“affect”

# Set subject list
SUBJLIST=`cat subject_list.txt`

# 
for SUBJ in $SUBJLIST; do

#SUBID=`echo $SUBJ|awk '{print $1}' FS=","`
#SESSID=`echo $SUBJ|awk '{print $2}' FS=","`
	
sbatch --export subid=${SUBJ},group_dir=${group_dir},study=${study},container=${container},task=${task} --job-name fmriprep_"${SUBJ}" --partition=long -A "${group}" --cpus-per-task=16 --mem-per-cpu=75G --time=2-20:00:00 -o "${group_dir}"/"${study}"/TPOT_Scripts/fMRI/ppc/output/"${task}"_output/"${SUBJ}"_fmriprep_output.txt -e "${group_dir}"/"${study}"/TPOT_Scripts/fMRI/ppc/output/"${task}"_output/"${SUBJ}"_fmriprep_error.txt job_fmripreptask.sh
	
done