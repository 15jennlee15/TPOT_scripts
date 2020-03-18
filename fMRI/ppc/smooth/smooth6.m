%-----------------------------------------------------------------------
% Job saved on 17-Jan-2019 18:28:06 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6906)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/projects/adapt_lab/shared/TPOT/bids_data/derivatives/fmriprep/sub-TPOT002/ses-1/func'};
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 'sub-TPOT002_ses-1_task-affect_acq-1_run-.*-space-MNI152NLin2009cAsym_desc-preproc_bold.nii';
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/projects/adapt_lab/shared/TPOT/bids_data/derivatives/fmriprep/sub-TPOT002/ses-1/func'};
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 'sub-TPOT002_ses-1_task-affect_acq-2_run-.*-space-MNI152NLin2009cAsym_desc-preproc_bold.nii';
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{3}.spm.util.exp_frames.files(1) = cfg_dep(cfg_dep('File Selector (Batch Mode): Selected Files (sub-TPOT002_ses-1_task-affect_acq-1_run-.*-space-MNI152NLin2009cAsym_desc-preproc_bold.nii)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{3}.spm.util.exp_frames.frames = Inf;
matlabbatch{4}.spm.util.exp_frames.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (sub-TPOT002_ses-1_task-affect_acq-2_run-.*-space-MNI152NLin2009cAsym_desc-preproc_bold.nii)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{4}.spm.util.exp_frames.frames = Inf;
matlabbatch{5}.spm.spatial.smooth.data(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{5}.spm.spatial.smooth.fwhm = [6 6 6];
matlabbatch{5}.spm.spatial.smooth.dtype = 0;
matlabbatch{5}.spm.spatial.smooth.im = 0;
matlabbatch{5}.spm.spatial.smooth.prefix = 'sm6_';
matlabbatch{6}.spm.spatial.smooth.data(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{6}.spm.spatial.smooth.fwhm = [6 6 6];
matlabbatch{6}.spm.spatial.smooth.dtype = 0;
matlabbatch{6}.spm.spatial.smooth.im = 0;
matlabbatch{6}.spm.spatial.smooth.prefix = 'sm6_';