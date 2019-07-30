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

#for task in $tasks; do

echo -e "\nStarting on: $task"
echo -e "\n"

export FS_LICENSE=/projects/adapt_lab/shared/TPOT/TPOT_Scripts/rsfMRI/license.txt

singularity run --bind "${group_dir}":"${group_dir}" ${image} ${bids_dir} ${derivatives} participant \
--participant_label ${subid} \
 -w ${working_dir} \
 -t ${task} --use-aroma --write-graph \
--output-spaces T1w MNI152NLin2009cAsym MNI152NLin6Asym:res-2 fsaverage5 fsnative \
-n 1 --omp-nthreads 8 --nthreads 12 --mem_mb 30000 \
--write-graph \
--skip_bids_validation \
--fs-license-file $FS_LICENSE

echo -e "\n"
echo -e "\ndone"
echo -e "\n-------------------------------"

#done
