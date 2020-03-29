#!/bin/bash
#--------------------------------------------------------------
# This script executes $SHELL_SCRIPT for $SUB and matlab $SCRIPT
#	
# D.Cos 2018.11.06
#--------------------------------------------------------------

# Set your study scripts folder
STUDY=/projects/adapt_lab/shared/TPOT/TPOT_Scripts

# Set subject list
SUBJLIST=`cat subject_list2.txt`

# Which SID should be replaced?
REPLACESID=TPOT120

# SPM Path
SPM_PATH=/projects/adapt_lab/jlewis5/ERdissertation/spm12

# Set MATLAB script path
SCRIPT=/projects/adapt_lab/shared/TPOT/TPOT_Scripts/fMRI/ppc/smooth/smooth6_onerun.m

# Set shell script to execute
SHELL_SCRIPT=spm_job.sh

# Tag the results files
RESULTS_INFIX=smooth6

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${STUDY}/fMRI/ppc/smooth6/output

if [ ! -d ${OUTPUTDIR} ]; then
	mkdir -p ${OUTPUTDIR}
fi

# Set job parameters
cpuspertask=1
mempercpu=8G

# Create and execute batch job
for SUB in $SUBJLIST; do
# Set MATLAB script path
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
