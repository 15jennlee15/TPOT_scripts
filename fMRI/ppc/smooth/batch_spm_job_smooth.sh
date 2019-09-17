#!/bin/bash
#--------------------------------------------------------------
# This script executes $SHELL_SCRIPT for $SUB and matlab $SCRIPT
#	
# D.Cos 2018.11.06
#--------------------------------------------------------------

# Set your study scripts folder
STUDY=/projects/adapt_lab/shared/TPOT/TPOT_Scripts

# Set subject list
SUBJLIST=`cat test_subject_list.txt`

# Which SID should be replaced?
REPLACESID=TPOT002

# SPM Path
SPM_PATH=/projects/adapt_lab/shared/spm12

# Set tasks to smooth
TASKS=(affect video)

# Set MATLAB script path
for TASK in ${TASKS[@]};
SCRIPT="${STUDY}"/fMRI/ppc/smooth/smooth.m

# Set shell script to execute
SHELL_SCRIPT=spm_job.sh

# Tag the results files
RESULTS_INFIX=smooth

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${STUDY}/fMRI/ppc/smooth/output

if [ ! -d ${OUTPUTDIR} ]; then
	mkdir -p ${OUTPUTDIR}
fi

# Set job parameters
cpuspertask=1
mempercpu=8G

# Create and execute batch job
for SUB in $SUBJLIST; do
	
	# Set MATLAB script path
	for TASK in ${TASKS[@]};
		SCRIPT=${STUDY}/fMRI/ppc/smooth/smooth_${TASK}.m # update script name if applicable

		# Run task job
	 	sbatch --export ALL,REPLACESID=$REPLACESID,SCRIPT=$SCRIPT,SUB=$SUB,SPM_PATH=$SPM_PATH,  \
		 	--job-name=${RESULTS_INFIX} \
		 	-o ${OUTPUTDIR}/${SUB}_${RESULTS_INFIX}.log \
		 	--cpus-per-task=${cpuspertask} \
		 	--mem-per-cpu=${mempercpu} \
		 	--account=adapt_lab \
		 	${SHELL_SCRIPT}
	 	sleep .25
	 done
done
