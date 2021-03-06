%-----------------------------------------------------------------------
% Job saved on 15-Aug-2018 14:05:36 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------

%% select run 1 files
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/projects/adapt_lab/shared/TPOT/bids_data/derivatives/fmriprep/sub-TPOT002/ses-1/func'};
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 'sub-TPOT002_ses-1_task-affect_acq-1_run-.*_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz';
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';

%% unzip the files
matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (sub-TPOT002_ses-1_task-affect_acq-1_run-.*_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = true;

%% expand the frames
matlabbatch{3}.spm.util.exp_frames.files(1) = cfg_dep('Gunzip Files: Gunzipped Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{':'}));
matlabbatch{3}.spm.util.exp_frames.frames = Inf;

%% select run 2 files
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/projects/adapt_lab/shared/TPOT/bids_data/derivatives/fmriprep/sub-TPOT002/ses-1/func'};
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 'sub-TPOT002_ses-1_task-affect_acq-2_run-.*_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz';
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';

%% unzip the files
matlabbatch{5}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (sub-TPOT002_ses-1_task-affect_acq-2_run-.*_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{5}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
matlabbatch{5}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = true;

%% expand the frames
matlabbatch{6}.spm.util.exp_frames.files(1) = cfg_dep('Gunzip Files: Gunzipped Files', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{':'}));
matlabbatch{6}.spm.util.exp_frames.frames = Inf;

%% select brain mask file 
%NOTE: Only specifying brainmask from run-01 since they should be the same for every run (i.e. it is a standard brain mask). 
%Using run-01 instead acq-1 to make more robust.
matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/projects/adapt_lab/jlewis5/ERdissertation/spm12/canonical'};
matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 'MNI152_T1_1mm_brain_mask.nii.gz'; 
matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';

%% unzip the files
matlabbatch{8}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (MNI152_T1_1mm_brain_mask.nii.gz)', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{8}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
matlabbatch{8}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = true;

%% select auto_motion output for acq-1 and acq-2.
matlabbatch{9}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/projects/adapt_lab/shared/TPOT/TPOT_Scripts/fMRI/ppc/auto-motion-fmriprep/rp_txt'};
matlabbatch{9}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 'rp_TPOT002_1_affect_acq-1_1.txt';  % auto_motion output file run 1
matlabbatch{9}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{10}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/projects/adapt_lab/shared/TPOT/TPOT_Scripts/fMRI/ppc/auto-motion-fmriprep/rp_txt'};
matlabbatch{10}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 'rp_TPOT002_1_affect_acq-2_2.txt';  % auto_motion output file run 2
matlabbatch{10}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';

%% specify the model
matlabbatch{11}.spm.stats.fmri_spec.dir = {'/projects/adapt_lab/shared/TPOT/out/fx/affect/sub-TPOT002'};
matlabbatch{11}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{11}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{11}.spm.stats.fmri_spec.timing.fmri_t = 72;
matlabbatch{11}.spm.stats.fmri_spec.timing.fmri_t0 = 36;
matlabbatch{11}.spm.stats.fmri_spec.sess(1).scans(1) = cfg_dep('Smooth: Smoothed Images', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{11}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{11}.spm.stats.fmri_spec.sess(1).multi = {'/projects/adapt_lab/shared/TPOT/TPOT_Scripts/fMRI/fx/models/affect/sub-TPOT002_affect1.mat'};
matlabbatch{11}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{11}.spm.stats.fmri_spec.sess(1).multi_reg(1) = cfg_dep('File Selector (Batch Mode): Selected Files (sub-TPOT002_ses-1_task-affect_acq-1_run-.*_desc-confounds_regressors.txt)', substruct('.','val', '{}',{9}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{11}.spm.stats.fmri_spec.sess(1).hpf = 128;
matlabbatch{11}.spm.stats.fmri_spec.sess(2).scans(1) = cfg_dep('Smooth: Smoothed Images', substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{11}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{11}.spm.stats.fmri_spec.sess(2).multi = {'/projects/adapt_lab/shared/TPOT/TPOT_Scripts/fMRI/fx/models/affect/sub-TPOT002_affect2.mat'};
matlabbatch{11}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
matlabbatch{11}.spm.stats.fmri_spec.sess(2).multi_reg(1) = cfg_dep('File Selector (Batch Mode): Selected Files (sub-TPOT002_ses-1_task-affect_acq-2_run-.*_desc-confounds_regressors.txt)', substruct('.','val', '{}',{10}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{11}.spm.stats.fmri_spec.sess(2).hpf = 128;
matlabbatch{11}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{11}.spm.stats.fmri_spec.bases.hrf.derivs = [1 0];
matlabbatch{11}.spm.stats.fmri_spec.volt = 1;
matlabbatch{11}.spm.stats.fmri_spec.global = 'None';
matlabbatch{11}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{11}.spm.stats.fmri_spec.mask(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{11}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{11}.spm.stats.fmri_spec.cvi = 'FAST';

%% estimate the model (i.e. solve for the betas)
matlabbatch{12}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{14}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{12}.spm.stats.fmri_est.write_residuals = 1;
matlabbatch{12}.spm.stats.fmri_est.method.Classical = 1;

%% specify the contrasts of interest
matlabbatch{16}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{15}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{16}.spm.stats.con.consess{1}.tcon.name = '1_View>Blur';
matlabbatch{16}.spm.stats.con.consess{1}.tcon.weights = [0 0 0 0 0 0 1 0 1 0 1 0 -3 0 0 0];
matlabbatch{16}.spm.stats.con.consess{1}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{2}.tcon.name = '2_ViewHappy>Blur';
matlabbatch{16}.spm.stats.con.consess{2}.tcon.weights = [0 0 0 0 0 0 1 0 0 0 0 0 -1 0 0 0];
matlabbatch{16}.spm.stats.con.consess{2}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{3}.tcon.name = '3_ViewAngry>Blur';
matlabbatch{16}.spm.stats.con.consess{3}.tcon.weights = [0 0 0 0 0 0 0 0 1 0 0 0 -1 0 0 0];
matlabbatch{16}.spm.stats.con.consess{3}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{4}.tcon.name = '4_ViewSad>Blur';
matlabbatch{16}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 0];
matlabbatch{16}.spm.stats.con.consess{4}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{5}.tcon.name = '5_ViewHappy>ViewAngry';
matlabbatch{16}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0];
matlabbatch{16}.spm.stats.con.consess{5}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{6}.tcon.name = '6_ViewAngry>ViewSad';
matlabbatch{16}.spm.stats.con.consess{6}.tcon.weights = [0 0 0 0 0 0 0 0 1 0 -1 0 0 0 0 0];
matlabbatch{16}.spm.stats.con.consess{6}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{7}.tcon.name = '7_ViewSad>ViewHappy';
matlabbatch{16}.spm.stats.con.consess{7}.tcon.weights = [0 0 0 0 0 0 -1 0 0 0 1 0 0 0 0 0];
matlabbatch{16}.spm.stats.con.consess{7}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{8}.tcon.name = '8_Label>Blur';
matlabbatch{16}.spm.stats.con.consess{8}.tcon.weights = [1 0 1 0 1 0 0 0 0 0 0 0 -3 0 0 0];
matlabbatch{16}.spm.stats.con.consess{8}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{9}.tcon.name = '9_LabelHappy>Blur';
matlabbatch{16}.spm.stats.con.consess{9}.tcon.weights = [1 0 0 0 0 0 0 0 0 0 0 0 -1 0 0 0];
matlabbatch{16}.spm.stats.con.consess{9}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{10}.tcon.name = '10_LabelAngry>Blur';
matlabbatch{16}.spm.stats.con.consess{10}.tcon.weights = [0 0 1 0 0 0 0 0 0 0 0 0 -1 0 0 0];
matlabbatch{16}.spm.stats.con.consess{10}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{11}.tcon.name = '11_LabelSad>Blur';
matlabbatch{16}.spm.stats.con.consess{11}.tcon.weights = [0 0 0 0 1 0 0 0 0 0 0 0 -1 0 0 0];
matlabbatch{16}.spm.stats.con.consess{11}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{12}.tcon.name = '12_LabelHappy>LabelAngry';
matlabbatch{16}.spm.stats.con.consess{12}.tcon.weights = [1 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{16}.spm.stats.con.consess{12}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{13}.tcon.name = '13_LabelAngry>LabelSad';
matlabbatch{16}.spm.stats.con.consess{13}.tcon.weights = [0 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{16}.spm.stats.con.consess{13}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{14}.tcon.name = '14_LabelSad>LabelHappy';
matlabbatch{16}.spm.stats.con.consess{14}.tcon.weights = [-1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{16}.spm.stats.con.consess{14}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{15}.tcon.name = '15_Label>View';
matlabbatch{16}.spm.stats.con.consess{15}.tcon.weights = [1 0 1 0 1 0 -1 0 -1 0 -1 0 0 0 0 0];
matlabbatch{16}.spm.stats.con.consess{15}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{16}.tcon.name = '16_LabelHappy>ViewHappy';
matlabbatch{16}.spm.stats.con.consess{16}.tcon.weights = [1 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 0];
matlabbatch{16}.spm.stats.con.consess{16}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{17}.tcon.name = '17_LabelAngry>ViewAngry';
matlabbatch{16}.spm.stats.con.consess{17}.tcon.weights = [0 0 1 0 0 0 0 0 -1 0 0 0 0 0 0 0];
matlabbatch{16}.spm.stats.con.consess{17}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{18}.tcon.name = '18_LabelSad>ViewSad';
matlabbatch{16}.spm.stats.con.consess{18}.tcon.weights = [0 0 0 0 1 0 0 0 0 0 -1 0 0 0 0 0];
matlabbatch{16}.spm.stats.con.consess{18}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{19}.tcon.name = '19_ViewHappy>IB';
matlabbatch{16}.spm.stats.con.consess{19}.tcon.weights = [0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0];
matlabbatch{16}.spm.stats.con.consess{19}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{20}.tcon.name = '20_ViewAngry>IB';
matlabbatch{16}.spm.stats.con.consess{20}.tcon.weights = [0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0];
matlabbatch{16}.spm.stats.con.consess{20}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{21}.tcon.name = '21_ViewSad>IB';
matlabbatch{16}.spm.stats.con.consess{21}.tcon.weights = [0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0];
matlabbatch{16}.spm.stats.con.consess{21}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{22}.tcon.name = '22_LabelHappy>IB';
matlabbatch{16}.spm.stats.con.consess{22}.tcon.weights = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{16}.spm.stats.con.consess{22}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{23}.tcon.name = '23_LabelAngry>IB';
matlabbatch{16}.spm.stats.con.consess{23}.tcon.weights = [0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{16}.spm.stats.con.consess{23}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.consess{24}.tcon.name = '24_LabelSad>IB';
matlabbatch{16}.spm.stats.con.consess{24}.tcon.weights = [0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{16}.spm.stats.con.consess{24}.tcon.sessrep = 'replsc';
matlabbatch{16}.spm.stats.con.delete = 0;