#!/bin/bash

# This script will preprocess two diffusion imaging series with left-right & right-left phase encoding directions.

# It extracts b0 volumes from each sequence, estimates the susceptibility induced off-resonance field, corrects for eddy current-induced distortion & movement, and estimates diffusion parameters & models crossing fibers at each voxel.

# This script uses FSL tools topup, eddy, and dtifit.

# This script calls "acqparams.txt" and "index.txt".  The former specifies the phase encoding directions and total readout time; the latter tells the motion correction software which line in acqparams.txt applies to a given volume.  These are the same for each TAG subject and don't need to be respecified.

# load fsl
module load fsl

# Set directory names
datadir="/projects/adapt_lab/shared/TPOT/bids_data"
scriptsdir="/projects/adapt_lab/shared/TPOT/TPOT_Scripts/dMRI/preproc"
outputdir="/projects/adapt_lab/shared/TPOT/bids_data/derivatives/dMRI_preproc"

# Select options
masks="TRUE"

# Set error log file
errorlog=""$scriptsdir"/output/errorlog_preprocdiff.txt"

# Create error log file
touch "${errorlog}"

if [ $(ls "$datadir"/sub-"${subid}"/ses-1/dwi/*.nii.gz | wc -l) -eq 2 ]; then

# Extract B0 images from nifti files & combine in single volume.
mkdir -p "$outputdir"/"${subid}"/ses-1/
cd "$outputdir"/"${subid}"/ses-1/
cp -R "$datadir"/sub-"${subid}"/ses-1/dwi .
cd dwi/
echo making "${subid}" b0 image
fslroi sub-"${subid}"_ses-1_acq-rl_dwi.nii.gz b0_rl 0 -1 0 -1 0 -1 0 1
fslroi sub-"${subid}"_ses-1_acq-lr_dwi.nii.gz b0_lr 0 -1 0 -1 0 -1 0 1
fslmerge -a b0_rl_lr b0_rl.nii.gz b0_lr.nii.gz

# Running topup [make acqparams.txt]
echo running "${subid}" topup
topup --imain=b0_rl_lr.nii.gz --datain="$scriptsdir"/acqparams.txt --config=b02b0.cnf --out=topup_results --iout=b0_unwarped --fout=fieldmap_Hz

# Preparing for eddy
# Extract brain & create brain mask
echo creating "${subid}" nodif brain mask
fslmaths b0_unwarped.nii.gz -Tmean b0_unwarped_mean
bet b0_unwarped_mean.nii.gz b0_unwarped_brain -m
fslreorient2std b0_unwarped_brain_mask.nii.gz b0_unwarped_reoriented_brain_mask.nii.gz

# Combining both diffusion sequences
echo merging "${subid}" diffusion sequences
fslmerge -a diffusion_data sub-"${subid}"_ses-1_acq-rl_dwi.nii.gz sub-"${subid}"_ses-1_acq-lr_dwi.nii.gz

# Combining bvecs & bvals from both diffusion sequences
echo merging "${subid}" bvecs
rm bvecs # if this script has already been run this will create problems unless you remove previous bvecs
paste sub-"${subid}"_ses-1_acq-rl_dwi.bvec sub-"${subid}"_ses-1_acq-lr_dwi.bvec >> bvecs

echo merging "${subid}" bvals
rm bvals # if this script has already been run this will create problems unless you remove previous bvals
paste sub-"${subid}"_ses-1_acq-rl_dwi.bval sub-"${subid}"_ses-1_acq-lr_dwi.bval >> bvals


# Running eddy with outlier replacement
# Note: This step identifies slices with excessive motion and replaces them with Gaussian process predictions.  For motion correction without outlier replacement, simply remove --repol option.
echo running "${subid}" eddy
eddy_openmp-5.0.11 --imain=diffusion_data.nii.gz --mask=b0_unwarped_reoriented_brain_mask.nii.gz --acqp="$scriptsdir"/acqparams.txt --index="$scriptsdir"/index.txt --bvecs=bvecs --bvals=bvals --topup=topup_results --repol --out=eddy_corrected_data_repol

# Reorienting & renaming files
fslreorient2std eddy_corrected_data_repol.nii.gz data.nii.gz
cp b0_unwarped_reoriented_brain_mask.nii.gz nodif_brain_mask.nii.gz

# Prepping for registration
cd "$outputdir"/"${subid}"/ses-1/
cp -R "$datadir"/sub-"${subid}"/ses-1/anat .
cd "$outputdir"/"${subid}"/ses-1/anat
fslreorient2std sub-"${subid}"_ses-1_T1w.nii.gz sub-"${subid}"_ses-1_T1w_reoriented.nii.gz

# Skull stripping & brain extraction
echo "${subid}" skull stripping and brain extraction
standard_space_roi sub-"${subid}"_ses-1_T1w_reoriented.nii.gz mprage_ssroi -b
bet mprage_ssroi.nii.gz mprage_brain -f .2 -m

# Linear registration of mprage to standard space
mkdir reg
cd reg
echo "${subid}" linear registration mprage to MNI
/packages/fsl/5.0.9/fsl/bin/flirt -in "$outputdir"/"${subid}"/ses-1/anat/mprage_brain.nii.gz -ref /packages/fsl/5.0.9/fsl/data/standard/MNI152_T1_2mm_brain -out "$outputdir"/"${subid}"/ses-1/anat/reg/struct2mni -omat "$outputdir"/"${subid}"/ses-1/anat/reg/struct2mni.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

# Non-linear warp of linear registration
echo warping "${subid}" registration nonlinearly
fnirt --in=../sub-"${subid}"_ses-1_T1w_reoriented.nii.gz --aff=struct2mni.mat --cout=struct2mni_warp --ref=//packages/fsl/5.0.9/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz

# Inverting non-linear warp
echo inverting "${subid}" non-linear warp
invwarp --ref=../mprage_brain.nii.gz --warp=struct2mni_warp.nii.gz --out=mni2struct_warp

# Fitting diffusion tensors at each voxel.  This step outputs eigenvectors, mean diffusivity, & fractional anisotropy
echo fitting "${subid}" tensors at each voxel
cd "$outputdir"/"${subid}"/ses-1/dwi
dtifit -k data.nii.gz -o dti -m nodif_brain_mask.nii.gz -r bvecs -b bvals

# Linear registration of FA map to mprage
cd "$outputdir"/"${subid}"/ses-1/anat/reg
echo "${subid}" linear registration FA map to mprage
/packages/fsl/5.0.9/fsl/bin/flirt -in "$outputdir"/"${subid}"/ses-1/dwi/dti_FA.nii.gz -ref "$outputdir"/"${subid}"/ses-1/anat/mprage_brain.nii.gz -out FA2struct -omat FA2struct.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6 -interp trilinear

# Inverse of transformation above (i.e., creating image to transform standard-space masks into diffusion space)
echo inverting "${subid}" FA-to-structural transformation
/packages/fsl/5.0.9/fsl/bin/convert_xfm -omat struct2FA.mat -inverse "$outputdir"/"${subid}"/ses-1/anat/reg/FA2struct.mat


else
# Making a note of missing files in error log
echo "ERROR: no files; nothing to preprocess"
echo "$datadir"/sub-"${subid}"/ses-1/dwi: MISSING DIFFUSION SEQUENCES >> $errorlog
fi


