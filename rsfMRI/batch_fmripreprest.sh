#/bin/bash
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
#container=BIDS/SingularityContainers/poldracklab_fmriprep_latest-2017-07-20-dd77d76c5e14.img
container=containers/fmriprep-1.4.1.simg
study="TPOT"
task="rest"

# Set subject list
SUBJLIST=`cat subject_list.txt`

mkdir "${group_dir}"/"${study}"/TPOT_Scripts/rsfMRI/output/"${task}"_output/

# 
for SUBJ in $SUBJLIST; do

#SUBID=`echo $SUBJ|awk '{print $1}' FS=","`
#SESSID=`echo $SUBJ|awk '{print $2}' FS=","
	
sbatch --export ALL,subid=${SUBJ},group_dir=${group_dir},study=${study},container=${container},task=${task} --job-name fmripreprest_"${SUBJ}" -A "${group}" --partition=short --time=24:00:00 --cpus-per-task=16 --mem-per-cpu=4G -o "${group_dir}"/"${study}"/TPOT_Scripts/rsfMRI/output/"${task}"_output/"${SUBJ}"_fmripreprest_output.txt -e "${group_dir}"/"${study}"/TPOT_Scripts/rsfMRI/output/"${task}"_output/"${SUBJ}"_fmripreprest_error.txt job_fmripreprest.sh

done
