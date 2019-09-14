#!/bin/bash
#
 
module load singularity
module load afni
module load ants
module load fsl
module load c3d
module load R
module load python3

cd /projects/adapt_lab/shared/TPOT/TPOT_Scripts/rsfMRI/xcpEngine

XCPEDIR=/projects/adapt_lab/shared/TPOT/TPOT_Scripts/rsfMRI/xcpEngine
SIMG=/projects/adapt_lab/shared/containers/xcpEngine.simg
HOME=/projects/adapt_lab/shared/TPOT

singularity run -B ${DATA_ROOT}:${HOME} $SIMG \
   -d ${HOME}/TPOT_Scripts/rsfMRI/xcpEngine/fc-ICA-AROMA_201901170904.dsn \
   -c "${TEMP_COHORT}",${ses},${run} \
   -o ${HOME}/bids_data/derivatives/xcpEngine/data \
   -t 1 \
   -i \$TMPDIR

rm "${TEMP_COHORT}",${ses},${run}
