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
group_dir=/projects/adapt_lab/shared/
#container=BIDS/SingularityContainers/poldracklab_fmriprep_latest-2017-07-20-dd77d76c5e14.img
container=containers/fmriprep-1.2.4.simg
study="TPOT"

# Set subject list
SUBJLIST=`cat subject_list_2.txt`

# 
for SUBJ in $SUBJLIST; do

#SUBID=`echo $SUBJ|awk '{print $1}' FS=","`
#SESSID=`echo $SUBJ|awk '{print $2}' FS=","`
	
sbatch --export subid=${SUBJ},group_dir=${group_dir},study=${study},container=${container} --job-name fmriprep --partition=short -A "${group}" --time=0-20:00:00 --mem=100G -o "${group_dir}"/"${study}"/TPOT_scripts/fMRI/ppc/output/"${SUBJ}"_fmriprep_output.txt -e "${group_dir}"/"${study}"/TPOT_scripts/fMRI/ppc/output/"${SUBJ}"_fmriprep_error.txt job_fmripreptask.sh
	
done