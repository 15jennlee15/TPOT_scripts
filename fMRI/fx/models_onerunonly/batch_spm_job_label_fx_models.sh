#!/bin/bash
#--------------------------------------------------------------
# Inputs:
#	* STUDY = study name
#	* SUBJLIST = subject_list.txt
#	* SCRIPT = MATLAB script to create and execute batch job
#	* PROCESS = running locally, via qsub, or on the Mac Pro
#	* Edit output and error paths
#
# Outputs:
#	* Executes spm_job.sh for $SUB and $SCRIPT
#
# D.Cos 2017.3.7
#--------------------------------------------------------------


# Set your study here
STUDY=/projects/adapt_lab/shared/TPOT

# Set subject list
SUBJLIST=`cat subject_list.txt`

# Which SID should be replaced?
REPLACESID=TPOT015

# Set MATLAB script path
#COMPNAME=ralph #use this for help specifying paths to run locally
SCRIPT=${STUDY}/TPOT_Scripts/fMRI/fx/models_onerunonly/matlabbatch_job_label.m

#SPM Path
SPM_PATH=/projects/adapt_lab/jlewis5/ERdissertation/spm12

# Tag the results files
RESULTS_INFIX=fx_models_AL

# Set output dir
if [ ! -d "${STUDY}/TPOT_Scripts/fMRI/fx/models/affect/output_logs" ]; then
    mkdir -v "${STUDY}/TPOT_Scripts/fMRI/fx/models/affect/output_logs"
fi
OUTPUTDIR=${STUDY}/TPOT_Scripts/fMRI/fx/models/affect/output_logs

# make sid_batch dir if doesn't exist
if [ ! -d "${STUDY}/TPOT_Scripts/fMRI/fx/models/affect/sid_batches" ]; then
    mkdir -v "${STUDY}/TPOT_Scripts/fMRI/fx/models/affect/sid_batches"
fi

if [ ! -d "${STUDY}/TPOT_Scripts/fMRI/fx/models/affect/sid_batches/matlabbatch_job_label" ]; then
    mkdir -v "${STUDY}/TPOT_Scripts/fMRI/fx/models/affect/sid_batches/matlabbatch_job_label"
fi

# Set processor
# use "slurm" for Talapas
# use "serlocal" for local, serial processing
# use "parlocal" for local, parallel processing

PROCESS=slurm

# Only matters for parlocal
#MAXJOBS=8

# Only matters for slurm
cpuspertask=1
mempercpu=3G

# Create and execute batch job
if [ "${PROCESS}" == "slurm" ]; then 
	for SUB in $SUBJLIST
	do
		if [ ! -d "${STUDY}/out/fx/sub-${SUB}" ]; then
    		mkdir -v "${STUDY}/out/fx/sub-${SUB}"
		fi
		if [ ! -d "${STUDY}/out/fx/sub-${SUB}/affect" ]; then
    		mkdir -v "${STUDY}/out/fx/sub-${SUB}/affect"
		fi
	 echo "submitting via slurm"
	 sbatch -A adapt_lab \
		--export=ALL,REPLACESID=$REPLACESID,SCRIPT=$SCRIPT,SUB=$SUB,SPM_PATH=$SPM_PATH,PROCESS=$PROCESS  \
		 --job-name=${RESULTS_INFIX} \
		 -o "${OUTPUTDIR}"/"${SUB}"_${RESULTS_INFIX}.log \
		 --cpus-per-task=${cpuspertask} \
		 --mem-per-cpu=${mempercpu} \
		 spm_job_label.sh
	 sleep .25
	done
elif [ "${PROCESS}" == "serlocal" ]; then 
	for SUB in $SUBJLIST
	do
	 echo "submitting locally"
	 bash spm_job_label.sh ${REPLACESID} ${SCRIPT} ${SUB} > "${OUTPUTDIR}"/"${SUBJ}"_${RESULTS_INFIX}_output.txt 2> /"${OUTPUTDIR}"/"${SUBJ}"_${RESULTS_INFIX}_error.txt
	done
elif [ "${PROCESS}" == "parlocal" ]; then 
	parallel --verbose --results "${OUTPUTDIR}"/{}_${RESULTS_INFIX}_output -j${MAXJOBS} bash spm_job_label.sh ${REPLACESID} ${SCRIPT} :::: subject_list.txt
fi
