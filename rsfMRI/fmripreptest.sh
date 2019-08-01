#!/bin/bash
#
#SBATCH -J fmriprep
#SBATCH --array=1-257%7
#SBATCH --time=24:00:00
#SBATCH -n 1
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=4G
#SBATCH -A adapt_lab
# Outputs ----------------------------------
#SBATCH -o output/%x-%A-%a.out
#SBATCH -e output/%x-%A-%a.err
# ------------------------------------------
module load singularity

group=adapt_lab
group_dir=/projects/adapt_lab/shared
container=containers/fmriprep-1.4.1.simg
study="TPOT"
bids_dir="${group_dir}"/"${study}"/bids_data
derivatives="${bids_dir}"/derivatives
working_dir="${derivatives}"/working_bids_fmripreprest_test/
image="${group_dir}"/"${container}"
SUBJECT_LIST=subject_list.txt

# Create working directory
mkdir -p $working_dir

FMRIPREP_OPTS="--omp-nthreads 8 --nthreads 12 --mem_mb 30000 --ignore-aroma-denoising-errors --output-space T1w template fsaverage5 fsnative --template-resampling-grid 2mm --medial-surface-nan --cifti-output --use-aroma"

unset PYTHONPATH
export FS_LICENSE=/projects/adapt_lab/shared/TPOT/TPOT_Scripts/rsfMRI/license.txt
subject=$( sed "${SLURM_ARRAY_TASK_ID}q;d" ${SUBJECT_LIST} )
cmd="singularity run  --bind "${group_dir}":"${group_dir}" ${image} ${bids_dir} ${derivatives} participant --participant-label $subject -w ${working_dir} ${FMRIPREP_OPTS}"

echo Running task ${SLURM_ARRAY_TASK_ID}
echo Commandline: $cmd
eval $cmd
exitcode=$?
if [ "$exitcode" -ne "0" ]; then
echo "$subject" >> failed_subjects.${SLURM_ARRAY_JOB_ID}
echo "${SLURM_ARRAY_TASK_ID}" >> failed_taskids.${SLURM_ARRAY_JOB_ID}
fi
echo Finished tasks ${SLURM_ARRAY_TASK_ID} with exit code $exitcode