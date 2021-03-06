#!/bin/bash
#
# This script runs fmriprep on subjects located in the 
# BIDS directory and saves ppc-ed output and motion confounds
# in the derivatives folder.

# Set bids directories
bids_dir="${group_dir}"/"${study}"/bids_data
derivatives="${bids_dir}"/derivatives
working_dir="${derivatives}"/working_bids_fmripreprest_test/
image="${group_dir}"/"${container}"

echo -e "\nFmriprep on $subid"
echo -e "\nContainer: $image"
echo -e "\nSubject directory: $bids_dir"

# Load packages
module load singularity

# Create working directory
mkdir -p $working_dir

# Run container using singularity
cd $bids_dir

#Source task list
task="rest"

echo -e "\nStarting on: $task"
echo -e "\n"

export FS_LICENSE=/projects/adapt_lab/shared/TPOT/TPOT_Scripts/rsfMRI/license.txt




FMRIPREP_OPTS="--output-spaces T1w MNI152NLin2009cAsym fsaverage5 fsnative --cifti-output --use-aroma --write-graph"

singularity run --bind "${group_dir}":"${group_dir}" ${image} ${bids_dir} ${derivatives} participant \
--participant-label $subid \
 -w ${working_dir} \
 -t "video" \
 ${FMRIPREP_OPTS} 

echo -e "\n"
echo -e "\ndone"
echo -e "\n-------------------------------"
