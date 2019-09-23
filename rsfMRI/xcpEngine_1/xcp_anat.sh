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
HOME=/projects/adapt_lab/shared/TPOT/TPOT_Scripts/rsfMRI/xcpEngine
bids_dir=/projects/adapt_lab/shared/TPOT/bids_data/derivatives

singularity run -B ${HOME}:${bids_dir} $SIMG \
   -d ${HOME}/anat-Complete_201908231455.dsn \
   -c "${TEMP_COHORT}",${ses} \
   -o ${bids_dir}/xcpEngine/data \
   -t 1 \
   -i \$TMPDIR

rm "${TEMP_COHORT}",${ses}